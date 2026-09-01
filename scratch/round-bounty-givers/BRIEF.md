# Round: wire the seven Mustafar bounty-hunt givers

## What this closes

`screenplays/mustafar/quest/bounty_hunts.lua` has a header section titled
**"NO GIVER -- open question, deliberately not filled"**. It says nothing in the
seven `.qst` files names a giver, so `grantHunt` is never called and the whole
arc is unreachable in game.

`screenplays/mustafar/mensix/mensix_mining_facility_main.lua:155-161` says the
same thing from the other side: it places the props, then states
*"Placing them does NOT wire them to it... the table's `script` column is EMPTY
on all five rows, so nothing in the shipped data says a click does anything."*

**Both notes were right about the data they had, and both are now superseded.**
The `script` column is empty because on live the script is attached at the
TEMPLATE level, not the spawn-table level. The live server source has since been
read directly. Every giver, every string and every branch below is transcribed
from it. Nothing here is invented and nothing here is a design choice.

## Source of record

Live SWG server source, `github.com/SWG-Source/dsrc`, under
`sku.0/sys.server/compiled/game/`. Each template's `.tpf` names its script:

```
object/tangible/item/som/lava_flea_bounty.tpf        scripts = +["quest.som.lava_flea_bounty"]
object/tangible/item/som/lava_lizard_food.tpf        scripts = +["quest.som.lava_lizard_food"]
object/tangible/item/som/lava_beetle_beads.tpf       scripts = +["quest.som.lava_beetle_beads"]
object/tangible/item/som/jundak_hunter_hologram.tpf  scripts = +["quest.som.jundak_hunter_hologram"]
object/tangible/item/som/blistmok_heart.tpf          scripts = +["quest.som.blistmok_heart"]
object/tangible/item/som/tulrus_parts.tpf            scripts = +["quest.som.tulrus_mandible"]
object/tangible/item/som/xandank_jaw.tpf             scripts = +["quest.som.xandank_jaw"]
```

Note the tulrus line. The script is `tulrus_mandible`, the template is
`tulrus_parts`, and its strings are keyed `tulrus_horn_*`. Three different names
for one object. There is no `tulrus_mandible.tpf` -- fetching it returns 404.

All radial and message strings verified in `C:\swg-extract\_STF_EN_ALL.tsv`,
`string/en/som/som_quest.stf`, mtg_patch_019.tre, lines 184071-184160.

## The two shapes

**Shape A -- the four static world props.** Script body is identical in all four:

```java
OnObjectMenuRequest:  mi.addRootMenu(ITEM_USE, EXAMINE); mid.setServerNotify(true);
OnObjectMenuSelect:   if (!groundquests.isQuestActive(player, QUEST))
                          groundquests.grantQuest(player, QUEST);
                      else sendSystemMessage(player, ALREADY);
```

No containment check, no SUI, no destroy. They are furniture you click.

**Shape B -- the three loot items.** Adds three things:

```java
OnObjectMenuRequest:  only add the radial if utils.getContainingPlayer(self) != null
OnObjectMenuSelect:   if getContainingPlayer(self) == null -> UNABLE
                      else if !isQuestActive -> mustafar.activateQuestAcceptSUI(player, self)
                      else -> ALREADY
handleQuestOfferResponse:
                      BP_OK     -> grantQuest; sendSystemMessage(DESTROY); destroyObject(self)
                      BP_CANCEL -> sendSystemMessage(DECLINE)
```

`activateQuestAcceptSUI` is `script/library/mustafar.java:307-316` and is exactly
a message box:

```java
sui.createSUIPage(sui.SUI_MSGBOX, self, player, "handleQuestOfferResponse");
MSGBOX_TITLE  = "@som/som_quest:begin_quest_title"
MSGBOX_PROMPT = "@som/som_quest:begin_quest_prompt"
sui.msgboxButtonSetup(pid, sui.YES_NO);
MSGBOX_BTN_OK     = "@som/som_quest:quest_accept_ok"
MSGBOX_BTN_CANCEL = "@som/som_quest:quest_accept_cancel"
```

## The seven, complete

| template `.iff` | shape | hunt key | live quest | examine | already | destroy |
| --- | --- | --- | --- | --- | --- | --- |
| `lava_flea_bounty` | A | `lava_flea` | `som_lava_flea_hunt` | `lava_flea_bounty_examine` | `lava_flea_bounty_already` | - |
| `lava_lizard_food` | A | `tanray` | `som_tanray_hunt_20` | `lava_lizard_food_examine` | `lava_lizard_food_already` | - |
| `lava_beetle_beads` | A | `lava_beetle` | `som_lava_beetle_hunt_15` | `lava_beetle_beads_examine` | `lava_beetle_beads_already` | - |
| `jundak_hunter_hologram` | A | `jundak` | `som_jundak_hunt_15` | `jundak_hunter_hologram_examine` | `jundak_hunter_hologram_already` | - |
| `blistmok_heart` | B | `blistmok` | `som_blistmok_hunt_25` | `blistmok_heart_examine` | `blistmok_heart_already` | `blistmok_heart_destroy` |
| `tulrus_parts` | B | `tulrus` | `som_tulrus_hunt_20` | `tulrus_horn_examine` | `tulrus_horn_already` | `tulrus_horn_destroy` |
| `xandank_jaw` | B | `xandank` | `som_xandank_hunt_25` | `xandank_jaw_examine` | `xandank_jaw_already` | `xandank_jaw_destroy` |

Hunt keys are `bounty_hunts.lua:150,169,188,208,227,244,261`. Do not use the
live quest name as the key -- this tree keys by the short name.

Shared strings, shape B only:
`unable_to_examine`, `quest_decline`, `begin_quest_title`, `begin_quest_prompt`,
`quest_accept_ok`, `quest_accept_cancel`. All in `@som/som_quest:`.

## The four static props are ALREADY PLACED -- do not place anything

`mensix_mining_facility_main.lua:169,175,178,183` already spawns
`lava_beetle_beads`, `jundak_hunter_hologram`, `lava_flea_bounty` and
`lava_lizard_food` at the exact live coordinates from
`datatables/spawning/dungeon/som_mining_facility.tab` rows 18/25/30/31, which I
re-fetched and confirmed. **Do not add, move or touch a single spawn line.**
This round is radials only.

The three shape-B items are loot drops on live and this tree has no loot wiring
for them. That is a separate open item and is NOT in this round.

## What to build

### 1. New file: `screenplays/mustafar/quest/BountyHuntGiverMenuComponent.lua`

Copy the shape of `screenplays/mustafar/quest/HkHistoryDatapadMenuComponent.lua`
-- same directory, same declarative attach, same `_G[...]` screenplay lookup.
For the two-button SUI copy `screenplays/jedi/components/ForceShrineMenuComponent.lua:69-74`.

One component serves all seven. Branch on
`SceneObject(pSceneObject):getTemplateObjectPath()` against a table keyed by the
full `object/tangible/item/som/<name>.iff` path. Precedent for that lookup:
`screenplays/dungeon/corellian_corvette/corvetteContainerComponents.lua:46`.

- `fillObjectMenuResponse` -- look up the giver. Shape A: always add the radial.
  Shape B: add it only when `SceneObject(pSceneObject):isASubChildOf(pPlayer)`,
  which is this tree's equivalent of `utils.getContainingPlayer(self) != null`
  and is what `HkHistoryDatapadMenuComponent.lua:29` already uses for an
  inventory item. Radial id 20, type 3, same as the datapad.
- `handleObjectMenuSelect` -- guard `selectedID ~= 20`. Shape B: if not a
  subchild of the player, send `@som/som_quest:unable_to_examine` and stop.
  Then if `bountyHuntsScreenPlay:isHuntActive(pPlayer, key)` send the `already`
  string and stop. Shape A: call `grantHunt` directly. Shape B: show the SUI.
- SUI callback -- `eventIndex == 1` is cancel (`HkHistoryDatapadMenuComponent.lua:57`),
  send `@som/som_quest:quest_decline`. On OK: `grantHunt`, send the `destroy`
  string, then `SceneObject(pObject):destroyObjectFromWorld()` and
  `destroyObjectFromDatabase()`.
- To recover the clicked object in the callback, write its object id and the
  hunt key to screenplay data before `sendTo`, and read it back with
  `getSceneObject(...)`. That is the tree's own pattern --
  `mensix_mining_facility_main.lua:350` uses `getSceneObject(readData(...))`.
  Use the `bountyHuntsScreenPlay` screenplay name so the keys live with the arc.

### 2. Attach it on seven templates in `object/custom_content/tangible/item/som/`

```
lava_flea_bounty.lua  lava_lizard_food.lua  lava_beetle_beads.lua
jundak_hunter_hologram.lua  blistmok_heart.lua  tulrus_parts.lua  xandank_jaw.lua
```

Each is currently an empty `:new { }`. Add exactly one line, matching
`droid_factory_history_datapad.lua:2` character for character:

```lua
	objectMenuComponent = "BountyHuntGiverMenuComponent",
```

### 3. Register it

Add to `screenplays/screenplays.lua`, immediately after line 789
(`includeFile("mustafar/quest/HkHistoryDatapadMenuComponent.lua")`):

```lua
includeFile("mustafar/quest/BountyHuntGiverMenuComponent.lua")
```

`bounty_hunts.lua` is included at line 787, so the screenplay exists first
either way; the `_G` lookup happens at click time regardless.

### 4. Update the two stale headers

Both currently assert there is no giver. Both are now wrong and a future reader
will trust them.

- `bounty_hunts.lua` -- rewrite the `NO GIVER` block. Say the givers were found
  in the live SERVER source, that they are radials on tangible objects rather
  than a conversation NPC, name the file that now calls `grantHunt`, and keep
  the note that the `.qst` files themselves name nothing (that part is still
  true and is why it was open).
- `mensix_mining_facility_main.lua` -- rewrite the `WHAT THIS DOES NOT DO` block
  at 155-161. It is now what this DOES do. Keep the placement evidence and the
  cross-check above it untouched; only the last paragraph changes. Explain that
  the empty `script` column was a red herring because the attach is in the
  `.tpf`.

Write both in the plain, evidenced voice the rest of those files already use.

## HARD CONSTRAINTS

- Do not add, remove or move any `spawnSceneObject` or `spawnMobile` call.
- Do not touch `bounty_hunts.lua` below its header comment. The engine
  (`grantHunt`, `turnInHunt`, the kill observer, the hunts table) is correct and
  finished. Comments only in that file.
- Do not invent a string. Every user-visible string must be an `@som/som_quest:`
  reference from the table above. If you think one is missing, STOP and say so.
- Do not add XP, credits, waypoints or journal entries. `grantHunt` already
  handles the payout path.
- Do not wire loot for the three shape-B items. Out of scope, flagged separately.
- Do not run a build or a server. Do not commit. Do not create branches.
- Tabs for indentation, matching the surrounding files.

## Definition of done

One new screenplay file, seven one-line template edits, one `includeFile` line,
and two rewritten header blocks. Report `git diff --stat`. Every one of the seven
templates must resolve to a hunt key that exists in `bounty_hunts.lua`; if any
does not, STOP and report rather than guessing.
