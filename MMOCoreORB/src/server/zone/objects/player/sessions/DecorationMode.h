#ifndef DECORATIONMODE_H_
#define DECORATIONMODE_H_
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/structure/StructureObject.h"

namespace DecorationMode {
// Call with the player locked (as in queue commands and terminal menu callbacks).
bool canOpen(CreatureObject* player, StructureObject* structure);
void open(CreatureObject* player, StructureObject* structure);
void close(CreatureObject* player);
void validate(SceneObject* object);
bool handle(CreatureObject* player, uint64 target, const String& arguments, bool commandAllowed);
}
#endif
