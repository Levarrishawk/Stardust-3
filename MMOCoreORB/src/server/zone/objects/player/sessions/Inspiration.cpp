#include "Inspiration.h"

#include <atomic>
#include <ctime>

#include "server/zone/ZoneServer.h"
#include "server/zone/managers/collision/CollisionManager.h"
#include "server/zone/managers/skill/PerformanceManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/buffs/Buff.h"
#include "server/zone/objects/creature/buffs/BuffType.h"
#include "server/zone/objects/player/sessions/EntertainingSession.h"
#include "server/zone/objects/player/sessions/InspirationSession.h"
#include "server/zone/packets/object/BuffBuilderChangeMessageCallback.h"
#include "server/zone/packets/object/ObjectControllerMessage.h"
#include "templates/params/creature/CreatureAttribute.h"

namespace {

constexpr int ATTENDANCE_TICK_MS = 10 * 1000;
constexpr int DURATION_INCREMENT_SECONDS = 10 * 60;
constexpr int MAX_DURATION_SECONDS = 5 * 60 * 60;
// Leave time to offer a build after a patron reaches the five-minute attendance cap.
constexpr int BUILD_TIMEOUT_SECONDS = 10 * 60;
constexpr int OFFER_TIMEOUT_SECONDS = 30;
constexpr int EFFECT_COUNT = InspirationState::EFFECT_COUNT;
constexpr int MAX_EFFECT_KEY_BYTES = 32;

std::atomic<uint32> nextSessionToken{0};

struct EffectOption {
	const char* key;
	int cost;
	int maxRank;
	int perRank;
};

constexpr EffectOption OPTIONS[EFFECT_COUNT] = {
	{ "constitution", 1, 4, 50 },
	{ "luck", 1, 5, 3 },
	{ "max_action", 2, 5, 40 },
	{ "secondary_defense", 2, 4, 5 },
	{ "healer", 2, 4, 3 },
	{ "resilience", 2, 4, 4 },
	{ "second_chance", 2, 4, 3 },
	{ "flush_with_success", 2, 5, 2 },
	{ "crafting_assembly", 1, 5, 3 },
	{ "amazing_success", 3, 4, 1 }
};

int getEffectIndex(const String& key) {
	for (int i = 0; i < EFFECT_COUNT; ++i) {
		if (key == OPTIONS[i].key)
			return i;
	}
	return -1;
}

int pointsSpent(const InspirationState::Ranks& ranks) {
	int points = 0;
	for (int i = 0; i < EFFECT_COUNT; ++i)
		points += ranks[i] * OPTIONS[i].cost;
	return points;
}

ManagedReference<InspirationSession*> getSession(CreatureObject* player) {
	return player->getActiveSession(SessionFacadeType::INSPIRATION).castTo<InspirationSession*>();
}

int getEarnedDuration(uint64 attendanceStart, uint64 now) {
	const uint64 elapsed = now > attendanceStart ? now - attendanceStart : 0;
	const uint64 ticks = Math::min(elapsed / ATTENDANCE_TICK_MS,
			static_cast<uint64>(MAX_DURATION_SECONDS / DURATION_INCREMENT_SECONDS));
	return ticks * DURATION_INCREMENT_SECONDS;
}

bool getTerms(CreatureObject* performer, CreatureObject* patron, uint64& attendanceStart, int& points) {
	if (!Inspiration::isAudienceMember(performer, patron) || !performer->isOnline() || !patron->isOnline()
			|| performer->isDead() || performer->isIncapacitated() || patron->isDead() || patron->isIncapacitated())
		return false;

	auto zone = performer->getZone();
	if (zone == nullptr || patron->getZone() != zone || !performer->isInRange(patron, PerformanceManager::HEAL_RANGE)
			|| !CollisionManager::checkLineOfSight(performer, patron))
		return false;

	ManagedReference<EntertainingSession*> session = performer->getActiveSession(SessionFacadeType::ENTERTAINING).castTo<EntertainingSession*>();
	if (session == nullptr || session->isPerformingOutro() || !session->canGiveEntertainBuff() || session->isInDenyServiceList(patron))
		return false;

	const bool dancing = session->isDancing();
	if (!dancing && (!session->isPlayingMusic() || performer->getPlayableInstrument() == nullptr))
		return false;

	const uint64 start = session->getEntertainerBuffStartTime(patron);
	if (start == 0 || (attendanceStart != 0 && attendanceStart != start))
		return false;

	const int skill = performer->getSkillMod(dancing ? "healing_dance_mind" : "healing_music_mind");
	if (skill <= 0)
		return false;

	attendanceStart = start;
	points = Math::min(20, 5 + skill / 8);
	return true;
}

void sendStart(CreatureObject* player, const InspirationState& state) {
	auto* message = new ObjectControllerMessage(player->getObjectID(), 0x1B, Inspiration::START_MESSAGE);
	message->insertLong(state.performerID);
	message->insertLong(state.patronID);
	message->insertInt(state.token);
	message->insertInt(state.points);
	message->insertInt(state.durationSeconds);
	player->sendMessage(message);
}

void sendUpdate(CreatureObject* player, const InspirationState& state, bool replacing, bool cancel = false) {
	auto* message = new ObjectControllerMessage(player->getObjectID(), 0x1B,
			cancel ? Inspiration::CANCEL_MESSAGE : Inspiration::CHANGE_MESSAGE);
	message->insertLong(state.performerID);
	message->insertLong(state.patronID);
	message->insertInt(state.token);
	message->insertInt(0); // Cover charge
	message->insertByte(!cancel && state.offered ? 1 : 0);
	message->insertInt(InspirationUpdate::SERVER);

	int count = 0;
	if (!cancel) {
		for (int rank : state.ranks) {
			if (rank > 0)
				++count;
		}
	}
	message->insertInt(count);

	if (!cancel) {
		for (int i = 0; i < EFFECT_COUNT; ++i) {
			if (state.ranks[i] == 0)
				continue;
			message->insertAscii(OPTIONS[i].key);
			message->insertInt(state.ranks[i]);
			message->insertInt(0); // NGE expertise modifier
		}

		const int offerSeconds = state.offered ? Math::max(0, static_cast<int>(state.deadline - time(nullptr))) : 0;
		message->insertInt(state.points);
		message->insertInt(state.durationSeconds);
		message->insertInt(offerSeconds);
		message->insertByte(replacing ? 1 : 0);
	}

	player->sendMessage(message);
}

// The participant write locks protect the same transient session on both players.
void closeSession(CreatureObject* first, CreatureObject* second, InspirationSession* session) {
	const InspirationState& state = *session->getInspirationState();
	for (CreatureObject* participant : { first, second }) {
		if (participant == nullptr || getSession(participant) != session)
			continue;
		participant->dropActiveSession(SessionFacadeType::INSPIRATION);
		if (participant->isOnline())
			sendUpdate(participant, state, false, true);
	}
}

void scheduleExpiry(CreatureObject* performer, CreatureObject* patron, int token, bool offered) {
	WeakReference<CreatureObject*> weakPerformer = performer;
	WeakReference<CreatureObject*> weakPatron = patron;
	const int delay = (offered ? OFFER_TIMEOUT_SECONDS : BUILD_TIMEOUT_SECONDS) * 1000;

	Core::getTaskManager()->scheduleTask([weakPerformer, weakPatron, token, offered] {
		ManagedReference<CreatureObject*> performer = weakPerformer.get();
		ManagedReference<CreatureObject*> patron = weakPatron.get();
		CreatureObject* first = performer != nullptr ? performer.get() : patron.get();
		CreatureObject* second = performer != nullptr ? patron.get() : nullptr;
		if (first == nullptr)
			return;

		Locker firstLocker(first);
		Locker secondLocker(second != nullptr ? second : first, first);
		ManagedReference<InspirationSession*> session = getSession(first);
		if (session == nullptr)
			return;

		const InspirationState& state = *session->getInspirationState();
		if (state.token == token && state.offered == offered)
			closeSession(first, second, session);
	}, "InspirationExpiry", delay);
}

void scheduleDurationUpdate(CreatureObject* performer, CreatureObject* patron, const InspirationState& state) {
	if (state.durationSeconds >= MAX_DURATION_SECONDS)
		return;

	const uint64 now = Time(Time::MONOTONIC_TIME).getMiliTime();
	const uint64 nextTick = state.attendanceStart + (state.durationSeconds / DURATION_INCREMENT_SECONDS + 1) * ATTENDANCE_TICK_MS;
	const uint64 delay = nextTick > now ? nextTick - now : 1;
	const int token = state.token;
	WeakReference<CreatureObject*> weakPerformer = performer;
	WeakReference<CreatureObject*> weakPatron = patron;

	Core::getTaskManager()->scheduleTask([weakPerformer, weakPatron, token] {
		ManagedReference<CreatureObject*> performer = weakPerformer.get();
		ManagedReference<CreatureObject*> patron = weakPatron.get();
		if (performer == nullptr || patron == nullptr)
			return;

		Locker performerLocker(performer);
		Locker patronLocker(patron, performer);
		ManagedReference<InspirationSession*> session = getSession(performer);
		if (session == nullptr || session->getInspirationState()->token != token)
			return;

		InspirationState& state = *session->getInspirationState();
		int budget = 0;
		if (getSession(patron) != session || time(nullptr) >= state.deadline
				|| !getTerms(performer, patron, state.attendanceStart, budget)) {
			closeSession(performer, patron, session);
			return;
		}

		const int duration = getEarnedDuration(state.attendanceStart, Time(Time::MONOTONIC_TIME).getMiliTime());
		if (duration != state.durationSeconds) {
			state.durationSeconds = duration;
			const bool replacing = patron->hasBuff(Inspiration::BUFF_CRC);
			sendUpdate(performer, state, replacing);
			sendUpdate(patron, state, replacing);
		}

		scheduleDurationUpdate(performer, patron, state);
	}, "InspirationDuration", delay);
}

void applyBuff(CreatureObject* patron, const InspirationState& state) {
	const int previousAction = patron->getHAM(CreatureAttribute::ACTION);
	ManagedReference<Buff*> buff = new Buff(patron, Inspiration::BUFF_CRC, state.durationSeconds, BuffType::PERFORMANCE);
	Locker locker(buff);

	for (int i = 0; i < EFFECT_COUNT; ++i) {
		const int value = state.ranks[i] * OPTIONS[i].perRank;
		if (value == 0)
			continue;

		switch (i) {
		case InspirationState::CONSTITUTION:
			buff->setAttributeModifier(CreatureAttribute::CONSTITUTION, value);
			break;
		case InspirationState::LUCK:
			buff->setSkillModifier("luck", value);
			break;
		case InspirationState::MAX_ACTION:
			buff->setAttributeModifier(CreatureAttribute::ACTION, value);
			break;
		case InspirationState::SECONDARY_DEFENSE:
			buff->setSkillModifier(Inspiration::SECONDARY_DEFENSE, value);
			break;
		case InspirationState::HEALER:
			buff->setSkillModifier("private_inspiration_healing", value);
			break;
		case InspirationState::RESILIENCE:
			buff->setSkillModifier("absorption_bleeding", value);
			buff->setSkillModifier("absorption_fire", value);
			break;
		case InspirationState::SECOND_CHANCE:
			buff->setSkillModifier(Inspiration::SECOND_CHANCE, value);
			break;
		case InspirationState::EXPERIENCE:
			buff->setSkillModifier(Inspiration::EXPERIENCE, value);
			break;
		case InspirationState::ASSEMBLY:
			buff->setSkillModifier(Inspiration::ASSEMBLY, value);
			break;
		case InspirationState::AMAZING_SUCCESS:
			buff->setSkillModifier(Inspiration::AMAZING_SUCCESS, value);
			break;
		}
	}

	patron->addBuff(buff);
	locker.release();

	// Replacing an Action buff can clip the current pool while the old maximum is removed.
	const int lostAction = previousAction - patron->getHAM(CreatureAttribute::ACTION);
	if (state.ranks[InspirationState::MAX_ACTION] > 0 && lostAction > 0)
		patron->healDamage(patron, CreatureAttribute::ACTION, lostAction, true, false);

	patron->removeBuff(STRING_HASHCODE("performance_enhance_dance_mind"));
	patron->removeBuff(STRING_HASHCODE("performance_enhance_music_focus"));
	patron->removeBuff(STRING_HASHCODE("performance_enhance_music_willpower"));
}

}

bool Inspiration::isAudienceMember(CreatureObject* performer, CreatureObject* patron) {
	if (performer == nullptr || patron == nullptr || performer == patron || !performer->isPlayerCreature() || !patron->isPlayerCreature())
		return false;

	const uint64 performerID = performer->getObjectID();
	return (performer->isDancing() && patron->getWatchToID() == performerID)
			|| (performer->isPlayingMusic() && patron->getListenID() == performerID);
}

void Inspiration::open(CreatureObject* performer, CreatureObject* patron) {
	if (performer == nullptr)
		return;

	if (patron == nullptr || patron == performer) {
		performer->sendSystemMessage("Target a player who is watching or listening to your performance.");
		return;
	}

	Locker performerLocker(performer);
	Locker patronLocker(patron, performer);
	InspirationState state;
	if (!getTerms(performer, patron, state.attendanceStart, state.points)) {
		performer->sendSystemMessage("Inspiration requires an eligible performance and a nearby patron who is watching or listening.");
		return;
	}

	if (getSession(performer) != nullptr || getSession(patron) != nullptr) {
		performer->sendSystemMessage("Finish the current Inspiration session before starting another.");
		return;
	}

	state.performerID = performer->getObjectID();
	state.patronID = patron->getObjectID();
	state.token = nextSessionToken.fetch_add(1) % 0x7FFFFFFF + 1;
	state.durationSeconds = getEarnedDuration(state.attendanceStart, Time(Time::MONOTONIC_TIME).getMiliTime());
	state.deadline = time(nullptr) + BUILD_TIMEOUT_SECONDS;

	ManagedReference<InspirationSession*> session = new InspirationSession();
	*session->getInspirationState() = state;
	performer->addActiveSession(SessionFacadeType::INSPIRATION, session);
	patron->addActiveSession(SessionFacadeType::INSPIRATION, session);

	const bool replacing = patron->hasBuff(BUFF_CRC);
	sendStart(performer, state);
	sendStart(patron, state);
	sendUpdate(performer, state, replacing);
	sendUpdate(patron, state, replacing);
	scheduleExpiry(performer, patron, state.token, false);
	scheduleDurationUpdate(performer, patron, state);
}

void Inspiration::handleUpdate(CreatureObject* player, const InspirationUpdate& update, bool cancel) {
	Locker playerLocker(player);
	ManagedReference<InspirationSession*> session = getSession(player);
	if (session == nullptr)
		return;

	InspirationState& state = *session->getInspirationState();
	if (state.token != update.token || state.performerID != update.performerID || state.patronID != update.patronID)
		return;

	const uint64 playerID = player->getObjectID();
	const bool fromPerformer = playerID == state.performerID;
	if (!fromPerformer && playerID != state.patronID)
		return;

	if (update.origin != (fromPerformer ? InspirationUpdate::PERFORMER : InspirationUpdate::PATRON))
		return;

	ZoneServer* zoneServer = player->getZoneServer();
	const uint64 peerID = fromPerformer ? state.patronID : state.performerID;
	ManagedReference<CreatureObject*> peer = zoneServer != nullptr ? zoneServer->getObject(peerID).castTo<CreatureObject*>() : nullptr;
	if (peer == nullptr) {
		closeSession(player, nullptr, session);
		return;
	}

	Locker peerLocker(peer, player);
	if (getSession(player) != session)
		return;

	if (cancel || getSession(peer) != session) {
		closeSession(player, peer, session);
		return;
	}

	CreatureObject* performer = fromPerformer ? player : peer.get();
	CreatureObject* patron = fromPerformer ? peer.get() : player;

	int budget = 0;
	if (time(nullptr) >= state.deadline || !getTerms(performer, patron, state.attendanceStart, budget)) {
		player->sendSystemMessage("This Inspiration session is no longer available.");
		closeSession(performer, patron, session);
		return;
	}

	const int duration = getEarnedDuration(state.attendanceStart, Time(Time::MONOTONIC_TIME).getMiliTime());
	const bool replacing = patron->hasBuff(BUFF_CRC);
	if (state.offered) {
		if (fromPerformer || !update.accepted || !update.valid || update.ranks != state.ranks) {
			sendUpdate(player, state, replacing);
			return;
		}

		if (pointsSpent(state.ranks) > budget || duration == 0) {
			patron->sendSystemMessage("The performer can no longer grant the offered Inspiration.");
		} else {
			state.durationSeconds = duration;
			applyBuff(patron, state);
			patron->sendSystemMessage("You accepted Inspiration from " + performer->getFirstName() + ".");
			performer->sendSystemMessage(patron->getFirstName() + " accepted your Inspiration.");
		}

		closeSession(performer, patron, session);
		return;
	}

	if (!fromPerformer) {
		sendUpdate(player, state, replacing);
		return;
	}

	state.points = budget;
	state.durationSeconds = duration;
	const int proposedPoints = pointsSpent(update.ranks);
	if (!update.valid || proposedPoints > budget || (update.accepted && proposedPoints == 0)) {
		if (pointsSpent(state.ranks) > budget)
			state.ranks.fill(0);
		performer->sendSystemMessage("Choose valid effects within the available Inspiration points before offering a build.");
	} else {
		state.ranks = update.ranks;
		if (update.accepted && duration == 0) {
			performer->sendSystemMessage("Your patron must watch or listen for 10 seconds before you can offer Inspiration.");
		} else if (update.accepted) {
			state.offered = true;
			state.deadline = time(nullptr) + OFFER_TIMEOUT_SECONDS;
			scheduleExpiry(performer, patron, state.token, true);
		}
	}

	sendUpdate(performer, state, replacing);
	sendUpdate(patron, state, replacing);
}

void Inspiration::attendanceEnded(CreatureObject* performer, CreatureObject* patron) {
	ManagedReference<InspirationSession*> session = getSession(patron);
	if (session == nullptr)
		return;

	const InspirationState& state = *session->getInspirationState();
	if (state.performerID == performer->getObjectID() && state.patronID == patron->getObjectID())
		closeSession(performer, patron, session);
}

void BuffBuilderChangeMessageCallback::parse(Message* message) {
	// Four bytes of controller time, then the native fixed header.
	if (message->size() - message->getOffset() < 37)
		return;

	message->shiftOffset(4);
	update.performerID = message->parseLong();
	update.patronID = message->parseLong();
	update.token = message->parseInt();
	const int cover = message->parseInt();
	const uint8 accepted = message->parseByte();
	update.accepted = accepted == 1;
	update.origin = message->parseInt();
	const int count = message->parseInt();
	if (count < 0 || count > EFFECT_COUNT)
		return;

	update.valid = cover == 0 && accepted <= 1;
	for (int i = 0; i < count; ++i) {
		if (message->size() - message->getOffset() < 2)
			return;

		const int length = message->parseShort(message->getOffset());
		if (length < 1 || length > MAX_EFFECT_KEY_BYTES || message->size() - message->getOffset() < length + 10)
			return;

		String key;
		message->parseAscii(key);
		const int rank = message->parseInt();
		message->parseInt(); // The server does its own effect calculation.

		const int effect = getEffectIndex(key);
		if (effect < 0 || rank < 1 || rank > OPTIONS[effect].maxRank || update.ranks[effect] != 0)
			update.valid = false;
		else
			update.ranks[effect] = rank;
	}

	parsed = !message->hasData();
}

void BuffBuilderChangeMessageCallback::run() {
	if (!parsed)
		return;

	ManagedReference<CreatureObject*> player = client->getPlayer();
	if (player != nullptr)
		Inspiration::handleUpdate(player, update, cancel);
}
