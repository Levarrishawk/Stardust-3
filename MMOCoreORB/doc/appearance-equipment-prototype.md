# Appearance equipment prototype

The owner-containment revision was reported working on both clients. Appearance
selections now reserve every slot in the loaded arrangement group, separately
from actual equipment. A different appearance item sharing any reserved slot
is rejected with the conflicting slot name; the existing appearance is kept.
Selecting the same item again remains safe. Removing the appearance clears all
its reservations. This prototype still supports only one appearance item and
only the original duster/composite pair; it does not yet support independent
appearance selections in other slots.

This experiment is limited to an equipped composite armor chest plate and a
gunman's duster (`object/tangible/wearables/robe/robe_s27.iff`) in the player's
inventory, any nested container beneath it, or a container nested beneath a
wearable container equipped by the player. Bank and other players' storage are
excluded. Right-click the duster and select **Equip Appearance** or
**Remove Appearance**.

The server substitutes the duster's client template CRC, customization string,
and first arrangement in the chest's existing CREO6 equipment entry. It retains
the chest's object ID and does not transfer either item. The gameplay wearable
vector, armor protection lookup, encumbrance, and skill modifiers are unchanged.
Both initial baselines and subsequent equipment deltas use the substitution.

The first test reached the success message and changed the radial to Remove
Appearance, but neither client displayed the duster. That confirms the server
selection succeeded, without establishing how the clients processed the packet.
The revised experiment sends a remove followed by an add at the same equipment
list index rather than a replace operation, to test whether rebuilding the client
wearable is necessary. These two operations advance the equipment list counter
by two and do not modify the server list or its armor protection map.

The remove/add revision displayed the duster on the observing client but not the
wearer's client. The next revision sends the same equipment delta explicitly to
the owner and broadcasts it to observers with the owner excluded. This removes
dependence on the nearby receiver list for owner delivery, without sending a
duplicate remove/add delta to the owner. The existing multi-message broadcast
handles that exclusion in both packet-buffer configurations. If the owner still
sees armor, owner delivery alone does not resolve the rendering difference.

Explicit owner delivery also left the wearer displaying armor. The next
experiment keeps the working observer equipment updates and sends owner-only
containment links: detach the chest visually and attach the duster to the
creature in arrangement 4. No server parent, slot, or containment type is changed.
Removing the appearance sends each object's actual server containment back to
the owner, including during automatic cleanup. Sending the owner's slotted
objects on reload/travel reapplies the visual links after the real objects arrive.

The latest revision links the chest to the owner's inventory on the client
instead of detaching it to a null parent, so it should remain visible and
accessible. The chest remains equipped on the server. Its client equipment
indicator may therefore differ from its actual server state. This is still a
containment experiment, not a finished independent appearance UI. The owner's
equipment panel displays the duster; the duster may disappear from its original
visible container while appearance is active. Removing appearance restores each
item's actual server parent, including the original nested bag for the duster.
Use Remove Appearance from the duster's radial to restore the real display before
normal inventory/equipment operations. Test restoration before adopting this
approach for ordinary gameplay. Inventory visibility and nested-container
selection in this revision require client testing.

The selection is deliberately not persistent. It resets when the creature is
loaded from the database or the server restarts; a reconnect to an already loaded
creature may retain it. Removing the chest, moving/removing the duster, or moving
any container holding the duster clears the selection, even when moving that
container elsewhere within the player's own storage. Removal notifications are
also forwarded to the owning player indoors when the root parent is a building.
Changing the duster's colors requires selecting Equip Appearance
again after removing the appearance, because customization is captured on use.

## Files

- `CreatureObject.idl` and `CreatureObjectImplementation.cpp`: validation, apply,
  clear, inventory removal handling, and owner-only containment messages.
- `WearablesDeltaVector.h`: temporary visual state and equipment serialization.
- `TangibleObjectMenuComponent.cpp`: the two radial actions for this duster.
- `ContainerComponent.cpp`: appearance cleanup notifications to the owner when
  the root parent is a building or another object above the player.

No Engine3, client assets, database schema, or packet layout changes are required
by this prototype. Client compatibility is unverified: the client may reconcile
the chest's object ID with its original template or containment updates. The
robe may also visually cover other armor even though only the chest entry is
substituted. This experiment does not implement multi-slot cosmetic outfits.

## Debian build and client verification

Regenerate the CreatureObject interfaces through the normal IDL build and do a
clean Core3 rebuild using the existing Debian workflow. Do not manually edit
generated headers. Start the server under GDB.

1. Equip a composite chest and keep the ordinary gunman's duster in inventory.
   Repeat with the duster in a bag, in a bag inside another bag, and inside an
   equipped wearable container. Record armor protection, condition, encumbrance,
   and skill modifiers. Verify the radial is absent for items in bank storage.
2. Select Equip Appearance. Verify the duster and its colors on the wearer and
   a second player's client. Confirm the chest remains equipped and the duster
   remains in inventory with no additional equipment modifiers.
   On the wearer's client, verify the chest remains visible in inventory while
   the duster is displayed on the character. The duster's actual server storage
   remains its original container, even though its client representation is worn.
3. Compare combat protection and armor condition loss before and after applying
   the appearance. The armor must continue supplying protection and taking decay.
4. Select Remove Appearance. The original chest visual must return on both clients.
   Repeat toggling; there must be no duplicate objects or additional modifiers.
   For the containment experiment, also confirm the duster returns to the owner's
   inventory display and the chest returns to the equipment panel. Record whether
   the duster radial remains accessible while visually equipped. Do not use normal
   Equip/Unequip actions as a substitute for Remove Appearance during this test.
5. Test a second observer entering range, zone travel, and equipping another item.
   Check whether the client restores the armor visual from containment updates.
   If toggling has no visible effect, have the observer leave visibility range
   completely and return with the appearance still active. Record whether the
   newly received equipment baseline displays the duster. This distinguishes an
   update problem from a rendering or object identity limitation.
6. Move the duster, trade it, drop it, and destroy it in separate tests. Also move
   a containing bag or an outer bag while appearance is active, indoors and
   outdoors. Each removal must restore the chest visual and release appearance
   slot reservations. Unequip or
   replace the chest while the appearance is active; the selection must clear.
7. Restart the server and verify normal armor appearance and intact inventory.
   Also test relog, death/cloning, incompatible species, and attempts without the
   composite chest. Invalid selections must not alter actual equipment.
8. Keep two ordinary gunman's dusters in inventory. Apply the first, then attempt
   Equip Appearance on the second. It must report an occupied appearance slot
   and preserve the first item's appearance on both clients. Remove the first
   appearance and apply the second; it must succeed. Repeat after automatic
   cleanup by moving the first duster out of inventory. Future multi-item tests
   must include partial overlaps with biceps/bracers and disjoint arrangements.

Do not broaden the feature or add persistent selections until the client tests
establish that this rendering method works.
