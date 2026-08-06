#ifndef PLACEPLAYERBOUNTYSUICALLBACK_H_
#define PLACEPLAYERBOUNTYSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/player/sui/inputbox/SuiInputBox.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/transaction/TransactionLog.h"
#include "server/zone/managers/bounty/BountyNotorietyManager.h"
#include "server/zone/managers/mission/MissionManager.h"
#include "server/zone/managers/player/PlayerManager.h"

class PlacePlayerBountySuiCallback : public SuiCallback {
	WeakReference<SceneObject*> terminal;
	uint64 targetID;

	static const int MINIMUMCONTRIBUTION = 1000000;
	static const int MINIMUMNOTORIETY = 1500;

	bool validTerminalInteraction(CreatureObject* player) const {
		ManagedReference<SceneObject*> terminalObject = terminal.get();
		return player != nullptr && terminalObject != nullptr && terminalObject->isMissionTerminal() &&
				player->isInRange(terminalObject, 16);
	}

	void sendAmountInput(CreatureObject* player, const String& targetName, uint64 selectedTargetID) {
		auto ghost = player->getPlayerObject();

		if (ghost == nullptr)
			return;

		ManagedReference<SuiInputBox*> input = new SuiInputBox(player, SuiWindowType::PLACE_PLAYER_BOUNTY_AMOUNT);
		input->setPromptTitle("Place Player Bounty");
		input->setPromptText("Enter the number of credits to place on " + targetName + ". The minimum contribution is 1,000,000 credits.");
		input->setDefaultInput(String::valueOf(MINIMUMCONTRIBUTION));
		input->setMaxInputSize(10);
		input->setCallback(new PlacePlayerBountySuiCallback(server, terminal.get(), selectedTargetID));

		ghost->addSuiBox(input);
		player->sendMessage(input->generateMessage());
	}

public:
	PlacePlayerBountySuiCallback(ZoneServer* serv, SceneObject* missionTerminal, uint64 selectedTargetID = 0) : SuiCallback(serv) {
		terminal = missionTerminal;
		targetID = selectedTargetID;
	}

	void run(CreatureObject* player, SuiBox* sui, uint32 eventIndex, Vector<UnicodeString>* args) {
		if (eventIndex == 1 || args == nullptr || args->size() == 0 || !validTerminalInteraction(player))
			return;

		if (sui->getWindowType() == SuiWindowType::PLACE_PLAYER_BOUNTY_TARGET) {
			String targetName = args->get(0).toString().trim();
			auto playerManager = server->getPlayerManager();

			if (playerManager == nullptr || targetName.isEmpty() || !playerManager->existsName(targetName)) {
				player->sendSystemMessage("No player with that name exists.");
				return;
			}

			uint64 selectedTargetID = playerManager->getObjectID(targetName);

			if (selectedTargetID == 0 || selectedTargetID == player->getObjectID()) {
				player->sendSystemMessage("You cannot place a bounty on yourself.");
				return;
			}

			sendAmountInput(player, playerManager->getPlayerName(selectedTargetID), selectedTargetID);
			return;
		}

		if (sui->getWindowType() != SuiWindowType::PLACE_PLAYER_BOUNTY_AMOUNT || targetID == 0)
			return;

		int contribution = 0;

		try {
			contribution = Integer::valueOf(args->get(0).toString());
		} catch (Exception& e) {
			player->sendSystemMessage("The bounty contribution must be a whole number of credits.");
			return;
		}

		if (contribution < MINIMUMCONTRIBUTION) {
			player->sendSystemMessage("The minimum player bounty contribution is 1,000,000 credits.");
			return;
		}

		if (!player->verifyCredits(contribution)) {
			player->sendSystemMessage("You do not have enough credits for that bounty contribution.");
			return;
		}

		if (!player->checkCooldownRecovery("place_player_bounty")) {
			player->sendSystemMessage("Please wait before placing another player bounty.");
			return;
		}

		auto playerManager = server->getPlayerManager();
		auto missionManager = server->getMissionManager();

		if (playerManager == nullptr || missionManager == nullptr || !playerManager->existsPlayerCreatureOID(targetID)) {
			player->sendSystemMessage("That player no longer exists.");
			return;
		}

		ManagedReference<CreatureObject*> target = server->getObject(targetID).castTo<CreatureObject*>();
		bool targetOnline = target != nullptr && target->getPlayerObject() != nullptr;
		int baseReward = MINIMUMNOTORIETY * 100;

		if (targetOnline) {
			if (target->getPlayerObject()->isPrivileged()) {
				player->sendSystemMessage("You cannot place a bounty on a privileged character.");
				return;
			}

			BountyNotorietyManager::instance()->ensureMinimumNotoriety(target, MINIMUMNOTORIETY);
			baseReward = target->getPlayerObject()->calculateBhReward();
		}

		if (!missionManager->addPlayerBountyContribution(targetID, baseReward, contribution, targetOnline)) {
			player->sendSystemMessage("That contribution would make the bounty reward too large.");
			return;
		}

		player->updateCooldownTimer("place_player_bounty", 5000);

		if (!player->subtractCredits(contribution)) {
			missionManager->removePlayerBountyContribution(targetID, contribution);
			player->sendSystemMessage("The bounty could not be funded because your credit balance changed.");
			return;
		}

		TransactionLog trx(player, TrxCode::BOUNTYSYSTEM, contribution, true);
		player->sendSystemMessage("Your contribution of " + String::valueOf(contribution) + " credits has been added to the bounty on " + playerManager->getPlayerName(targetID) + ".");
	}
};

#endif /* PLACEPLAYERBOUNTYSUICALLBACK_H_ */
