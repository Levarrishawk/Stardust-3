/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef QUESTTASKTIMERMESSAGE_H_
#define QUESTTASKTIMERMESSAGE_H_

#include "ObjectControllerMessage.h"
#include "server/zone/objects/creature/CreatureObject.h"

// ObjController 0x0444 (1092). Header = Core3 ObjectControllerMessage
// (0x80CE5E46 + update type + message id + objectId + int 0). Body matches
// NGECore2 QuestTaskTimerMessage: ASCII questName, int taskId,
// UNICODE stf, int count(seconds).
class QuestTaskTimerMessage : public ObjectControllerMessage {
public:
	QuestTaskTimerMessage(CreatureObject* player, const String& questName, int taskId, const String& stf, int seconds)
			: ObjectControllerMessage(player->getObjectID(), 0x0B, 0x0444) {
		insertAscii(questName.toCharArray());
		insertInt(taskId);
		insertUnicode(UnicodeString(stf));
		insertInt(seconds);
	}
};

#endif /*QUESTTASKTIMERMESSAGE_H_*/
