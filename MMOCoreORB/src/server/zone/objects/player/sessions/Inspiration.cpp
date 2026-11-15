#include "Inspiration.h"

#include <array>
#include <ctime>

#include "server/zone/ZoneServer.h"
#include "server/zone/managers/collision/CollisionManager.h"
#include "server/zone/managers/skill/PerformanceManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/buffs/Buff.h"
#include "server/zone/objects/creature/buffs/BuffType.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/sessions/EntertainingSession.h"
#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/player/sui/SuiWindowType.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "templates/params/creature/CreatureAttribute.h"

namespace {

constexpr int MIN_ATTENDANCE_SECONDS = 60;
constexpr int BUILD_TIMEOUT_SECONDS = 5 * 60;
constexpr int OFFER_TIMEOUT_SECONDS = 30;

enum Effect {
	CONSTITUTION,
	LUCK,
	MAX_ACTION,
	SECONDARY_DEFENSE,
	HEALER,
	RESILIENCE,
	SECOND_CHANCE,
	EXPERIENCE,
	ASSEMBLY,
	AMAZING_SUCCESS,
	EFFECT_COUNT
};

struct EffectOption {
	const char* name;
	const char* unit;
	int cost;
	int maxRank;
	int perRank;
};

constexpr EffectOption OPTIONS[EFFECT_COUNT] = {
	{ "Constitution", "", 1, 4, 50 },
	{ "Luck", "", 1, 5, 3 },
	{ "Max Action", "", 2, 5, 40 },
	{ "Dodge, Block, and Counter", " defense", 2, 4, 5 },
	{ "Healer", "% stimpack healing", 2, 4, 3 },
	{ "Resilience", "% bleeding and fire absorption", 2, 4, 4 },
	{ "Second Chance", "% chance to recover Health", 2, 4, 3 },
	{ "Flush with Success", "% eligible XP", 2, 5, 2 },
	{ "Crafting Assembly", " assembly skill", 1, 5, 3 },
	{ "Amazing Success Chance", " percentage points", 3, 4, 1 }
};

struct Build {
	uint64 performerID = 0;
	uint64 patronID = 0;
	int attendanceStart = 0;
	time_t deadline = 0;
	int durationMinutes = 0;
	std::array<int, EFFECT_COUNT> ranks{};

	int pointsSpent() const {
		int spent = 0;
		for (int i = 0; i < EFFECT_COUNT; ++i)
			spent += ranks[i] * OPTIONS[i].cost;
		return spent;
	}
};

bool getTerms(CreatureObject* performer, CreatureObject* patron, Build& build, int& points, int& duration) {
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

	const int performance = dancing ? PerformanceType::DANCE : PerformanceType::MUSIC;
	const int start = session->getEntertainerBuffStartTime(patron, performance);
	if (start <= 0 || time(nullptr) - start < MIN_ATTENDANCE_SECONDS
			|| (build.attendanceStart != 0 && build.attendanceStart != start))
		return false;

	const int skill = performer->getSkillMod(dancing ? "healing_dance_mind" : "healing_music_mind");
	duration = session->getEntertainerBuffDuration(patron, performance);
	if (skill <= 0 || duration <= 0)
		return false;

	build.attendanceStart = start;
	points = Math::min(20, 5 + skill / 8);
	return true;
}

String describeEffect(int effect, int rank) {
	const EffectOption& option = OPTIONS[effect];
	StringBuffer description;
	description << option.name << " +" << rank * option.perRank << option.unit;
	return description.toString();
}

int getSelectedRow(Vector<UnicodeString>* args) {
	if (args == nullptr || args->size() == 0)
		return -1;

	const String selection = args->get(0).toString();
	if (selection.length() == 0 || selection.length() > 2)
		return -1;

	int row = 0;
	for (int i = 0; i < selection.length(); ++i) {
		const char digit = selection.charAt(i);
		if (digit < '0' || digit > '9')
			return -1;
		row = row * 10 + digit - '0';
	}
	return row;
}

void applyBuff(CreatureObject* patron, const Build& build) {
	const int previousAction = patron->getHAM(CreatureAttribute::ACTION);
	ManagedReference<Buff*> buff = new Buff(patron, Inspiration::BUFF_CRC, build.durationMinutes * 60, BuffType::PERFORMANCE);
	Locker locker(buff);

	for (int i = 0; i < EFFECT_COUNT; ++i) {
		const int value = build.ranks[i] * OPTIONS[i].perRank;
		if (value == 0)
			continue;

		switch (i) {
		case CONSTITUTION:
			buff->setAttributeModifier(CreatureAttribute::CONSTITUTION, value);
			break;
		case LUCK:
			buff->setSkillModifier("luck", value);
			break;
		case MAX_ACTION:
			buff->setAttributeModifier(CreatureAttribute::ACTION, value);
			break;
		case SECONDARY_DEFENSE:
			buff->setSkillModifier(Inspiration::SECONDARY_DEFENSE, value);
			break;
		case HEALER:
			buff->setSkillModifier("private_inspiration_healing", value);
			break;
		case RESILIENCE:
			buff->setSkillModifier("absorption_bleeding", value);
			buff->setSkillModifier("absorption_fire", value);
			break;
		case SECOND_CHANCE:
			buff->setSkillModifier(Inspiration::SECOND_CHANCE, value);
			break;
		case EXPERIENCE:
			buff->setSkillModifier(Inspiration::EXPERIENCE, value);
			break;
		case ASSEMBLY:
			buff->setSkillModifier(Inspiration::ASSEMBLY, value);
			break;
		case AMAZING_SUCCESS:
			buff->setSkillModifier(Inspiration::AMAZING_SUCCESS, value);
			break;
		}
	}

	patron->addBuff(buff);
	locker.release();

	// Replacing an Action buff can clip the current pool while the old maximum is removed.
	const int lostAction = previousAction - patron->getHAM(CreatureAttribute::ACTION);
	if (build.ranks[MAX_ACTION] > 0 && lostAction > 0)
		patron->healDamage(patron, CreatureAttribute::ACTION, lostAction, true, false);

	patron->removeBuff(STRING_HASHCODE("performance_enhance_dance_mind"));
	patron->removeBuff(STRING_HASHCODE("performance_enhance_music_focus"));
	patron->removeBuff(STRING_HASHCODE("performance_enhance_music_willpower"));
}

class InspirationOfferCallback : public SuiCallback {
	Build build;

public:
	InspirationOfferCallback(ZoneServer* server, const Build& value) : SuiCallback(server), build(value) {
	}

	bool hasExpired() const {
		return time(nullptr) >= build.deadline;
	}

	void run(CreatureObject* patron, SuiBox*, uint32 eventIndex, Vector<UnicodeString>*) override {
		if (eventIndex != 0 || patron->getObjectID() != build.patronID)
			return;

		ManagedReference<CreatureObject*> performer = server->getObject(build.performerID).castTo<CreatureObject*>();
		if (performer == nullptr || performer == patron) {
			patron->sendSystemMessage("This Inspiration offer is no longer available.");
			return;
		}

		Locker locker(performer, patron);
		ManagedReference<PlayerObject*> ghost = patron->getPlayerObject();
		if (ghost == nullptr || ghost->hasSuiBoxWindowType(SuiWindowType::INSPIRATION_OFFER))
			return;

		int points = 0;
		int duration = 0;
		const int spent = build.pointsSpent();
		if (hasExpired() || build.durationMinutes <= 0 || !getTerms(performer, patron, build, points, duration)
				|| spent <= 0 || spent > points || duration < build.durationMinutes) {
			patron->sendSystemMessage("This Inspiration offer is no longer available.");
			return;
		}

		applyBuff(patron, build);
		patron->sendSystemMessage("You accepted Inspiration from " + performer->getFirstName() + ".");
		performer->sendSystemMessage(patron->getFirstName() + " accepted your Inspiration.");
	}
};

void sendOffer(CreatureObject* performer, CreatureObject* patron, Build build, int duration) {
	ManagedReference<PlayerObject*> ghost = patron->getPlayerObject();
	if (ghost == nullptr)
		return;

	ManagedReference<SuiBox*> currentOffer = ghost->getSuiBoxFromWindowType(SuiWindowType::INSPIRATION_OFFER);
	if (currentOffer != nullptr) {
		Reference<SuiCallback*> callback = currentOffer->getCallback();
		auto* offer = cast<InspirationOfferCallback*>(callback.get());
		if (offer != nullptr && !offer->hasExpired()) {
			performer->sendSystemMessage("That patron already has a pending Inspiration offer.");
			return;
		}
		ghost->closeSuiWindowType(SuiWindowType::INSPIRATION_OFFER);
	}

	build.durationMinutes = duration;
	build.deadline = time(nullptr) + OFFER_TIMEOUT_SECONDS;

	StringBuffer prompt;
	prompt << performer->getFirstName() << " offers you " << duration << " minutes of Inspiration.\n";
	for (int i = 0; i < EFFECT_COUNT; ++i) {
		if (build.ranks[i] > 0)
			prompt << "\n" << describeEffect(i, build.ranks[i]);
	}
	prompt << "\n\nAccept within " << OFFER_TIMEOUT_SECONDS << " seconds.";
	if (patron->hasBuff(Inspiration::BUFF_CRC))
		prompt << " Accepting replaces your current Inspiration.";

	ManagedReference<SuiMessageBox*> box = new SuiMessageBox(patron, SuiWindowType::INSPIRATION_OFFER);
	box->setPromptTitle("Inspiration Offer");
	box->setPromptText(prompt.toString());
	box->setCancelButton(true, "@cancel");
	box->setUsingObject(performer);
	box->setForceCloseDistance(PerformanceManager::HEAL_RANGE);
	box->setCallback(new InspirationOfferCallback(patron->getZoneServer(), build));
	ghost->addSuiBox(box);
	patron->sendMessage(box->generateMessage());
	performer->sendSystemMessage("You offered Inspiration to " + patron->getFirstName() + ".");
}

void showBuilder(CreatureObject* performer, CreatureObject* patron, const Build& build, int points, int duration, int effect = -1);

class InspirationBuilderCallback : public SuiCallback {
	Build build;
	int effect;

public:
	InspirationBuilderCallback(ZoneServer* server, const Build& value, int selectedEffect)
			: SuiCallback(server), build(value), effect(selectedEffect) {
	}

	void run(CreatureObject* performer, SuiBox* box, uint32 eventIndex, Vector<UnicodeString>* args) override {
		if (eventIndex != 0 || performer->getObjectID() != build.performerID)
			return;

		const int row = getSelectedRow(args);
		auto* list = cast<SuiListBox*>(box);
		if (list == nullptr || row < 0 || row >= list->getMenuSize())
			return;

		ManagedReference<CreatureObject*> patron = server->getObject(build.patronID).castTo<CreatureObject*>();
		if (patron == nullptr || patron == performer) {
			performer->sendSystemMessage("This patron is no longer available for Inspiration.");
			return;
		}

		Locker locker(patron, performer);
		ManagedReference<PlayerObject*> ghost = performer->getPlayerObject();
		if (ghost == nullptr || ghost->hasSuiBoxWindowType(SuiWindowType::INSPIRATION_BUILDER))
			return;

		int points = 0;
		int duration = 0;
		if (time(nullptr) >= build.deadline || !getTerms(performer, patron, build, points, duration)) {
			performer->sendSystemMessage("This patron is no longer available for Inspiration.");
			return;
		}

		const int spent = build.pointsSpent();
		if (effect >= 0) {
			const EffectOption& option = OPTIONS[effect];
			const int otherPoints = spent - build.ranks[effect] * option.cost;
			if (row <= option.maxRank && (row == 0 || otherPoints + row * option.cost <= points))
				build.ranks[effect] = row;
			showBuilder(performer, patron, build, points, duration);
		} else if (row > 0) {
			showBuilder(performer, patron, build, points, duration, row - 1);
		} else if (spent > 0 && spent <= points) {
			sendOffer(performer, patron, build, duration);
		} else {
			performer->sendSystemMessage("Select at least one effect and stay within the point budget.");
			showBuilder(performer, patron, build, points, duration);
		}
	}
};

void showBuilder(CreatureObject* performer, CreatureObject* patron, const Build& build, int points, int duration, int effect) {
	ManagedReference<PlayerObject*> ghost = performer->getPlayerObject();
	if (ghost == nullptr)
		return;

	ManagedReference<SuiListBox*> box = new SuiListBox(performer, SuiWindowType::INSPIRATION_BUILDER);
	box->setPromptTitle("Build Inspiration");
	box->setCancelButton(true, "@cancel");
	box->setUsingObject(patron);
	box->setForceCloseDistance(PerformanceManager::HEAL_RANGE);

	const int spent = build.pointsSpent();
	StringBuffer prompt;
	prompt << "Patron: " << patron->getFirstName() << "\nPoints: " << spent << "/" << points
			<< "\nDuration: " << duration << " minutes\n\n";

	if (effect < 0) {
		prompt << "Select an effect to change its rank, or offer the current build.";
		box->addMenuItem("Offer Inspiration");
		for (int i = 0; i < EFFECT_COUNT; ++i)
			box->addMenuItem(describeEffect(i, build.ranks[i]));
	} else {
		const EffectOption& option = OPTIONS[effect];
		const int availablePoints = points - spent + build.ranks[effect] * option.cost;
		prompt << "Choose a rank for " << option.name << ".";
		box->addMenuItem("Rank 0 (remove effect)");
		for (int rank = 1; rank <= option.maxRank && rank * option.cost <= availablePoints; ++rank) {
			StringBuffer optionText;
			optionText << "Rank " << rank << ": " << describeEffect(effect, rank) << " (" << rank * option.cost << " points)";
			box->addMenuItem(optionText.toString());
		}
	}

	box->setPromptText(prompt.toString());
	box->setCallback(new InspirationBuilderCallback(performer->getZoneServer(), build, effect));
	ghost->addSuiBox(box);
	performer->sendMessage(box->generateMessage());
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
	Build build;
	int points = 0;
	int duration = 0;
	if (!getTerms(performer, patron, build, points, duration)) {
		performer->sendSystemMessage("Inspiration requires an eligible performance and a nearby patron who has watched or listened for at least one minute.");
		return;
	}

	ManagedReference<PlayerObject*> ghost = performer->getPlayerObject();
	if (ghost == nullptr)
		return;

	build.performerID = performer->getObjectID();
	build.patronID = patron->getObjectID();
	build.deadline = time(nullptr) + BUILD_TIMEOUT_SECONDS;
	ghost->closeSuiWindowType(SuiWindowType::INSPIRATION_BUILDER);
	showBuilder(performer, patron, build, points, duration);
}
