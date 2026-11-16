#ifndef GUILDHALLBANNERSUICALLBACK_H_
#define GUILDHALLBANNERSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/tangible/terminal/Terminal.h"
#include "server/zone/objects/structure/StructureObject.h"

class GuildHallBannerSuiCallback : public SuiCallback {
public:
    GuildHallBannerSuiCallback(ZoneServer* serv) : SuiCallback(serv) {}

    static bool supports(StructureObject* structure) {
        if (structure == nullptr || !structure->isBuildingObject()) return false;
        const char* templates[] = {
            "object/building/player/player_guildhall_generic_style_01.iff",
            "object/building/player/player_guildhall_corellia_style_01.iff",
            "object/building/player/player_guildhall_naboo_style_01.iff",
            "object/building/player/player_guildhall_tatooine_style_01.iff"
        };
        for (int i = 0; i < 4; ++i)
            if (structure->getServerObjectCRC() == String(templates[i]).hashCode()) return true;
        return false;
    }

    static bool allowed(CreatureObject* creature, Terminal* terminal, StructureObject* structure) {
        return creature != nullptr && terminal != nullptr && supports(structure) &&
            structure->getZone() != nullptr && creature->getZone() == structure->getZone() &&
            creature->isInRange(terminal, 15.0f) && structure->isOnAdminList(creature);
    }

    static void open(CreatureObject* creature, Terminal* terminal, StructureObject* structure) {
        if (!allowed(creature, terminal, structure)) return;
        ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();
        if (ghost == nullptr) return;
        const char* labels[] = {"Original", "Library", "Association", "Imperial", "Imperial Guard",
            "Force Sensitive", "Rebel", "Tatooine", "Theed", "Nightsister", "Light Jedi", "Dark Jedi",
            "Corellia", "Theed Palace", "Mandalorian"};
        ManagedReference<SuiListBox*> box = new SuiListBox(creature, 0x00);
        box->setUsingObject(terminal);
        box->setPromptTitle("Change Exterior Banners");
        box->setPromptText("Choose the guild hall banner design. Building crafting colors are preserved.");
        box->setCancelButton(true, "@cancel");
        for (int i = 0; i < 15; ++i) box->addMenuItem(labels[i]);
        box->setCallback(new GuildHallBannerSuiCallback(creature->getZoneServer()));
        ghost->addSuiBox(box);
        creature->sendMessage(box->generateMessage());
    }

    void run(CreatureObject* creature, SuiBox* sui, uint32 eventIndex, Vector<UnicodeString>* args) {
        if (creature == nullptr || sui == nullptr || !sui->isListBox() || eventIndex != 0 || args == nullptr || args->size() != 1) return;
        ManagedReference<SceneObject*> object = sui->getUsingObject().get();
        if (object == nullptr || !object->isTerminal()) return;
        Terminal* terminal = cast<Terminal*>(object.get());
        ManagedReference<StructureObject*> structure = cast<StructureObject*>(terminal->getControlledObject());
        if (structure == nullptr) return;
        Locker structureLocker(structure, creature);
        if (!allowed(creature, terminal, structure)) return;
        int selection;
        try { selection = Integer::valueOf(args->get(0).toString()); }
        catch (Exception&) { return; }
        if (selection < 0 || selection >= 15) return;
        // Dedicated texture index; never replace the customization string or paint colors.
        structure->setCustomizationVariable("/private/index_texture_1", selection, true);
        structure->updateToDatabase();
        creature->sendSystemMessage("Exterior banner design updated.");
    }
};
#endif
