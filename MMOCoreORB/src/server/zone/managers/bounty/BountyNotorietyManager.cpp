#include "BountyNotorietyManager.h"

#include "server/zone/managers/bounty/tasks/BountyNotorietyDecayTask.h"
#include "server/zone/managers/mission/MissionManager.h"
#include "server/zone/objects/player/PlayerObject.h"

BountyNotorietyManager::BountyNotorietyManager() : Logger("BountyNotorietyManager") {
	loadConfiguration();

	Reference<Task*> decayTask = new BountyNotorietyDecayTask();
	decayTask->schedule(decayTickRate * 1000);
}

void BountyNotorietyManager::loadConfiguration() {
	Lua* lua = new Lua();

	try {
		lua->init();
		lua->runFile("scripts/managers/bounty/bounty_notoriety_manager.lua");

		maxNotoriety = lua->getGlobalInt("bountyMaxNotoriety");
		terminalThreshold = lua->getGlobalInt("bountyTerminalThreshold");
		totalDecayTimeInDays = lua->getGlobalInt("bountyDecayTimeInDays");
		decayTickRate = lua->getGlobalInt("bountyDecayTickRateInSeconds");
		cityAuthorityAttackAmount = lua->getGlobalInt("bountyCityAuthorityAttackAmount");
		playerDeathBlowAmount = lua->getGlobalInt("bountyPlayerDeathBlowAmount");
		contrabandDetectedAmount = lua->getGlobalInt("bountyContrabandDetectedAmount");
		crackdownEvasionAmount = lua->getGlobalInt("bountyCrackdownEvasionAmount");

		decayPerTick = maxNotoriety / ((totalDecayTimeInDays * (float)(60 * 60 * 24)) / decayTickRate);
	} catch (Exception& e) {
		error(e.getMessage());
	}

	delete lua;
}

int BountyNotorietyManager::getActionAmount(NotorietyAction action) const {
	switch (action) {
	case CITYAUTHORITYATTACK:
		return cityAuthorityAttackAmount;
	case PLAYERDEATHBLOW:
		return playerDeathBlowAmount;
	case CONTRABANDDETECTED:
		return contrabandDetectedAmount;
	case CRACKDOWNEVASION:
		return crackdownEvasionAmount;
	default:
		return 0;
	}
}

void BountyNotorietyManager::decreaseNotoriety(CreatureObject* creature) {
	if (creature == nullptr)
		return;

	auto ghost = creature->getPlayerObject();

	if (ghost == nullptr || ghost->getBountyNotoriety() <= 0)
		return;

	Locker locker(ghost);
	float decrease = ((ghost->getLastBountyNotorietyUpdateTimestamp().miliDifference() / 1000.f) / decayTickRate) * decayPerTick;

	if (ghost->getBountyNotoriety() <= decrease)
		ghost->setBountyNotoriety(0);
	else
		ghost->setBountyNotoriety(ghost->getBountyNotoriety() - decrease);
}

void BountyNotorietyManager::updateBountyStatus(CreatureObject* creature) {
	if (creature == nullptr || creature->getZoneServer() == nullptr)
		return;

	auto ghost = creature->getPlayerObject();
	auto missionManager = creature->getZoneServer()->getMissionManager();

	if (ghost == nullptr || missionManager == nullptr)
		return;

	uint64 playerID = creature->getObjectID();

	int playerContribution = missionManager->getPlayerBountyContribution(playerID);

	if (ghost->getBountyNotoriety() >= terminalThreshold || playerContribution > 0) {
		if (!missionManager->hasPlayerBountyTargetInList(playerID))
			missionManager->addPlayerToBountyList(playerID, ghost->calculateBhReward());
		else {
			missionManager->updatePlayerBountyReward(playerID, ghost->calculateBhReward());
			missionManager->updatePlayerBountyOnlineStatus(playerID, true);
		}
	} else if (missionManager->hasPlayerBountyTargetInList(playerID)) {
		missionManager->removePlayerFromBountyList(playerID);
	}
}

void BountyNotorietyManager::ensureMinimumNotoriety(CreatureObject* creature, float minimum) {
	if (creature == nullptr || !creature->isPlayerCreature())
		return;

	auto ghost = creature->getPlayerObject();

	if (ghost == nullptr || ghost->hasGodMode() || ghost->getBountyNotoriety() >= minimum)
		return;

	{
		Locker locker(ghost);
		ghost->setBountyNotoriety(Math::min(maxNotoriety, minimum));
	}

	addToNotorietyList(creature);
}

void BountyNotorietyManager::clearNotoriety(CreatureObject* creature) {
	if (creature == nullptr || !creature->isPlayerCreature())
		return;

	auto ghost = creature->getPlayerObject();

	if (ghost == nullptr)
		return;

	{
		Locker locker(ghost);
		ghost->setBountyNotoriety(0);
	}

	updateBountyStatus(creature);

	Locker locker(&notorietyListLock);

	if (notorietyList.contains(creature->getObjectID()))
		notorietyList.drop(creature->getObjectID());
}

void BountyNotorietyManager::increaseNotoriety(CreatureObject* creature, NotorietyAction action) {
	if (creature == nullptr || !creature->isPlayerCreature())
		return;

	auto ghost = creature->getPlayerObject();
	int amount = getActionAmount(action);

	if (ghost == nullptr || ghost->hasGodMode() || amount <= 0)
		return;

	decreaseNotoriety(creature);

	{
		Locker locker(ghost);
		ghost->setBountyNotoriety(Math::min(maxNotoriety, ghost->getBountyNotoriety() + amount));
	}

	addToNotorietyList(creature);
	updateBountyStatus(creature);
}

void BountyNotorietyManager::addToNotorietyList(CreatureObject* creature) {
	if (creature == nullptr)
		return;

	auto missionManager = creature->getZoneServer() != nullptr ? creature->getZoneServer()->getMissionManager() : nullptr;
	auto ghost = creature->getPlayerObject();

	if (missionManager != nullptr && ghost != nullptr &&
			missionManager->getPlayerBountyContribution(creature->getObjectID()) > 0 &&
			ghost->getBountyNotoriety() < terminalThreshold) {
		Locker ghostLocker(ghost);
		ghost->setBountyNotoriety(terminalThreshold);
	}

	decreaseNotoriety(creature);
	updateBountyStatus(creature);

	ghost = creature->getPlayerObject();

	if (ghost == nullptr || ghost->getBountyNotoriety() <= 0)
		return;

	Locker locker(&notorietyListLock);

	if (!notorietyList.contains(creature->getObjectID()))
		notorietyList.put(creature->getObjectID(), creature);
}

void BountyNotorietyManager::removeFromNotorietyList(CreatureObject* creature) {
	if (creature == nullptr)
		return;

	if (creature->getZoneServer() != nullptr) {
		auto missionManager = creature->getZoneServer()->getMissionManager();

		if (missionManager != nullptr && missionManager->hasPlayerBountyTargetInList(creature->getObjectID()))
			missionManager->updatePlayerBountyOnlineStatus(creature->getObjectID(), false);
	}

	Locker locker(&notorietyListLock);

	if (notorietyList.contains(creature->getObjectID()))
		notorietyList.drop(creature->getObjectID());
}

void BountyNotorietyManager::performNotorietyDecay() {
	Locker locker(&notorietyListLock);

	for (int i = notorietyList.size() - 1; i >= 0; --i) {
		auto creature = notorietyList.get(i);

		decreaseNotoriety(creature);
		updateBountyStatus(creature);

		if (creature == nullptr) {
			notorietyList.remove(i);
			continue;
		}

		auto ghost = creature->getPlayerObject();

		if (ghost == nullptr || ghost->getBountyNotoriety() <= 0)
			notorietyList.remove(i);
	}
}
