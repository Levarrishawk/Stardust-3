# Appearance equipment prototype

This experiment is limited to an equipped composite armor chest plate and a
gunman's duster (`object/tangible/wearables/robe/robe_s27.iff`) directly in the
player's inventory. Right-click the duster and select **Equip Appearance** or
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

This is a containment experiment, not a finished independent appearance UI.
The owner's equipment panel may display the duster and hide the actual chest;
the duster may disappear from the visible inventory while appearance is active.
Use Remove Appearance from the duster's radial to restore the real display before
normal inventory/equipment operations. Test restoration before adopting this
approach for ordinary gameplay. Whether this resolves owner rendering remains
unverified.

The selection is deliberately not persistent. It resets when the creature is
loaded from the database or the server restarts; a reconnect to an already loaded
creature may retain it. Removing the chest or moving/removing the duster clears
the selection. Changing the duster's colors requires selecting Equip Appearance
again after removing the appearance, because customization is captured on use.

## Files

- `CreatureObject.idl` and `CreatureObjectImplementation.cpp`: validation, apply,
  clear, inventory removal handling, and owner-only containment messages.
- `WearablesDeltaVector.h`: temporary visual state and equipment serialization.
- `TangibleObjectMenuComponent.cpp`: the two radial actions for this duster.

No Engine3, client assets, database schema, or packet layout changes are required
by this prototype. Client compatibility is unverified: the client may reconcile
the chest's object ID with its original template or containment updates. The
robe may also visually cover other armor even though only the chest entry is
substituted. This experiment does not implement multi-slot cosmetic outfits.

## Debian build and client verification

Regenerate the CreatureObject interfaces through the normal IDL build and do a
clean Core3 rebuild using the existing Debian workflow. Do not manually edit
generated headers. Start the server under GDB.

1. Equip a composite chest and keep the ordinary gunman's duster directly in
   inventory. Record armor protection, condition, encumbrance, and skill modifiers.
2. Select Equip Appearance. Verify the duster and its colors on the wearer and
   a second player's client. Confirm the chest remains equipped and the duster
   remains in inventory with no additional equipment modifiers.
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
6. Move the duster into a bag, trade it, drop it, and destroy it in separate tests.
   Each removal from direct inventory must restore the chest visual. Unequip or
   replace the chest while the appearance is active; the selection must clear.
7. Restart the server and verify normal armor appearance and intact inventory.
   Also test relog, death/cloning, incompatible species, and attempts without the
   composite chest. Invalid selections must not alter actual equipment.

Do not broaden the feature or add persistent selections until the client tests
establish that this rendering method works.
