# Appearance equipment: multiple selections

Wearable objects can supply cosmetic appearances over real equipped wearables.
Several appearances can coexist when their arrangement-0 slots do not overlap.
The gunman's duster reserves all its slots, including chest, biceps and bracers;
another appearance claiming any of those slots is rejected. Wearable containers
are excluded as cosmetic sources, but sources inside a carried backpack or any
nested inventory container remain supported.

At least one real equipped wearable must share a source slot. The source stays
in its original server container. The real equipment retains its armor protection,
encumbrance and modifiers. This increment does not add appearances in entirely
empty equipment slots or a separate inventory tab.

## Rendering and removal

CreatureObject retains a collection of source IDs. WearablesDeltaVector builds
an ephemeral selection for each source with all covered real wearable IDs. The
first covered real item supplies the cosmetic's wire object ID; subsequent
covered items are omitted from the visible list. Uncovered wearables serialize
normally. The gameplay vector and protection map are never projected or filtered.

Changing an appearance sends a CREO6 wearable-list clear followed by adds using
projected indices and counts. Normal equipment changes rebuild this projection
when appearances are active. Owner delivery is explicit, with observers receiving
the same delta once. Observer slotted-object creation skips every covered target
so real item templates do not overwrite cosmetic baseline entries after zoning.

Owner-only visual containment links place covered real items in the inventory
and attach cosmetic sources to the creature. The updated DEV client classifies
all covered real items as equipped at the inventory color decision, and gives
all explicit cosmetic sources the accepted yellow highlight. Actual containment
is restored before removal or equipment changes, then remaining appearances are
reapplied. Removing one cosmetic removes only that selection. Removing real gear
reanchors its cosmetic to any remaining covered item; removing its last covered
item clears that selection. Moving a source or its containing bag clears affected
selections while retaining unrelated ones.

## Persistence and compatibility

`appearanceSourceObjectIDs` is a serialized CreatureObject vector. Old characters
start with an empty vector. The previous single source/target fields remain for
migration: the saved source is validated and moved to the new collection on load,
then the legacy fields are zeroed. Targets and slot reservations are reconstructed
from current equipment before the first baseline, rather than persisted separately.
Invalid, duplicate or conflicting saved selections are removed and marked dirty.
No SQL schema change is needed. Customization is captured on selection or restore;
remove/reapply an appearance after changing its colors.

The existing `Core3.AppearanceEquipment.ClientStateMarkers` option still defaults
to false. Keep it enabled only on the isolated test server with both clients
updated to version 8. Version 6/7 marker caches understand only one selection;
unpatched clients do not understand the reserved containment arrangements.
This remains a DEV prototype without client capability negotiation.

Version 8 consumes a reset marker, then each source marker followed by all its
target markers. Caches contain IDs only, with bounds of 64 sources and 256 targets;
the server rejects selections exceeding those bounds before applying them.

## Files and validation

- CreatureObject.idl / CreatureObjectImplementation.cpp: persistent collection,
  legacy migration, validation, lifecycle rebuilding, containment and delivery.
- WearablesDeltaVector.h: projected baseline/delta serialization and slot checks.
- TangibleObjectMenuComponent.cpp: independent Equip/Remove Appearance actions.
- ../client-extensions/appearance/: tracked native source, installer and tests.

Native ABI/marker tests and four-export Direct3D forwarding smoke tests passed.
The actual WearablesDeltaVector header also passes an isolated projection test
with engine stand-ins: baseline counts, target suppression, slot conflicts,
list reset/add counters, selective removal and preserved armor protection.
These checks do not replace a Debian server build or gameplay testing.

Regenerate IDL interfaces through the normal Debian build and perform a clean
Core3 rebuild. Do not hand-edit generated headers or Engine3. The client update
is installed only in C:/Stardust-DEV. Original post-processing DLL/configuration
were verified unchanged; C:/Stardust remains protected.

## Gameplay verification

1. Keep the established duster/composite case working, including both highlights.
2. Equip composite chest, biceps and bracers, then the duster appearance. Observe
   from both clients: one duster, all covered armor hidden, all real armor still
   equipped and highlighted normally. Confirm protection/encumbrance stay intact.
3. Add a disjoint cosmetic, such as shoes over equipped boots. Both appearances
   should display and receive the alternate highlight.
4. Reject a second chest/arm appearance without changing either active selection.
5. Remove either appearance independently, in both orders, restoring only its gear.
6. Unequip/re-equip covered real armor, including the anchor item; verify remaining
   coverage and unrelated appearances. Removing the last covered wearable should
   clear only its cosmetic. Also change unrelated equipped gear.
7. Repeat nested-bag, bag-transfer cleanup, zoning/observer, relog and server-restart
   tests with multiple selections. Load the previously saved single duster selection
   to verify migration, then restart again with multiple selections saved.
