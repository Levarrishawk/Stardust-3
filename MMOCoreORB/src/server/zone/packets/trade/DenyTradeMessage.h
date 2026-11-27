/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef DENYTRADEMESSAGE_H_
#define DENYTRADEMESSAGE_H_
#include "server/zone/packets/MessageCallback.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/managers/player/PlayerManager.h"

class DenyTradeMessage : public BaseMessage {
public:
	DenyTradeMessage() : BaseMessage(6) {
		insertShort(1);
		insertInt(0x6EC28670);
	}
};

class DenyTradeMessageCallback : public MessageCallback {
public:
	DenyTradeMessageCallback(ZoneClientSession* session, ZoneProcessServer* server) : MessageCallback(session, server) {
	}

	void parse(Message *message) {
	}

	void run() {
		ManagedReference<CreatureObject*> player = client->getPlayer();

		if (player == nullptr)
			return;

		auto* zone = server->getZoneServer();
		if (zone != nullptr && zone->getPlayerManager() != nullptr)
			zone->getPlayerManager()->handleUnAcceptTransactionMessage(player);
	}
};

#endif /*DENYTRADEMESSAGE_H_*/
