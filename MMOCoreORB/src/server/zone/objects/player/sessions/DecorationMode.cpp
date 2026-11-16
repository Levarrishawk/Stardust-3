#include "DecorationMode.h"
#include "DecorationRequest.h"
#include "server/zone/objects/player/sessions/DecorationSession.h"

#include <atomic>
#include <cmath>
#include "conf/ConfigManager.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/managers/collision/CollisionManager.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "engine/service/proto/BaseMessage.h"

namespace {
enum Result { OPENED, SELECTED, MOVED, ENDED, REJECTED, STALE, COLLISION, EXPIRED, ROTATED };
std::atomic<uint64> nextToken{0};

ManagedReference<DecorationSession*> sessionFor(CreatureObject* player) {
	return player->getActiveSession(SessionFacadeType::DECORATION).castTo<DecorationSession*>();
}

bool enabled() {
	return ConfigManager::instance()->getBool("Core3.StructureManager.EnableDecorationMode", false);
}

// Fifteen payload fields, preceded by the GameNetworkMessage operand count and name CRC.
// Client coordinates: x = server X, y = server Z (up), z = server Y.
void reply(CreatureObject* player, const DecorationState& state, uint32 request, int result,
		SceneObject* target = nullptr) {
	if (player->getClient() == nullptr) return;
	BaseMessage* message = new BaseMessage();
	message->insertShort(16);
	message->insertInt(String::hashCode("StardustDecorationResult"));
	message->insertInt(1);
	message->insertInt(result);
	message->insertLong(state.token);
	message->insertInt(request);
	message->insertLong(state.buildingID);
	message->insertLong(target ? target->getObjectID() : 0);
	message->insertLong(target ? target->getParentID() : 0);
	message->insertInt(target ? target->getMovementCounter() : 0);
	message->insertFloat(target ? target->getPositionX() : 0);
	message->insertFloat(target ? target->getPositionZ() : 0);
	message->insertFloat(target ? target->getPositionY() : 0);
	message->insertFloat(target ? target->getDirectionX() : 0);
	message->insertFloat(target ? target->getDirectionY() : 0);
	message->insertFloat(target ? target->getDirectionZ() : 0);
	message->insertFloat(target ? target->getDirectionW() : 1);
	player->sendMessage(message);
}

bool valid(CreatureObject* player, const DecorationState& state) {
	if (!enabled() || !state.token || !player->isOnline() || player->getClient() == nullptr ||
			player->getZone() == nullptr) return false;
	ManagedReference<SceneObject*> parent = player->getParent().get();
	ManagedReference<SceneObject*> root = player->getRootParent();
	if (parent == nullptr || !parent->isCellObject() || root == nullptr ||
			root->getObjectID() != state.buildingID || !root->isBuildingObject()) return false;
	BuildingObject* building = cast<BuildingObject*>(root.get());
	return !building->isGCWBase() && building->isOnAdminList(player);
}

void watch(CreatureObject* player, uint64 token) {
	WeakReference<CreatureObject*> weakPlayer = player;
	Core::getTaskManager()->scheduleTask([weakPlayer, token] {
		ManagedReference<CreatureObject*> player = weakPlayer.get();
		if (player == nullptr) return;
		Locker locker(player);
		auto session = sessionFor(player);
		if (session == nullptr || session->getDecorationState()->token != token) return;
		DecorationMode::validate(player);
		session = sessionFor(player);
		if (session != nullptr && session->getDecorationState()->token == token) watch(player, token);
	}, "DecorationSessionValidation", 1000);
}
}

bool DecorationMode::canOpen(CreatureObject* player, StructureObject* structure) {
	if (!enabled() || player == nullptr || structure == nullptr || !structure->isBuildingObject())
		return false;
	DecorationState state;
	state.token = 1;
	state.buildingID = structure->getObjectID();
	return valid(player, state);
}

void DecorationMode::open(CreatureObject* player, StructureObject* structure) {
	if (!canOpen(player, structure)) return;
	close(player);
	ManagedReference<DecorationSession*> session = new DecorationSession();
	auto state = session->getDecorationState();
	state->buildingID = structure->getObjectID();
	do { state->token = ++nextToken; } while (!state->token);
	player->addActiveSession(SessionFacadeType::DECORATION, session);
	reply(player, *state, 0, OPENED);
	watch(player, state->token);
}

void DecorationMode::close(CreatureObject* player) {
	auto session = sessionFor(player);
	if (session == nullptr) return;
	reply(player, *session->getDecorationState(), 0, EXPIRED);
	player->dropActiveSession(SessionFacadeType::DECORATION);
}

void DecorationMode::validate(SceneObject* object) {
	if (object == nullptr || !object->isPlayerCreature()) return;
	auto player = cast<CreatureObject*>(object);
	auto session = sessionFor(player);
	if (session != nullptr && !valid(player, *session->getDecorationState())) close(player);
}

bool DecorationMode::handle(CreatureObject* player, uint64 targetID, const String& arguments, bool commandAllowed) {
	DecorationWire::Request request;
	if (!DecorationWire::parse(std::string(arguments.toCharArray(), arguments.length()), request)) {
		DecorationState empty;
		empty.token = request.token;
		reply(player, empty, request.id, REJECTED);
		return false;
	}
	auto session = sessionFor(player);
	if (session == nullptr || session->getDecorationState()->token != request.token) {
		DecorationState empty;
		empty.token = request.token;
		reply(player, empty, request.id, REJECTED);
		return false;
	}
	auto state = session->getDecorationState();
	if (!valid(player, *state)) {
		reply(player, *state, request.id, EXPIRED);
		player->dropActiveSession(SessionFacadeType::DECORATION);
		return false;
	}
	if (request.id <= state->lastRequest) {
		reply(player, *state, request.id, STALE);
		return false;
	}
	state->lastRequest = request.id; // Failed edits must not become replayable.
	if (request.operation == "end") {
		reply(player, *state, request.id, ENDED);
		player->dropActiveSession(SessionFacadeType::DECORATION);
		return true;
	}
	if (!commandAllowed || player->isDead() || player->isIncapacitated()) {
		reply(player, *state, request.id, REJECTED);
		return false;
	}
	ManagedReference<SceneObject*> target = player->getZoneServer()->getObject(targetID);
	if (target == nullptr) {
		reply(player, *state, request.id, REJECTED);
		return false;
	}
	Locker targetLocker(target, player);
	// Locker may temporarily release the player lock: recheck the session and authorization.
	if (sessionFor(player) != session || !valid(player, *state)) {
		reply(player, *state, request.id, EXPIRED);
		return false;
	}
	if (state->lastRequest != request.id) {
		reply(player, *state, request.id, STALE);
		return false;
	}
	ManagedReference<SceneObject*> cell = target->getParent().get();
	ManagedReference<SceneObject*> root = target->getRootParent();
	if (!target->isTangibleObject() || target->isCreatureObject() || target->isVendor() ||
			target->isPet() || cell == nullptr || !cell->isCellObject() || root == nullptr ||
			root->getObjectID() != state->buildingID || !root->isBuildingObject() ||
			target->getZone() != player->getZone() ||
			cast<BuildingObject*>(root.get())->containsChildObject(target)) {
		reply(player, *state, request.id, REJECTED);
		return false;
	}
	if (request.operation == "select") {
		reply(player, *state, request.id, SELECTED, target);
		return true;
	}
	if (cell->getObjectID() != request.cell || target->getMovementCounter() != request.revision) {
		reply(player, *state, request.id, STALE, target);
		return false;
	}
	if (request.operation == "rotate" || request.operation == "reset") {
		if (!ConfigManager::instance()->getBool("Core3.StructureManager.EnhancedFurnitureRotate", false)) {
			reply(player, *state, request.id, REJECTED, target);
			return false;
		}
		if (request.operation == "reset") target->setDirection(1, 0, 0, 0);
		else if (request.axis == "yaw") target->rotate(request.degrees);
		else if (request.axis == "pitch") target->rotatePitch(request.degrees);
		else target->rotateRoll(request.degrees);
		target->incrementMovementCounter();
		target->teleport(target->getPositionX(), target->getPositionZ(), target->getPositionY(), cell->getObjectID());
		reply(player, *state, request.id, ROTATED, target);
		return true;
	}
	float x = target->getPositionX() + request.x / 100.f;
	float y = target->getPositionY() + request.z / 100.f;
	float z = target->getPositionZ() + request.y / 100.f;
	Vector3 destination(x, y, z);
	if (!std::isfinite(x) || !std::isfinite(y) || !std::isfinite(z) ||
			!CollisionManager::checkLineOfSightInParentCell(target, destination)) {
		reply(player, *state, request.id, COLLISION, target);
		return false;
	}
	target->incrementMovementCounter();
	target->teleport(x, z, y, cell->getObjectID());
	bool applied = target->getParentID() == request.cell &&
			target->getPositionX() == x && target->getPositionY() == y && target->getPositionZ() == z;
	reply(player, *state, request.id, applied ? MOVED : REJECTED, target);
	return applied;
}
