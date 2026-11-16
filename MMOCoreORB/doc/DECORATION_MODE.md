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
No cross-cell item transfer, surface snap or undo history is introduced.

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
