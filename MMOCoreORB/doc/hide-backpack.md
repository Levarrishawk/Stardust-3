# Hide Backpack test candidate

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

Local native adapter/state, graphics forwarding, volume and wearable projection
checks pass. Full Debian build and in-game verification remain outstanding.
