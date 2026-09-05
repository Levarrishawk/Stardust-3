/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef QUESTTASKCOUNTERMESSAGE_H_
#define QUESTTASKCOUNTERMESSAGE_H_

#include "ObjectControllerMessage.h"
#include "server/zone/objects/creature/CreatureObject.h"

// ObjController 0x0441 (1089). Header = Core3 ObjectControllerMessage
// (0x80CE5E46 + update type + message id + objectId + int 0). Body matches
// NGECore2 QuestTaskCounterMessage: ASCII questName, int counterMax,
// UNICODE stf, int 0, int counterCurrent.
class QuestTaskCounterMessage : public ObjectControllerMessage {
public:
	QuestTaskCounterMessage(CreatureObject* player, const String& questName, int taskId, const String& stf, int current, int max)
			: ObjectControllerMessage(player->getObjectID(), 0x0B, 0x0441) {
		insertAscii(questName.toCharArray());
		insertInt(max);
		insertUnicode(UnicodeString(stf));
		insertInt(0); // layout: int 0 (taskId is constructor-only; not on the wire)
		insertInt(current);

		(void)taskId;
	}
};

#endif /*QUESTTASKCOUNTERMESSAGE_H_*/
