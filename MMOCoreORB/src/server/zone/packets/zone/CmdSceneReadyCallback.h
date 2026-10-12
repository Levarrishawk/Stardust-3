/*
 * CmdSceneReadyCallback.h
 *
 *  Created on: Sep 6, 2009
 *      Author: theanswer
 */

#ifndef CMDSCENEREADYCALLBACK_H_
#define CMDSCENEREADYCALLBACK_H_

#include "server/zone/packets/MessageCallback.h"
#include "server/zone/Zone.h"
#include "server/zone/objects/creature/CreatureObject.h"

#include "CmdSceneReady.h"

class CmdSceneReadyCallback : public MessageCallback {
public:
	CmdSceneReadyCallback(ZoneClientSession* client, ZoneProcessServer* server):MessageCallback(client, server) {
	}

	void parse(Message* message) {
	}

	void run() {
		ManagedReference<CreatureObject*> player = client->getPlayer();

		if (player == nullptr) {
			return;
		}

		Locker _locker(player);

		auto zone = player->getZone();
		if (zone != nullptr && zone->getZoneName() == "kashyyyk_main") {
			player->info(true) << "Kashyyyk scene ready -- local=" << player->getPosition().toString()
				<< " world=" << player->getWorldPosition().toString() << " parent=" << player->getParentID();
		}

		auto ghost = player->getPlayerObject();

		if (ghost != nullptr) {
			ghost->notifySceneReady();
		}
	}
};



#endif /* CMDSCENEREADYCALLBACK_H_ */
