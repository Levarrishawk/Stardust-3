# Structure-terminal Decoration Mode — server contract

Implemented in source on November 16, 2026. Not deployed or live-qualified.
The matching client receiver, terminal radial mapping and visual gizmos are
still required. The existing button-only client is not a compatible test client.

## Activation and lifetime

`Core3.StructureManager.EnableDecorationMode` defaults to false. Keep it false
until a matching client build is ready. Existing furniture commands retain their
syntax and permissions. Rotation/reset in the new protocol also require the
existing `Core3.StructureManager.EnhancedFurnitureRotate` setting.

The structure terminal adds **Decoration Mode** beneath **Structure Management**,
server radial ID 204, for an online administrator inside the controlled building.
Civic buildings use the same entry. GCW bases and ships are excluded.

Selecting that entry creates a fresh server token and returns OPENED. It is the
only session creation path; furniture commands cannot start a session.
The player session stores the building ID, token and last accepted request ID.
It does not store a room ID. Moving between cells of that building preserves the
session. Each request supplies its own selected target, so item selection may
change throughout the building.

Normal movement and zone-switch completion validate the session. Disconnect and
unload close it. A weak-reference, token-checked one-second task covers permission
loss and other transfer paths; every command independently rechecks eligibility.
Leaving the building or losing administrator permission invalidates the session.
Reopening replaces the old token. State is transient; reconnect requires reopening.

## Request format

Use the existing moveFurniture queue command and its explicit target-ID field.
Arguments are ASCII, case-sensitive, at most 256 bytes:

```text
decor1 TOKEN REQUEST select
decor1 TOKEN REQUEST move CELL REVISION DX DY DZ
decor1 TOKEN REQUEST rotate CELL REVISION AXIS DEGREES
decor1 TOKEN REQUEST reset CELL REVISION
decor1 TOKEN REQUEST end
```

- TOKEN: nonzero uint64 returned by OPENED.
- REQUEST: strictly increasing, nonzero uint32 per token. Reopen before exhaustion.
  Failed well-formed requests also consume their ID; never retry with the same ID.
- CELL: target's current parent cell ID, not the player's cell.
- REVISION: target movement counter from SELECTED or the latest result. Do not
  predict the next value: existing replication may increment it more than once.
- DX/DY/DZ: signed integer centimetres in the target cell's client coordinate
  basis. X maps to server position X; Y (up) to server Z; Z to server Y.
  Nonzero vector length must be at most 500 cm, including diagonals.
- AXIS: yaw, pitch or roll. Signed whole degrees, -180 through 180 excluding 0.
  Uses the existing Core3 rotation methods and quaternion multiplication order.
- Reset uses the existing identity rotation. End does not require a target.

Select returns an authoritative transform without moving the object. A move,
rotation or reset requires matching target cell and revision. Target must be a
directly cell-contained tangible item in the session building, in the player's
zone. Creatures, pets, vendors, nested inventory contents and fixed building
children are rejected. The player and target need not occupy the same cell.

Requests lock the target and recheck session, permission and ordering after lock
acquisition. Legacy move/rotate commands now acquire the same target lock.
Movement reuses Core3's parent-cell collision check and teleport/replication path.
This is a ray/containment check, not full furniture-volume overlap detection.
No cross-cell item transfer or surface snap is introduced. Undo/Redo is documented below.

## Result packet

New GameNetworkMessage name: `StardustDecorationResult`. CRC is computed using
the existing String::hashCode convention. Operand count is 16 (name plus 15 fields).
Fields use existing BaseMessage integer/float encoding in this order:

| Field | Type |
|---|---|
| version (1), result | uint32 each |
| token | uint64 |
| request ID | uint32 |
| building, target, target cell | uint64 each |
| target movement revision | uint32 |
| position X, Y-up, Z | float32 each, metres |
| quaternion X, Y, Z, W | float32 each, unchanged replication convention |

Results: 0 OPENED, 1 SELECTED, 2 MOVED, 3 ENDED, 4 REJECTED, 5 STALE,
6 COLLISION, 7 EXPIRED, 8 ROTATED (including reset).

Unsolicited OPENED/EXPIRED use request 0. A rejected request without an eligible
target has target/cell/revision zero, position zero and identity quaternion.
Malformed arguments may lack a recoverable token/request. Never reconcile an
unmatched result into the selected item. STALE for an eligible target includes
its current authoritative snapshot. Generic queue removal is not an edit ACK.

Client must register the result message before the feature is enabled; preserve
the explicit queue target; map terminal server radial 204 appropriately through
the Pre-CU adapter; open the UI only after OPENED; keep one edit in flight;
retarget via select; discard obsolete token/request results; and reconcile
accepted edits with replicated transforms. Do not send drag updates every frame.
Command spam throttling can discard requests before this handler, so a timeout
must abandon the pending edit and obtain a fresh snapshot, never replay it.

## Verification and rollout still required

Native production-parser fixture passed **18,895 checks**: integer overflow,
malformed/extra fields, all signed axes, diagonal bounds and rotation bounds.
The production IDL compiler generated the new session successfully in isolation.
Generated files and test executables live only in:
`C:\SWG-DEV\SRC-Client-Dev\diagnostics\decoration-server-20261116`.

Reproduce parser tests on Debian:
```sh
c++ -std=c++11 -Wall -Wextra -pedantic MMOCoreORB/tests/DecorationRequestTest.cpp -o /tmp/decoration-tests
/tmp/decoration-tests
```

Windows checks are not a full server build. Reconfigure the normal Debian CMake
build with IDL generation enabled (new source/IDL files are globbed at configure
time), then perform a clean build and run under GDB. Engine3 is unchanged.
No configuration, runtime installation, commit or push was performed.

With a matching client, qualify:
1. Disabled gate, non-admin, outside-building and GCW terminal rejection.
2. Terminal entry opens once; reopening changes token and invalidates old requests.
3. Walk through multiple rooms/floors, select different items and transform them
   without restarting the mode. Select an item in a different cell in the same
   building; confirm target-cell coordinates and unchanged parent cell.
4. X/Y/Z and plane drags, reverse movement, signed yaw/pitch/roll and reset.
5. Duplicate/out-of-order requests, stale revisions after another administrator
   edits the same item, wrong cell, picked-up/destroyed target and nested items.
6. Collision rejection, exit building, teleport, permission loss, disconnect,
   reconnect, explicit End and rapid close/reopen while validation tasks run.
7. Persisted transforms after relog/restart; unchanged legacy move/rotate behavior.

Visual tools, client packet round-trip, full Debian compilation, concurrent
administrator behavior and in-game multi-cell continuity remain unverified.


## Undo/Redo extension — November 16, 2026

The server now owns per-selected-item history within the existing building
session: up to 32 edits for each of 16 recently used items. Selection and room
changes retain histories; closing/reopening the mode, leaving the building or
disconnecting clears them. The least recently used item's history is evicted
at the item limit.

Accepted movement, rotation and reset store before/after transforms. Undo/Redo
restore those stored transforms; clients cannot submit arbitrary replacement
positions or quaternions. Restores reuse the same target lock, session/admin,
cell, revision and collision checks. The history's last known revision and
transform must also match, so obtaining a fresh select snapshot cannot authorize
undoing another editor's newer change. A mismatch discards only that item's
history. Revisions are updated after each undo/redo so consecutive reversals
remain valid. A new accepted edit after undo drops that item's redo branch.
Rejected/colliding edits preserve the cursor. No-op edits do not add entries.

Additional request forms, using the existing explicit target-ID field:
```text
decor1 TOKEN REQUEST undo CELL REVISION
decor1 TOKEN REQUEST redo CELL REVISION
```

Successful restores use the original MOVED/ROTATED result codes and snapshots.
A separate message follows results, leaving StardustDecorationResult unchanged
for older clients:

**StardustDecorationHistory**, operand count 9, 44 payload bytes (50 total):
version uint32 (1), token uint64, request uint32, target uint64, cell uint64,
revision uint32, undoCount uint32, redoCount uint32. Counts are 0..32 and their
sum is at most 32. Non-target responses contain zero target/cell/counts.

The matching client enables Undo/Redo only for matching
token/request/target/cell/revision metadata and a synchronized target transform.
Old servers send no history metadata, leaving the new buttons disabled.
A lost reply is resolved by selecting again, never by repeating the undo request.
Counts reflect the server's actual history even when an earlier edit reply was lost.

No new configuration is required. Rebuild the server after syncing these source
changes; history is transient and makes no database/schema change. The existing
Engine3 source and generated source tree are untouched. Session IDL generation
passed in an isolated development directory with the new state header.

Native parser/history fixture: **18,951 checks passed**. Tests include multiple
undos/redos, per-item/cell isolation, stale revisions and transforms, reset
restoration, redo branching, no-op edits, rejected-operation cursor preservation
and both storage limits. Diagnostics:
`C:\SWG-DEV\SRC-Client-Dev\diagnostics\decoration-undo-20261116`.

Full Debian compilation and live operation remain unverified. Qualify movement,
signed rotation and reset followed by repeated undo/redo; switch items/rooms;
test another admin's intervening edit, a blocked restore, reconnect, history
limits and new edits after undo. Existing clients can continue ordinary edits
against the updated server; only the matching client exposes history controls.


## Snap to Floor (November 16)

`decor1 TOKEN REQUEST floor CELL REVISION` uses the selected item's cell floor
mesh through `CollisionManager::getCellFloorCollision`. The server selects the
highest finite floor at or below the item's origin (2 cm tolerance for mesh
rounding), preserves horizontal position and quaternion, and uses the existing
movement collision check before applying the change. Missing floors or blocked
paths reject the operation without consuming history. No floor height or pose
is accepted from the client. Session, building, target permission, cell and
revision validation are the same as other edits.

An accepted snap is one per-item Undo/Redo entry. Already on the floor is a
successful no-op that preserves redo. This is origin-to-building-floor placement:
it does not align a tilted object's bounding geometry, snap to furniture, search
adjacent cells, or lift a buried origin onto a floor above it beyond the tolerance.
Unlike a manual drag's 5 m limit, floor snap reaches the nearest floor beneath
the origin, subject to the existing collision test. No Engine3 or IDL changes.

The matching client adds Snap to Floor beside Reset rotation. Rebuild both
server and client; no additional configuration. The parser/floor/history native
fixture passes 18,966 checks. Full Debian compilation and live acceptance remain
operator checks: raised chair snap/undo/redo, repeated no-op, upper and lower
rooms, stacked floors, tilted item retaining orientation, missing floor/blocked
path, and stale selection after another editor's change.


## Snap to Nearest Wall (November 16)

`decor1 TOKEN REQUEST wall CELL REVISION` preserves height and quaternion.
The current cell's appearance meshes are exported with an identity transform;
the navigation export's Z reflection is reversed to restore client cell space.
The search slices near-vertical triangles at the rotated item bounding-box
centre height (at least 10 cm above its origin), finds perpendicular wall
projections within 32 m, and chooses the smallest nonnegative translation.
The item's rotated appearance bounding box supplies clearance along the wall
normal, plus a 2 cm gap. Wall triangles more than roughly 8.6 degrees from
vertical, missing/invalid bounds, other cells, and floor/ceiling faces are excluded.
The item is not rotated or raised. This can select built-in pillars or other
vertical room geometry; it does not search other furniture or align orientation.
A nearest candidate blocked by the existing movement collision test is rejected.
Existing building authorization, cell/revision checks and per-item Undo/Redo apply.
Already touching at the tolerance is a successful no-op that preserves redo.
No new configuration, packet layout, persistence, IDL, or Engine3 changes.

The pure production wall-search/parser/history fixture passes 18,988 checks,
including straight/angled walls, rotated clearance, floor exclusion, height/range
limits, invalid bounds and reversible placement. This does not compile the full
server integration. The Debian build and live checks remain required: chair in
each direction, non-square/rotated furniture, angled walls, upper floors, corners,
door openings, blocked paths, repeated snap, and Undo/Redo. Appearance bounds are
conservative and may leave a visible gap around irregular furniture. Centre-height
wall detection and origin-path collision are not a full swept-volume collision test.


## Snap to Ceiling (November 16)

`decor1 TOKEN REQUEST ceiling CELL REVISION` moves only vertically, preserving
horizontal position and quaternion. It shares the wall-snap room mesh traversal
and validated rotated appearance bounds. The vertical projection of the item
origin must hit a ceiling triangle in its own cell, within 32 m above the origin.
Surfaces up to 45 degrees from horizontal are supported; wall faces are ignored.
The rotated bounding box is kept below the triangle's plane with a 2 cm vertical
gap. The shortest upward translation wins. An overlapping lower ceiling rejects
the operation instead of allowing a jump to a higher surface. Missing geometry,
invalid bounds and blocked movement reject without consuming history. Repeated
snaps within tolerance are no-ops. Existing authorization, revision checks,
collision checks and per-item Undo/Redo apply. No config/IDL/packet layout changes.

This is a point-projection ceiling query with conservative plane clearance, not
a full bounding-volume sweep or support test across an entire ceiling footprint.
Beams and other overhead room geometry can be selected. Irregular items may have
a visible gap due to appearance bounds. Full Debian build and live checks remain
required, especially top-origin hanging items, angled ceilings and openings.
The pure production parser/geometry/history fixture passed 19,012 checks. Test
chair snap/undo/redo, tilted furniture with unchanged rotation, repeated snap,
other rooms and upper storeys, missing/blocked ceilings and overlapping bounds.
