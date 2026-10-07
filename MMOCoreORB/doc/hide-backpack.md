# Hide Backpack test candidate

## Hide Headwear extension

Equipped items in the existing `hat` slot now offer Hide Headwear (224) and Show
Headwear (225), including armor helmets. They reuse the installed version-11
client protocol and mesh hook. No further DLL installation is required.
Armor protection, stats, real containment and standard highlighting are kept.
Headwear and backpacks can be hidden and shown independently. Unequipping clears
that item's hidden choice; zoning, login and server restart restore valid choices.

The persisted hiddenWearableContainerObjectIDs field retains its original name
for saved-character compatibility and now includes equipped head-item IDs. Its
runtime validation accepts owned wearable containers or the actual equipped `hat`
item. No filename or armor category is used to identify headwear. When the head
item has an appearance replacement, owner mesh markers select that replacement's
source ID, while observer projection omits the hidden equipment's entry.

Rebuild the changed CreatureObject.idl and C++ through the normal Debian generated
interface build. Test a helmet and a non-armor hat, concurrent hidden backpack,
head-slot appearance equip/remove, independent show/hide, unequip/re-equip,
standard highlighting, observer views, zoning, relog and restart. A multi-slot
appearance covering the head is hidden as a whole model; individual parts of one
wearable model cannot be hidden independently by this hook.

The radial on an equipped wearable container switches between Hide Backpack and
Show Backpack. The server keeps the bag equipped and its contents accessible.
The wearer client filters its worn mesh only; observers use the existing
appearance projection. A saved list of hidden equipped containers on the player
survives zoning, relog and server restart. Unequipping a bag clears its choice.

Changed server files: CreatureObject.idl, CreatureObjectImplementation.cpp,
WearablesDeltaVector.h and TangibleObjectMenuComponent.cpp. The new IDL field
defaults empty for existing characters. Runtime hidden IDs are reconstructed
from validated equipped, owned wearable containers, never serialized into the
wearables vector. No Engine3 or database schema changes.

Client source and deployment instructions are in
MMOCoreORB/client-extensions/appearance/APPEARANCE.md. Version 11 retains the
inventory capacity correction and original post-processing chain. Only
C:/Stardust-DEV is an authorized local deployment target.

Build on Debian with the normal generated-interface refresh and make, restart,
then verify on both PCs:

1. Hide/show an equipped bag repeatedly; standard equipped highlight remains.
2. Open a hidden bag and move items in/out. Inventory and bag capacity match the
   visible state, including nearly/full inventory.
3. Equip/remove clothing appearances from inside the hidden bag.
4. Check a nearby observer and one who approaches after hiding; zone both players.
5. Relog fully and restart the server with the bag hidden.
6. Unequip and re-equip: the bag becomes visible. Other players' and unequipped
   containers must not offer the option.

## Appearance selections when unequipping the bag

ContainerComponent.cpp now preserves descendant appearance selections when a
wearable container moves into its owner's inventory or an inventory descendant.
Previously, its removal callback treated that transfer as loss of every selected
appearance inside the bag. Individual source-item removals, dropping the bag,
and transfers outside that player's inventory retain the existing cleanup.
Non-player root notifications (including buildings) are unchanged.

An extracted actual removal-callback block passed a local C++ regression harness
with stand-in engine objects: owned and foreign destinations, nested inventory,
individual items, null destination, outdoor player roots and indoor building
roots. This is a server C++ fix; no further DLL or IDL update is needed. Rebuild
on Debian and verify unequipping a backpack containing several active appearance
sources from both clients, then re-equip it and remove each appearance separately.

Local native adapter/state, graphics forwarding, volume and wearable projection
checks pass. Full Debian build and in-game verification remain outstanding.
