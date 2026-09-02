# Mustafar — what is built but unreachable

Standing rule: **live-faithful, invent nothing.**

**Rewritten 2026-08-30 after a five-agent sourcing pass.** The 08-29 version of this file said every
gap could only be closed by authoring content. **That was wrong**, and the reason it was wrong is a
single bad search habit described below. Most gaps are now sourced. Items marked ⚠ CORRECTED are
places where an earlier version of this file, or a screenplay comment, states something false.

Code status: Mustafar boots clean — zone deployed, 71 regions, 5,947 snapshot objects, zero
Mustafar-attributed errors. Rounds M1–M3b fixed six runtime defects.

---

## ⚠⚠ ROOT CAUSE — never glob on a `som_*` / `must_*` prefix to decide what shipped

SOE named Mustafar data after the **quest**, not the NPC, and did not apply the `som_` prefix to
everything authored before that convention existed. Prefix-globbing has now produced **four** proven
false negatives on this project:

1. **Six giver conversation tables** declared "not shipped". They ship. (Below.)
2. **`droid_factory_off.ilf` / `droid_factory_on.ilf`** — `_QUEST_BRIEF.md` and
   `story_arc_chapters.lua:209` say no droid factory `.ilf` shipped. Both ship, in
   `mtg_patch_017.tre`. They simply carry neither prefix.
3. **`lava_beetle_nests.lua`'s "Donko Jen DOES NOT EXIST ANYWHERE"** — his conversation table ships.
4. During this very pass, one of the five research agents re-made the same mistake, searched
   `som_*.stf` only, and reported Donko Jen's and Renlo Hens's tables as NOT FOUND. Both were
   already sitting in another agent's confirmed list.

**Enumerate the TRE table of contents and match on CONTENT.** And note that a raw byte-grep of a
`.tre` is worthless — the TOC is zlib-compressed. Grepping `mtg_patch_019.tre` for
`som_storm_lord_jural.stf`, a file that demonstrably ships and already has a built tree, returns
nothing. Always run a control before believing a negative.

---

## ⚠⚠ ROOT CAUSE 2 — the client TREs are not the source of record. The SERVER source survives.

**Added 2026-09-01, after it produced the second false "open question" on this project.**

Every "nothing in the shipped data says what this does" verdict written here before 08-30 was
searching the client TREs and the world snapshot. Those never contained behaviour. Quest logic,
loot tables, creature stats and spawn scripts lived server-side, and SOE's server source leaked:
**`github.com/SWG-Source/dsrc`**, under `sku.0/sys.server/compiled/game/`. Raw fetch pattern:

```
https://raw.githubusercontent.com/SWG-Source/dsrc/master/sku.0/sys.server/compiled/game/<path>
```

It holds `datatables/mob/creatures.tab` (2.2 MB, **292 `som_*` rows** with base level, difficulty
class, loot table and aggression), the whole `datatables/loot/` tree,
`datatables/spawning/dungeon/*.tab`, `script/quest/som/*.java`, `script/library/*.java`, and the
`.tpf` object templates. None of it shipped in a client TRE, which is why every earlier audit
missed all of it.

Two proven false negatives from this habit, both of which had been written down as decisions
waiting on Aaron:

1. **Trophy hunts** — closed 2026-08-30. Its own header records the lesson: *"I was looking only
   at the client TREs and the snapshot. The client never had this data. SOE's own SERVER-side
   tables did, and they survive."*
2. **Bounty-hunt givers** — closed 2026-09-01, commit `5b93aac7bf`. The blocking belief was that
   the spawn table's `script` column is empty so nothing says a click does anything. **Live
   attaches object scripts at the TEMPLATE level, in the `.tpf`, not at the spawn-table level.**
   The column is empty on every row of every dungeon table for that reason. All seven giver
   scripts exist and were transcribed.

**Before writing "this is unknowable from the shipped data", fetch it from dsrc and prove it
isn't.** The corollary matters as much: an empty column in a spawn table is not evidence of
absent behaviour. Check where that engine attaches behaviour before reading a blank as a no.

---

## How a community `/way` becomes a coordinate

`quest/mining_field_markers.lua:41`, verified against 30 marker rows in that file:

```
world_x = way_x - 2880        world_y = way_y + 2976
```

Mensix Mining Facility cell-local, closed form: `local_x = way_x - 459.50`,
`local_y = way_y + 1208.92` (origin `-2420.50, h 199.40, z 1767.08`).

⚠ **CORRECTED — do not cite Jural as the calibration proof.** An earlier version of this file, and
two verbal reports, claimed `storm_lord.lua:382`'s `(440, 5115)` was an *independent* 1 m match
against `/way 3321 2139`. **It is circular.** The file says in its own words, twice, that the value
was "converted from a live-era community waypoint through the proven Mustafar offset" — in the
header at `storm_lord.lua:244-246` and again above the giver table at `:419-421`. (The citation
here read `:377-378` until this sweep; that line pair holds a `taskName` and is unrelated. The
correction stands, only its pointer was wrong.)

The transform is still well established, but from these genuinely independent anchors:

| anchor | agreement |
|---|---|
| lava beetle camp `/way -506 2355` → `campX/campY` | exact |
| xandank hunt `/way 1264 1299` → `huntX/huntY` | exact |
| 5 chem locker `/way`s → snapshot nodes 12110160, 12111127-8, 12112910, 12113486 | 1–4 m |
| 4 lava beetle nest `/way`s → nodes 12111375-8 | 1–4 m |
| Mensix junk dealer `/way 369 -1256` → spawn at `mensix_mining_facility_main.lua:58` | 0.9 m |
| 2 xandank resting stones → nodes 12111126, 12111108 | 1.3 m, 2.0 m |
| 4 Berken's Flow markers → `mining_field_markers.lua:120,127,134,141` | exact |

⚠ **Standing limit.** NPC placement was server-side — absent from the client TREs and from
`snapshot/mustafar.ws`. A converted player `/way` is the best evidence class available for an NPC,
not a datatable read. **World objects are different: those DO ship in the snapshot**, so "which node
was clickable" is answerable from data in a way "where did an NPC stand" is not.

⚠ **Source weighting.** The live `creatures` datatable (mirrored at swgjunkyard.com) and the shipped
TREs are top class. Dated live-server player guides are high. **SWG Legends and SWG Restoration are
emulator reimplementations — their waypoints and timers describe their own servers, not SOE's.**
Treat them as weak.

---

## The conversation tables — the finding that unblocks most of Mustafar

**Six tables that three screenplay headers assert do not exist.** I parsed the **live** TRE table of
contents myself (not a pre-built index, not an agent's summary); all six are in `mtg_patch_019.tre`
and `mtg_planets.tre`, both loaded per `config.lua:174,176`:

| NPC | shipped table | rows |
|---|---|---|
| Miner Renlo Hens | `string/en/conversation/xandank_trophy.stf` | 20 |
| Foreman Nurfa Laz'op | `striking_miners_nurfa.stf` | 22 |
| Urup Fal'co | `striking_miners_urst.stf` | 20 |
| Chief Ulon Glost | `maneater_ulon.stf` | 15 |
| Foreman Donko Jen | `lava_beetle_nest_destroy_donko.stf` | 23 |
| the poison-miners giver | `miner_madness_chief_drono.stf` | 26 |

Each ends with the `do_not_edit` row *"automatically generated by the SwgConversationEditor"* — they
are complete editor exports, not fragments. Full `s_NN` → task mappings for all six were recovered.

⚠ **These three comments are FALSE and should be corrected when their files are next touched:**
`som_poison_miners.lua:149`, `som_striking_miners.lua:190`, `trophy_hunts.lua:42`. Each says no
conversation table ships for its giver. Each is a `som_*` prefix false negative. The bad 23-name
list is hardcoded at `_convgap.sh:8-16`.

### But only the STRING half shipped

**No conversation tree exists in any TRE** — no `datatables/conversation/`, no conversation `.iff`
anywhere across 303,133 TOC entries. So wiring a giver splits into two jobs under different rules:

- **The lines are data reference.** Every word is a real `@conversation/<table>:s_NN` against a
  shipped `.stf`. Allowed outright.
- **The branch graph is ours to author** — screen ids, option→next edges, state gating.

That boundary already has a precedent that shipped and passed:
`mobile/conversations/mustafar/som_storm_lord_jural.lua:4-6`, which documents itself as exactly this.
Mitigating: the editor numbered rows as it walked the tree, so a clean alternating NPC/player spine
is a strong structural hint. **Whether that precedent extends is Aaron's call, not mine.**

### Two identity mismatches inside SOE's own data — flagged, not picked

- **Urup Fal'co ↔ `urst`.** Cross-referenced: `urst:s_34` — *"You will need to speak with Nurfa
  Laz'op"*; `nurfa:s_21` — *"You can tell Urup we will come back to the negotiations"*. Same
  character. `urst` appears nowhere as a display name.
- **Chief Armstrong ↔ Chief Drono.** The `.qst` prose says Armstrong; the table is named for Drono.
  `"Armstrong"` occurs **zero times** in all 5,575 shipped English string tables, and `"Drono"`
  occurs only in the filename and its own boilerplate. Reads as a rename before ship. Both halves
  are shipped data and they disagree.

---

## Resolved — the three contested givers

| Quest | Verdict |
|---|---|
| **Maneater** | **Chief Ulon Glost**, `/way 449 -1156`, giver AND turn-in. `swglegends` and `swg.fandom` both reproduce `maneater_ulon.stf`'s `s_18`/`s_22`/`s_26` verbatim. ⚠ **`must_foreman_chivos.iff` in the `.qst` is a comm PORTRAIT, not identity** — proof is internal to shipped data: at `_allqst_dump.txt:13772` Chivos's *own* quest gives his comm appearance as `mustafarian_m_01.iff`, while `:11297` uses `must_foreman_chivos.iff` elsewhere. If the field were identity, Chivos would not be someone else in his own quest. Chivos is a separate NPC, own conversation table, ~44 m away in a different room. **The conflict was never real.** |
| **Striking miners** | **Urup Fal'co is the giver and turn-in**; Nurfa is mid-quest at the camp. The repo's own file already encodes this — `som_striking_miners.lua:19,32,37` transcribes task 4 as "Return to Urup Fal'co" and `:542` writes "You need to let Urup know…". The header's Nurfa reasoning at `:89-139` is about tasks 1 and 3 only and is **correct for those**. `:186` "Urup Fal'co does not exist" was true of the *template*, not the identity. Camp `/way -2516 1470` → world `(-5396, 4446)`, **1.9 m** from the existing `foreman_nurfa` spawn. |
| **Poison miners** | **Chief Armstrong**, `/way 309 -1269`, giver AND turn-in. Exactly the figure already on file; `swg.fandom` independently gives `308 -1268` (1 m apart). Converts to cell-local `(-150.50, -60.08)`, inside `small_room_05` — ~5 m from `surveyor_jo`. |

All three repo "does not exist" claims are **true about the creature template** (no `.iff` for any of
them in any TRE) and **wrong in the inference drawn from it** — that identity and position were
unknowable.

---

## Storm Lord — both open decisions close

**OPEN DECISION 1 — "touched" and "zealot" were ONE creature. CONFIRMED from the live datatable:**

```
creatureName  som_storm_lord_touched
name          a storm lord zealot
template      som/storm_lord_touched.iff
```

No `storm_lord_zealot` row exists in the 5,227-row table (404s on the mirror); no zealot `.iff`
exists in the client. **Consequence:** the repo's `storm_lord_zealot` is a repo-side duplicate whose
`templates` entry already points at `storm_lord_touched.iff` because there is nothing else. The
single spawn at `storm_lord_region.lua:47` **is** the live creature, standing under a registration
name `killTemplates` (`storm_lord.lua:319`) does not count. It contributes 0 of 10 today.

**Arrangement: an area population, not a cluster of ten.** The only live-era wording is *"Found all
around the ruins at [3077,1259]"* — the same phrasing as the minion leg the repo already models as
scattered. SWG Wiki gives the Prophet and Storm Lord exact points and gives the Zealot location as
literally **"(area)"**. Ten is the kill requirement, not the population.

That point lands on a **built camp the repo leaves empty** — two `must_smuggler_bunker` at
`(188.21, h 207.25, 4247.13)` and `(165.98, h 207.25, 4226.39)`, footprint ~x 162-201, y 4214-4252.
It is a *different* camp from the repo's Scavenger Camp: the live minion point `(327, 4236)` resolves
to the lower east camp at h ≈ 130, which is exactly where `storm_lord_region.lua:51-75` already puts
them. Live had minions low-east and zealots high-west, ~130 m apart, ~78 m of elevation.

**Prophet: static, outdoors, `cellID 0` is correct.** `(315, 3746)` is **5.2 m** from
`must_jeditemple_watchtower` at `(313.49, h 171.49, 3750.96)`, snapshot node 12110949 — which is a
`SharedStaticObjectTemplate` (`building/mustafar/structures/objects.lua:146`), has no cells, and has
zero children. Nothing else built within 39 m.

**Live stats — CONFIRMED from the datatable, and the repo diverges on all of them:**

| | zealot | prophet | repo has |
|---|---|---|---|
| display name | a storm lord zealot | Prophet of the Storm Lord | placeholder `customName`s |
| BaseLevel | **83** | **87** | 70 for both |
| difficultyClass | NORMAL | **ELITE** | — |
| socialGroup | storm_lord | storm_lord | `townsperson` |
| aggressive / assist | 24 / 24 | 9 / 9 | ATTACKABLE, no AGGRESSIVE |
| death_blow | no | **yes** | — |
| weapons | imperial_sword / force_sword_ranged | jedi_dark | `pirate_weapons_light` |

`faction = ""` is correct — `pvpFaction` is empty on every storm-lord row.

**NOT FOUND: simultaneous count, spacing, respawn interval.** Genuinely unrecorded. The Junkyard
spawn dataset has 0 rows for **all 40** Mustafar creatures sampled, including plain wild fauna — so
its empty `spawns` is not evidence either way. **Any specific number, position or timer is a
judgment call, not a source.** One live-era primary on Mustafar respawn does exist — SOE dev
SpaceRancor, 2006-03-24, in the scrapbook at `data\20070201102423\message_018.html`: *"We need to
remove those timer spawns on Mustafar…"* — but that is about the named bosses, not the zealots.

**Incidental:** `/way 3068 1613` → world `(188, 4589)` gives the `-- TODO add suitable NPC for Skar`
comment a live spot and level (CL84 Elite). And `som_storm_lord_high_priest` (CL85 ELITE) exists live
and is absent from the repo; the `.qst` does not ask for him — noted only so the shared appearance
isn't mistaken for a naming conflict.

---

## HK-47 history logs — there were never ten objects

**One exterior terminal grants one datapad; the datapad holds all ten entries behind a list.**
`string/en/som/som_quest.stf` carries the entire live UI vocabulary — I read these directly:

```
df_terminal_use           | Access Factory Memory Banks
df_terminal_datapad       | You downloaded the factory recordings to a datapad.
hk_history_datapad        | Access Record Archives
hk_history_datapad_01..10 | Entry #64951 .. Entry #64960
hk_history_datapad_select | Invalid Record: Please select a valid entry.
```

Ten short labels plus a "select a valid entry" error is a SUI list box. Ten separate world objects
would never need that shape. Corroborated by two walkthroughs and by the `.qst` itself
(`_allqst_dump.txt:13122`), which says **"exterior terminal"** in its own words and grants
`droid_factory_history_datapad.iff` as task 10's reward.

**Only one `droid_factory_history_terminal` node exists planet-wide** — 12112268, at
`(529.13, h 66.15, 1968.60)` — and `story_arc_chapters.lua:435` already binds it. There are no other
node IDs to find. So `registerTrigger` should **not** be wired to ten objects. The missing surface is
a radial on the datapad opening a `SuiListBox` of the ten labels, calling the existing
`playEntry`. **Every string needed already ships.**

⚠ **CLOSED — that surface was built and is wired.** `HkHistoryDatapadMenuComponent.lua` is exactly
the described thing: `fillObjectMenuResponse` adds the radial (`:17`), `handleObjectMenuSelect`
opens `SuiListBox.new("HkHistoryDatapadMenuComponent", "entryCallback")` (`:39`), and
`entryCallback` calls `history:playEntry` (`:82`). It is attached declaratively —
`object/custom_content/tangible/item/som/droid_factory_history_datapad.lua:2` sets
`objectMenuComponent = "HkHistoryDatapadMenuComponent"` — and loaded at
`screenplays/screenplays.lua:789`. Read "the missing surface" as history, not as a gap.

**Entry 7 is the only gate.** `37323` appears nowhere else in any TRE. "Access port AG4" is
decorative. Entries 1–6, 8–10 are lore. Ten `.stf` strings verified 40/40 byte-identical to the
repo's transcriptions, and the repo picked the correct one of the two shipped copies (the
typo-bearing `quest/ground` set is the one that actually rendered — a player's transcription
reproduces its typos).

**Flagged, not filled:** `df_keypad_unknown = "You do not know the correct access code."` is a
*knowledge* gate distinct from the wrong-code gate — live refused the code if you had not read entry
7. `useFactoryKeypad` (`story_arc_chapters.lua:1422`) has only the wrong-code path, so today any
player can type `37323` cold. `hk_history.lua:336` already exposes `hasPlayedEntry(pPlayer, 7)`,
which is exactly that predicate.

⚠ **CLOSED — filled, using exactly that predicate.** `story_arc_chapters.lua:2149-2155` reaches
`hk_history` through `_G["somHkHistoryScreenPlay"]` so this file keeps no hard dependency, checks
`hasPlayedEntry(pPlayer, self.factoryHistoryEntry)`, sends `@som/som_quest:df_keypad_unknown` and
returns *before* the wrong-code branch. Typing `37323` cold is refused now.

---

## Bounty hunts — all seven mapped and WIRED; no NPC giver by design, now proven

Three loot-drops, four clickable props. Confirmed by live-era guides.

| Quest | Live title | Start |
|---|---|---|
| `blistmok` | The Deadly Raptors | loot **Blistmok Heart** |
| `tulrus` | Beasts From the East | loot **Ivory Tulrus Tusk** (self-destructs after granting) |
| `xandank` | Hunter Becomes the Hunted | loot **Massive Xandank Jaw**, radial "Study Jaw Closely" |
| `jundak` | The Jagged Teeth | **Medical Hologram**, `/way 386 -1080` |
| `tanray` | The Tasty Tanray | **Plate of Tanray Meat**, `/way 388 -1167` |
| `lava_flea` | Lava Flea Hunt | **Bounty Document: Lava Flea**, `/way 379 -1245` |
| `lava_beetle` | A Strange Gem | **Kubaza Beetle Beads**, beside the junk dealer, cell 12112245 |

**The SOE publish note, read in full** — scrapbook `data\20070126114830\content.html`, archived from
`starwarsgalaxies.station.sony.com`, Chapter 3 publish notes, Sept 27: *"Trials of Obi-Wan: The Lava
Flea Hunt document can simply be clicked on to complete the quest, instead of requiring the use of
the radial menu."* ⚠ That is **direct SOE proof for one hunt and for the mechanism class** — the
08-29 framing of it as corroboration for "all seven" overstated it. It is the only Mustafar-quest hit
in the entire 1,192-folder scrapbook.

⚠ **Updated 2026-08-31 — the four props now STAND, and none of them is WIRED.** Rows 16/23/28/29
of `som_mining_facility.tab` were placed in `mensix_mining_facility_main.lua` (commit
`8c2c93a99a`), each within a metre of the `/way` in the table above. That closes the *placement*
half of every row in this table and leaves the *mechanism* half exactly where it was.

Two facts pull in opposite directions here and both are kept, because picking one would be
inventing the answer:

- The `script` column of `som_mining_facility.tab` is **empty on all four rows**. The spawn table
  attaches no behaviour to any of them.
- The SOE publish note above is **direct proof that clicking the Lava Flea document completed the
  quest** on live. So a behaviour existed; it lived in a server script SOE had and this extract
  does not.

✅ **CLOSED 2026-09-01. The mechanism was found, not decided. Commit `5b93aac7bf`.** The two facts
above never actually conflicted — the empty `script` column was a red herring. On live, quest
scripts attach at the **template** level, in the `.tpf`, not at the spawn-table level. That is why
the column is empty on every row and why every audit that looked at the table concluded there was
nothing there.

The server script SOE had is not lost. `github.com/SWG-Source/dsrc` is the leaked live SWG
**server** source and it carries both halves — each `.tpf` naming its script, and the
`script/quest/som/*.java` bodies themselves. All seven were read directly:

| template | live script |
|---|---|
| `lava_flea_bounty` | `quest.som.lava_flea_bounty` |
| `lava_lizard_food` | `quest.som.lava_lizard_food` |
| `lava_beetle_beads` | `quest.som.lava_beetle_beads` |
| `jundak_hunter_hologram` | `quest.som.jundak_hunter_hologram` |
| `blistmok_heart` | `quest.som.blistmok_heart` |
| `tulrus_parts` | `quest.som.tulrus_mandible` |
| `xandank_jaw` | `quest.som.xandank_jaw` |

Note the tulrus row — template `tulrus_parts`, script `tulrus_mandible`, strings keyed
`tulrus_horn_*`. Three names for one object, and there is no `tulrus_mandible.tpf` (404).

The bodies split two ways. **Shape A**, the four static props: add an `ITEM_USE` radial, grant on
select if not already active, else send the ALREADY string. No containment check, no confirm box,
no destroy — furniture you click, exactly as the SOE publish note describes. **Shape B**, the three
loot items: radial only while the item is in the player's possession, then
`mustafar.activateQuestAcceptSUI` (`script/library/mustafar.java:307-316`), a plain YES/NO box;
OK grants, sends DESTROY and destroys the object, CANCEL sends DECLINE.

Ported as `screenplays/mustafar/quest/BountyHuntGiverMenuComponent.lua` — one component for all
seven, keyed by template path, attached with `objectMenuComponent` on the seven templates. Not one
spawn line was added, moved or touched.

**This was closed from the source of record, not by a ruling.** It sat here as an open decision for
Aaron; the answer turned out to exist and be quotable, so it was transcribed rather than decided.
The one place the port knowingly departs from live is a `isInRangeWithObject(pSceneObject, 8)`
guard on shape A, which live has no equivalent of — it matches the in-tree sibling
`trophy_hunts.lua:1580` instead. Both are noted in the commit so either can be reversed.

This is the second arc to hit the same trap. `trophy_hunts.lua` climbed out of it on 2026-08-30
with the same lesson in its own header: the client never had this data, SOE's server-side tables
did, and they survive. **Any future "nothing in the shipped data says what this does" finding on
this project should check `SWG-Source/dsrc` before it is written down as open.**

~~⚠ **Still open, and not silently patched:** the three shape-B items are loot drops on live and this
tree has no loot wiring for them, so today only the four static props are reachable in game. See
*Loot* below.~~

**CLOSED 2026-09-01, commit `7e84038385`.** All three now drop. See *Loot — the three trophy items*
below for the rate derivation and the mechanism. The line above is kept so the closure is visible
rather than the finding just vanishing.

**The props are wireable with zero authored strings.** None of the six Mensix interior props exists
as a snapshot node — the whole Mensix building (node 12112217, 30 cells) contains exactly **two**
objects, a `beetle_flame` and a `rare_heavy_lava_cannon`. They were server-side placements. **But
every prop's client template ships** in `mtg_patch_022.tre`, every server template already exists in
the repo (`object/custom_content/tangible/item/som/`), and every name and description string ships in
`string/en/som/som_item.stf` (137 keys). Placement precedent is in-tree already:
`mensix_mining_facility_main.lua:31` uses `spawnSceneObject` into a Mensix cell.

---

## Trophy hunts — three quests, one giver, two props

⚠ **CORRECTED — three quests, not four.** Four entry points at `:64-67` because
`som_xandank_trophey` has a separate turn-in.

- **`som_xandank_trophey` = "A Whole Pack of Trouble"** — giver **Miner Renlo Hens**, confirmed, with
  a full grant + turn-in transcript. `/way -2522 1452` → world `(-5402, 4428)`; the existing spawn at
  `regions/smoking_forest_region.lua:32` is **4.5 m** away. His conversation table
  (`xandank_trophy.stf`) ships. ~~Only `conversationTemplate ""` blocks him.~~
  **CLOSED — he is wired.** `mobile/custom_content/som/miner_hens.lua:33` now reads
  `conversationTemplate = "xandank_trophy"`, and `trophy_hunts.lua:64-65` records the same finding
  in its own header. Nothing blocks him; this line is kept only so the strikethrough shows the
  item was closed rather than dropped.
- **`som_blistmok_rug` = "Skin the Blistmoks"** — clicked prop, `/way 443 -1124`. No giver.
- **`som_jundak_skull` = "Skull of the Jundak"** — clicked prop, `/way 372 -1256`. No giver.

**All the repo's snapshot node IDs verify** against `stardust_03.tre` — both resting stones, five den
lairs, all five chem lockers.

### Two candidate repo defects here — ⚠ BOTH ARE CLOSED. The text below is the original finding.

**Both say "Not changed" and both were changed afterwards. Do not read them as live.** They are
kept because the reasoning is still the record of how each was decided.

- **Bleach vat — CLOSED, and the waypoint was right.** It now sits in `small_room_04`, cell
  **12112238**, at `(-16.6, 19.1, -11.3)` — `trophy_hunts.lua:343-350`. What settled it was not the
  waypoint but `som_mining_facility.tab` row 26, which gives that room and those coordinates
  verbatim. The table and the live `/way` agree with each other and against the old placement, so
  this stopped being a judgment call the moment the table was read.
- **`soakSeconds` — CLOSED at 10, and not on the weak source.** It is `10` at
  `trophy_hunts.lua:490`. The SWG Legends figure was correctly refused; what replaced it was two
  independent live-era sources — SonGouki's ToOW guide (SOE official forums, Nov 2005) and the
  *Skull of the Jundak* wiki page as of 2008 — which agree on 10 s and match the quest's own task
  text, "it should clean it up rather quickly". 180 never fitted that sentence.

*Original finding, unedited:*

- **The bleach vat may be ~120 m out.** `trophy_hunts.lua:226-234` puts it in `small_room_03`, cell
  12112234, local `(-131.5, 47.5)` — internally consistent, that is inside `small_room_03`'s box
  (x -137.68..-114.68, y 34.45..55.13). But live `/way 442 -1220` → local `(-17.5, -11.08)`, which is
  inside `small_room_04`'s box (x -34.79..-11.66, y -27.38..-3.60) = cell node **12112238**. Both are
  real rooms; the waypoint is the only evidence. **Not changed.**
- **`soakSeconds = 180` (`:347`)** — a source says 10 s. ⚠ That source is SWG Legends, an emulator
  server, which is the weak class. **Not changed on that basis alone.**

⚠ **One agent claim REFUTED — do not act on it.** It reported the radial label `"Search the Area"`
as "invented and unverified". It is the `.qst`'s own `journalEntryTitle`, at `_allqst_dump.txt:14662`
and `:14698`, and `trophy_hunts.lua:1265-1268` already documents that and correctly identifies
`"Remove the skull from the vat"` (`:1297`) as the single authored label — task 6 describes the wait
but never names the action. The repo was right.

---

## Lava beetle nests — giver and nests both confirmed

**Foreman Donko Jen**, `/way 446 -1173`, Mensix, → cell-local `(-13.5, 36)` inside `entrance_room_01`.
Both full conversation transcripts survive, **and his conversation table ships**
(`lava_beetle_nest_destroy_donko.stf`, 23 rows).

⚠ **`lava_beetle_nests.lua`'s "NO GIVER — 'Donko Jen' DOES NOT EXIST ANYWHERE" is wrong** and should
be reworded. True of the client creature template; false of the live game and false of his dialogue.

**The nests were pre-existing world objects with a radial**, not quest spawns. All four repo node IDs
verify against community waypoints to 1–4 m: 12111375-8. Camp `/way -506 2355` → repo `campX/campY`
exactly.

---

## Seismic charges — confirmed negative, and it is a clean one

⚠ **CORRECTED:** the screenplay is not missing — `screenplays.lua:791` includes it, 498 lines.

It shipped as **data** and never as **gameplay**:
- `.qst` (`_allqst_dump.txt:12262-12426`): every `LocationX/Y/Z` is 0.0, the Encounter task has **no
  Creature Type**, the Wait for Signal task has **no Signal Name**, Reward is **0 XP / 0 credits**.
- `.stf` is **three strings** — category, title "Seismic Charges", and a journal description. **No
  task text at all.**
- `shared_seismic_charge_stations.iff` ships and `som_item.stf` names it "Seismic Charge Station",
  but **nothing places it**: zero nodes in either live `mustafar.ws`, absent from the `.ilf`.
- No fandom page (the full Mustafar quest category is 43 items and it is not among them), nothing on
  any emulator wiki, nothing in the scrapbook.

**Leave stubbed.** No giver, no locations, no signal, no reward, no placed station, and no player
ever recorded doing it.

---

## Carried, not fixed — known and deliberate

- **`mining_field_markers.lua:569`** — `giveItem` can fail *after* `isContainerFullRecursive()`
  passes, and its return is discarded; the persistent `rewarded` flag is already written, so the
  player keeps the flag and loses the item. **Latent:** `completionItem` is `nil` at `:99`, so the
  branch is dead. It arms the moment anyone wires an item, which `:90` anticipates.
- **`cursed_shard.lua`** — the `"brood"` guard flag is set and never cleared. Harmless while the
  quest is one-shot; a GM stage reset to 0 would wedge it.
- **`samaritan.lua:582`** — `giveCrystal` arms one retry chain per hail. Confirmed harmless: quiet
  callbacks are idempotent and every chain ends when combat ends. Deduplicating would mean inventing
  a persistence slot on a shared world NPC.

## Noted, out of Mustafar scope

- `cities/hutta_bilbousa_city.lua:669` had the same `ObjectManager` bug, repaired for free by the M3
  fix. Never live — inside a `--[[ ]]` block, `:649`–`:683`.
- Copy-paste duplicates: `regions/north_west_region.lua:64,98` and
  `regions/smoking_forest_region.lua:38,48,50,56,82,150`.
- 15 `spawnSceneObject` calls in `boundaries/mustafar_boundaries.lua` collapse onto 7 coordinates.
- The two live snapshots are **not supersets of each other**: `mtg_patch_023` omits node 12112909
  (droid factory exterior door) which `stardust_03` has; `stardust_03` lacks 12112211 and 12112916.
  The port reads `stardust_03`, which is the right choice.
- **The custom weapon templates are all one stencil, and the som ones inherit its faults.**
  `som_disruptor_pistol.lua` and `som_ion_relic_pistol.lua` were **byte-identical to
  `custom_content/weapon/ranged/carbine_bothan_bola.lua` except two lines** — the object name and
  the `addTemplate` path. Verified by `diff`, not inferred. So both pistols carried the stencil's
  carbine identity unedited: `xpType = "combat_rangedspecialize_carbine"`,
  `certificationsRequired = { "cert_carbine_cdef" }`, `carbine_accuracy` / `carbine_aim` /
  `carbine_speed`, and the placeholder `minDamage = 99999999998` / `maxDamage = 99999999999`.

  **The cert half WAS a Mustafar defect, and the paragraph that used to sit here was wrong.**
  It said "this is not a Mustafar fact" and filed the whole thing under fork-wide. That
  conclusion did not survive a count. Certs across the 12 distinct SoM weapons, read off the
  files rather than assumed:

  | class | weapons | cert | xpType |
  | --- | --- | --- | --- |
  | 2h sword | massassi, obsidian, tulrus | `cert_sword_2h_axe` | `meleespecialize_twohand` |
  | lance | obsidian, xandank | `cert_lance_vibro_axe` | `meleespecialize_polearm` |
  | sword | mustafar_bandit, obsidian | `cert_sword_01` | `meleespecialize_onehand` |
  | carbine | republic_sfor | `cert_carbine_cdef` | `rangedspecialize_carbine` |
  | rifle | dp23, mustafar_disruptor | `cert_rifle_cdef` | `rangedspecialize_rifle` |
  | pistol | disruptor, ion_relic | was `cert_carbine_cdef` | was `rangedspecialize_carbine` |

  **10 of 12 already carried the correct certification for their own class.** Only the two
  pistols were missed. A stencil that 10 siblings were corrected off of is not a fork-wide
  policy — it is two files nobody finished. Fixed in `3f787292ca`: five lines each, `carbine` →
  `pistol` across `xpType`, `certificationsRequired`, `creatureAccuracyModifiers`,
  `creatureAimModifiers` and `speedModifiers`. Gate `ok=264 fail=0`, boot READY 40s. All 12 now
  certify correctly.

  **The damage half is still open and is still Aaron's call, for a narrower reason than
  originally stated.** The two pistols keep `minDamage = 99999999998` / `maxDamage = 99999999999`
  / `attackSpeed = 1` deliberately — they were not touched by that commit. The split is clean,
  and it is a Mustafar split rather than a fork one:

  - **All 7 melee SoM weapons ship real authored damage** — 2h swords 75/125, lances 100/375,
    swords 60/250. Consistent within each class, and every `_generic` variant matches its parent
    exactly.
  - **All 5 ranged SoM weapons sit on placeholder damage**, and on *two different* placeholders:
    the carbine and both pistols on `99999999998`/`99999999999`, both rifles on
    `9999998`/`9999999`. Two magnitudes means two stencils, so the ranged set was never costed
    by anyone at any point — not once, not partially.

  Naming those numbers is a design decision about how hard a SoM ranged weapon hits, and I am
  not making it. Recorded so it is not re-found as a bug. Relates to *The SoM weapons* below,
  which counts the pistols among the 22 orphans.

  ⚠ **`ranged/heavy/som_republic_flamer.lua` reads like a third instance of this defect and is
  not one. Do not "fix" its cert.** It reports `cert_sword_2h_axe` /
  `combat_meleespecialize_twohand` on a file whose name says flamethrower, which looks exactly
  like the pistol bug. It isn't: the file is a verbatim copy of stock `2h_sword_kashyyk`, object
  name and `addTemplate` path included, confirmed by `diff --no-index`. Editing the cert would
  make an unauthored stock copy *look* finished. See *The SoM weapons* below, which already owns
  this — all four `ranged/heavy/` files, why no art exists for either, and why
  `custom_content/weapon/serverobjects.lua` must never be included. Those four are excluded from
  the 12 above for that reason.

## The full content census — what ships, what is reachable, and the proof for the rest

Run after R8. Every number below is from a script over the tree, not an estimate, and every
"nothing exists" is a search that was actually run. Three of these started as subagent findings
and all three were wrong on first report; the numbers here are the primary reads.

### Creatures — 159 registered, 131 referenced, 28 not

`addCreatureTemplate(obj, "name")` second argument over the 161 `mobile/custom_content/som/*.lua`
files, then each name searched as a quoted string across all 47,367 `.lua` files in `scripts/`.

⚠ **This heading used to read "158 registered, 127 reachable, 31 not". Both halves were stale.**
159 is the registered count — `skar.lua` is the 159th file and was missed. 28 is the unreferenced
count, and it dropped by two because this port placed them: `sher_kar` now spawns in all 12
`must_monster_lair` copies via `mustafar_dungeon_population.lua`, and `scorching_terror` sits
beside his sourced partner at `mensix_facility_region.lua:73`. Re-run the two commands in the
paragraph above before quoting any of these numbers again.

**Two of the 28 are correctly unplaced, and placing them would be the bug.** Both are
`NPC Appearance Server Template` values on Comm Player tasks — a portrait for a recorded
message, not a world spawn:

- `master_kah` — `quest/som_jedi_dog.qst` task 1. Already reasoned out at `jedi_dog.lua:155-159`.
- `neimoidian` — `quest/som_hk_history_{one,two,three,four,five,six}.qst`, the six Neimoidian
  factory log entries. Same task type, same field.

`obi_wan_ghost` is fenced and untouched.

**The other 25 have no placement source anywhere.** All 28 names were searched byte-wise across
all 516 files of `C:\swg-extract\_som`. Outside the two above, not one is named by any `.qst`,
any datatable or any snapshot. Every one of them ships client art
(`shared/object/mobile/som/shared_<name>.iff`) and nothing else. Art without a placement is not
a placement.

**Seven of the 25 are ORF fauna, and their own dungeon table is the proof.**
`datatables/spawning/dungeon/som_old_republic_facility.tab` is a real, live, fully-populated
table — it carries `room` / `loc_x` / `loc_y` / `loc_z` / `yaw` / `respawn_time` rows for
`som_orf_ancient_patrol_drone`, `som_orf_ancient_security_drone` and `som_orf_flea_hatchling`.
So the ORF dungeon is not a table that was never written; it was written, and these seven were
left out of it:

```
orf_angler               NOT FOUND    orf_vesp                 NOT FOUND
orf_mawgax               NOT FOUND    orf_vir_vur              NOT FOUND
orf_reptilian_flier      NOT FOUND    orf_whisper_bird         NOT FOUND
orf_torton               NOT FOUND
```

NOT FOUND = the name appears nowhere in any file under `datatables/spawning/`, not just nowhere
in the ORF table. This is the strongest form of the same shape as the other 25 — existence
without placement — because here the placement file for their own building exists, is complete
for their siblings, and still does not name them. Inventing rows for them would be inventing
content, not transcribing it. Left unplaced.

**Two more, `cinderclaw` and `tremor_foot`, have a sourced partner but no anchor to step off.**
These are the two that came closest to being placed and were deliberately not. Each sits in a
two-row `ground_spawning/types/mustafar/*.tab` — the same shape that let `scorching_terror` be
placed beside Deathsting — but in both cases the partner turns out to have no fixed world point
to measure from:

| creature | table (2 rows) | partner | where the partner actually is |
|---|---|---|---|
| `cinderclaw` | `elite_jundak.tab` | `jundak_devourer` | a quest hunt target at (-1616, h 40, 4275), `trophy_hunts.lua:467-472`. No region file covers that area. |
| `tremor_foot` | `elite_tulrus.tab` | `tulrus_magma_drenched` | spawned **player-relative** as Foehorn — `maneater.lua:274-278`, `foehornMinDistance 25` / `foehornMaxDistance 50`. It has no fixed anchor at all. |

That is the whole difference from Scorching Terror. His partner, Deathsting, is standing at a
literal coordinate in a region file, so stepping 23.6 m off it is a measurement. These two have
a sourced *pairing* and no sourced *place*, so a coordinate for them would be invented outright.
Left unplaced.

Both tables read the same way — `strItem` / `fltSize`, two rows, weight 5 each:

```
elite_jundak.tab            elite_tulrus.tab
  som_jundak_devourer  5      som_tulrus_magma_drenched  5
  som_jundak_cinderclaw 5     som_tremor_foot            5
```

`ground_spawning` groups them; it does not position them. Nothing under `datatables/spawning/`
references either table by name, which is why the group never reaches the world.

⚠ **STRIKE "or any snapshot" FROM THAT SENTENCE, AND FROM EVERY OTHER CREATURE CLAIM IN THIS
DOCUMENT. It is not evidence of anything.** A world snapshot cannot hold a creature. Reading
`snapshot/mustafar.ws` from `stardust_03.tre` directly:

```
OTNL names: 354   NODE placements: 5947
  object/static      161
  object/building    121
  object/tangible     71
  object/cell          1
  object/mobile        0
```

Zero `object/mobile` templates out of 354, and therefore zero of the 5947 placements. That is not
a Mustafar fact — it is what a `.ws` file *is*. Creatures come from `datatables/spawning/`, from
dungeon tables, and from screenplays; the snapshot is terrain furniture and buildings. So
"`<creature>` is not in the snapshot" carries exactly no information, and this document leans on
it in 19 places. The **conclusion** for these 28 still stands, because the `.qst` and datatable
halves of the search were real and did the work. The snapshot half never did. Every future
"nothing places this creature" claim needs the first two and must not cite the third.

The same phrase IS meaningful for the non-creature objects in the next section, where the
snapshot is the correct place to look and 30 of 127 were found there. Same words, opposite
weight — which is precisely why it slipped through.

### Non-creature objects — 127 defined

⚠ **127 is not the whole set — it was scoped by filename prefix and misses 53 templates.** The
dungeon interior objects have no `som_` / `must_` prefix, so none of them were ever in this count.
Full accounting under *A census scope hole* below. The 127 figure and its three buckets are still
correct for what they cover; they just do not cover everything.

- **30** are not referenced by iff path but ARE placed in `snapshot/mustafar.ws`. **28 of those
  are correctly wired by snapshot node ID** — which is why an iff-path search calls them dead and
  is wrong. `jedi_watch_dog_chest` / `_datapad` are the clearest case: bound at
  `jedi_dog.lua:297-298` as `12110930` / `12113081`.
- **2 are genuinely orphaned props**: `kenobi_dark_jedi_brain` (node 12111379) and
  `frn_holo_mustafarian_c` (node 12111380), sitting 0.64 m apart at the Sith altar
  (-4537.5, h 85.2, 3192.9). Nothing on disk claims either node. The `_reward` variants of the
  holo are a different iff and are used, at `moral_choice.lua:247-248`.
- **34** are neither referenced nor in the snapshot: 7 pet control devices, 2 doors, 8 items,
  the 3 final-chamber objects, 14 weapons.

  Three of those five groups have moved since:

  - **4 of the 8 items are in**, placed 2026-08-31 from `som_mining_facility.tab` rows 16/23/28/29
    (`mensix_mining_facility_main.lua`, commit `8c2c93a99a`): `lava_beetle_beads`,
    `jundak_hunter_hologram`, `lava_flea_bounty`, `lava_lizard_food`. Checked against the tree at
    the previous commit `e19d400b1b`, three had zero references and the fourth had exactly one —
    a *comment* in `bounty_hunts.lua`, not a placement. All four now stand where SOE put them, and
    all four agree with a player `/way` to under a metre. See *The Mensix page* below.
  - **The 7 pet control devices are in.** `object/custom_content/serverobjects.lua:50` includes
    `custom_content/intangible/pet/som/serverobjects.lua`, because the retune gave 7 families a
    `tamingChance` and a `controlDeviceTemplate`. See the loader section below.
  - **"14 weapons" is 12, and 4 of the files are not weapons of this planet at all** —
    `som_lava_cannon{,_generic}` and `som_republic_flamer{,_generic}` are verbatim copies of the
    stock `heavy_rocket_launcher` and `2h_sword_kashyyk`, saved under som filenames, with no
    `shared_som_*` client half anywhere. Full table under *The SoM weapons* below. The real
    figure is 12 distinct weapons in 23 templates, and `som_sword_obsidian` is already reachable
    (`serverobjects.lua:19`, the Symbiosis reward), so 22 of the 23 are the live orphan count.

### Three clusters that shipped complete but unconnected — one is now connected

⚠ Updated 2026-08-31. Sher Kar's lair is wired and boot-proven. The other two are open
decisions for Aaron, each reduced to a single question rather than a survey.

**Sher Kar's lair. — CLOSED, the room is open and populated.** The finding as written: the pool
carried 12 building copies and door node 12110143 (`shared_must_sherkar_door.iff`) with
`entry = nil`; `sher_kar` and `sher_kar_syringe` both registered; and **no `.qst` on disk
connecting them** — `sher_kar` / `sherkar` hits only the appearance iff, the snapshot and the
item string tables.

The missing `.qst` was never the blocker, and treating it as one is what kept the room shut for
three rounds. `old_republic_facility` has no `.qst` either and has always been enterable. The
real blocker was the second half — a radial into an empty room — and that is a thing you fix by
putting something in the room, not a thing you wait for a source to fix.

Both halves are now wired: `mustafar_instances.lua` gives the pool a real `entry` (cell `r1`,
certain — 456 of 456 nodes in `must_monster_lair.ilf` sit in it) and
`mustafar_dungeon_population.lua` gets a `lairBosses` table that puts `sher_kar` in all 12
copies. The arrival point is OURS and says so: no `monster_lair` dungeon table exists and the
`.pob` is unavailable, so the floor was fitted from 44 nest props
(`h = -3.74 + -0.1966*(z + 202.35)`, mean residual 0.24 m) and both points land inside it.
Boot evidence, 2026-08-31:

```
MustafarDungeonPopulation: 921 creatures placed across the Mustafar dungeon pools, plus 12 lair bosses
```

Still open and recorded in the file: `som_sherkar_consort` appears in `malfosa.tab` and has no
template anywhere in the repo. Authoring a creature outright is not a placement decision.

**The final chamber.** `som_kenobi_final_chamber_entrance_item`, `_crystal_pedestal` and
`_force_crystal` are registered, in no snapshot, in no dungeon table, in no `.qst`. Searching
all of `_som` for `final_chamber` / `final_crystal` / `som_kenobi_final` returns nothing at all,
and there is no dungeon table for this building at all — `spawning/dungeon/` holds 23 tables,
five of them `som_*`, none a crystal lair. The finale runs in `lair_of_the_crystal` without them.

**The location is now known even though the source still is not.** `som_obiwan_crystal_lair.ilf`
has TWO statue galleries, not the one the earlier note described:

- **gallery 1**, x 21..40, h ≈ 0 — 16 relic statues on the floor in two rows (z 2.50, z 7.65).
  The aisle between them is the arrival point (24.0, 5.1) and the boss's spot (37.0, 5.1).
- **gallery 2**, x 74..86, h ≈ 4.13 — 8 relic statues in a ring, each raised on its own
  `pillar_pristine_tall` at h -4.10. Eight statues, eight pillars, paired within a metre.

Gallery 2's ring centre is **(79.83, 5.29)**. `jeditemple_dome` sits at (79.81, 5.30) and
`jeditemple_platform_lrg` at (79.96, 5.19) — three objects agreeing on that centre to within
0.15 m, with nothing standing in it. A domed rotunda ringed by eight raised relic statues, empty
at the middle, next to two homeless tangibles called `final_crystal_pedestal` and
`final_force_crystal`.

It stays unplaced for one reason and it is not the old one: **the walkable height cannot be
derived.** The `.ilf` gives `platform_lrg`'s origin at h -0.79, not its mesh top, and
`som_obiwan_crystal_lair` exists in the extract only as that `.ilf` — no `.pob`, no `.msh`. The
x/z are as good as sourced; the h would be invented, and a pedestal sunk into or floating over
its own dais is worse than an empty shrine. Full working in `kenobi_spine.lua`, under
WHAT IS NOT MODELLED. **This is a one-line decision waiting on Aaron, not a survey waiting on
anyone.**

**The SoM weapons — 12, not 14, and four of the files are not SoM weapons at all.**
`primaryWeapon` resolves a *group* name registered by `addWeapon()` in
`mobile/weapon/groups/*.lua`. **No group contains any `som_*` weapon and no loot table
references one** — so every one of them is unreachable in play. The som creatures carry stock
groups instead, and the retune below kept it that way: it assigns only groups that
`mobile/weapon/serverobjects.lua` actually includes, so `som_lance_xandank` still sits unused
while `xandank.lua:34` and `orf_xandank.lua:31` carry `unarmed` as beasts. The name pairings are
suggestive and that is all they are: nothing on disk says which creature was meant to carry which
weapon. (An earlier version of this paragraph cited both xandank files as saying
`pirate_weapons_light`. That was true when written and is not now — the value moved, the finding
did not.)

**CORRECTION to the count, made by counting both halves instead of one.**
`object/custom_content/weapon/` holds **27** files named `som_*.lua` — 13 melee, 10 ranged,
4 ranged/heavy. The client side holds **23** `shared_som_*` weapon halves. The two sets agree
exactly once the four `ranged/heavy/` files are set aside, and they have to be set aside,
because **they do not define som weapons**:

| file | actually defines | actually registers |
| --- | --- | --- |
| `som_lava_cannon.lua` | `object_weapon_ranged_heavy_heavy_rocket_launcher` | `object/weapon/ranged/heavy/heavy_rocket_launcher.iff` |
| `som_lava_cannon_generic.lua` | `object_weapon_melee_2h_sword_2h_sword_kashyyk` | `object/weapon/melee/2h_sword/2h_sword_kashyyk.iff` |
| `som_republic_flamer.lua` | `object_weapon_melee_2h_sword_2h_sword_kashyyk` | `object/weapon/melee/2h_sword/2h_sword_kashyyk.iff` |
| `som_republic_flamer_generic.lua` | `object_weapon_melee_2h_sword_2h_sword_kashyyk` | `object/weapon/melee/2h_sword/2h_sword_kashyyk.iff` |

Four verbatim copies of two stock weapons, saved under som filenames. Neither
`shared_som_lava_cannon.iff` nor `shared_som_republic_flamer.iff` exists anywhere in the tree, so
there is no lava cannon and no republic flamer — no art, no template, nothing but the filenames.
They are not this branch's: `git log` puts all four in `b126156cac [merge] Additional MtG Object
Scripts`, and `git diff origin/unstable...HEAD` does not touch `custom_content/weapon/`.

> ### ⚠ CORRECTION — the "no art" half of that paragraph is WRONG. Round B disproved it.
>
> The paragraph above concluded "no art, no template, nothing but the filenames" from the absence
> of `shared_som_lava_cannon.iff` and `shared_som_republic_flamer.iff`. It checked the two
> **non-generic** names and generalised to all four files. The **`_generic`** appearances do ship.
>
> Round B (2026-08-31, commit `b67c6415e1`) wired both, and proved the art present at runtime:
>
> - `TemplateManager.cpp:474` — when a shared template sets a non-empty `clientTemplateFileName`,
>   `addTemplate` calls `openIffFile` on it, and a miss produces a `TreeArchive.h:85`
>   `<path> not found.` warning. **That is the only reliable positive test for a client iff.**
>   (`addClientTemplate` at `TemplateManager.cpp:1095` does no file I/O and can never warn.)
> - The boot after Round B produced **20 `not found.` warnings for unrelated Corellia filler iffs
>   and ZERO for either new shared iff** — so both resolved out of the TRE. The mechanism was
>   demonstrably live in that same boot, which is what makes the zero meaningful.
>
> **Do not grep TRE binaries for filenames to answer this question.** The filename tables are
> compressed; a known-good control (`shared_som_rifle_dp23_generic.iff`) also returns nothing. That
> method produces false negatives, and this correction exists partly because of it.
>
> Current state of the four files:
>
> | file | state |
> | --- | --- |
> | `som_lava_cannon_generic.lua` | **REWRITTEN + wired.** Anchored on stock `heavy_rocket_launcher.lua`, damage/range from live `weapon_stats.tab`, registers `.../heavy/som_lava_cannon_generic.iff` |
> | `som_republic_flamer_generic.lua` | **REWRITTEN + wired.** Anchored on stock `rifle_flame_thrower.lua`, same rule, registers `.../heavy/som_republic_flamer_generic.iff` |
> | `som_lava_cannon.lua` | **still a stock copy, deliberately left orphaned** — it registers the stock `heavy_rocket_launcher.iff`, so including it would overwrite the galaxy-wide rocket launcher |
> | `som_republic_flamer.lua` | **still the 2h-sword copy, deliberately left orphaned** |
>
> The galaxy-wide-overwrite warning below is therefore still fully in force for the two non-generic
> files. A new `custom_content/weapon/ranged/heavy/serverobjects.lua` (chained from
> `custom_content/weapon/ranged/serverobjects.lua:224`) names **only** the two rewritten files.
> Counted 2026-09-01: the directory holds **23 files — `serverobjects.lua` plus 22 weapon
> templates. 2 are now wired; the other 20 stay orphaned on purpose.**
>
> **Still weak, and disclosed rather than hidden:** both rewritten heavies keep their stock anchor's
> `experimental*` min/max curve, so the **crafted** path is not live-accurate. Only the looted /
> `giveItem()` path (`minDamage`/`maxDamage`) carries transcribed live numbers. Whether to retune
> the crafting curves is an open call for Aaron. Also disclosed: the draft schematic points at
> `object/weapon/ranged/rifle/rifle_som_lava_cannon.iff`, which is not a live path and is registered
> nowhere.

**This is the strongest argument yet for the one-file convention at
`object/custom_content/serverobjects.lua:12-19`.** If anyone ever "fixes" the unreachable som
weapons by adding `includeFile("custom_content/weapon/serverobjects.lua")`, those four files run,
and `addTemplate` **overwrites the stock `heavy_rocket_launcher` and `2h_sword_kashyyk` server
templates for the whole galaxy** — not a Mustafar bug, a live-server-wide one. Pull in the one
file an arc needs. Never the tree.

So the real figure is **12 distinct SoM weapons in 23 templates** (each has a `_generic` loot
variant except `som_2h_sword_massassi`): three 2h swords (massassi, obsidian, tulrus), two swords
(obsidian, mustafar_bandit), two lances (obsidian, xandank), two rifles (dp23,
mustafar_disruptor), two pistols (disruptor, ion_relic) and one carbine (republic_sfor).
All 23 have art, have a server template, and are reachable by nothing.
Only `som_sword_obsidian` is even registered, and only because the Symbiosis reward needed it
(`:19`). **Which creature drops which is an open design question for Aaron** — the extract's
server dsrc ships `datatables/spawning/` and nothing else, so there is no loot table and no
creature table to quote from. This is the largest remaining piece of Mustafar content that is
finished but undelivered.

### One defect of my own, found by the same check and fixed

The commit that moved 111 som templates off the dead `weapons` / `attacks` keys onto the live
`primaryWeapon` / `secondaryWeapon` / `primaryAttacks` / `secondaryAttacks` also changed the
weapon **value** on three of them. It should have changed only the key. All three shipped
`weapons = {"pirate_weapons_light"}` in `origin/unstable`:

| file | was written as | shipped value |
| --- | --- | --- |
| `storm_lord_prophet.lua:36` | `jedi_dark` | `pirate_weapons_light` |
| `storm_lord_touched.lua:36-37` | `imperial_sword` + `force_sword_ranged` | `pirate_weapons_light` |
| `storm_lord_zealot.lua:36-37` | `imperial_sword` + `force_sword_ranged` | `pirate_weapons_light` |

`jedi_dark` was the live one: `mobile/weapon/groups/jedi_dark.lua` exists and calls
`addWeapon("jedi_dark", ...)`, but `mobile/weapon/serverobjects.lua` never includes it, so the
group never registers and the Prophet — level 87, retail difficulty Elite — spawned with no
weapon at all. All
three were reverted to the shipped value at the time. The retune below has since moved all three
to `melee_weapons` on their tier, so `pirate_weapons_light` is no longer what they carry — the
defect and its cause stand as written, the current value does not. `mobile/weapon/` itself is
still untouched by this branch: `git diff origin/unstable...HEAD -- mobile/weapon/` is empty.

`jedi_dark` is one of **4 groups in `mobile/weapon/groups/` that no `includeFile` names** —
`carbine_weapons`, `geonosian_carbine`, `jedi_dark`, `jedi_light`. All four are upstream, and
after the revert all four have zero consumers: searching the **quoted whole string** `"jedi_dark"`
across `scripts/` returns only `addWeapon("jedi_dark", jedi_dark)` in the group's own file, and
the same holds for the other three. Search the bare substring instead and you get 52 unrelated
names — robes, furniture, an amulet, draft schematics — none of them a weapon group. Left alone
deliberately:
adding an include for a group nothing uses is not a fix. (`serverobjects.lua` also names
`weapon/groups/stormtrooper_weapons.lua` twice — harmless, `includeFile` is idempotent. 125
include lines = 108 naming `groups/` (107 distinct) + 17 elsewhere under `weapon/`.)

### Loot — all som creatures shipped dropping nothing; 100 now drop, 59 deliberately do not

**Status: the finding below is the diagnosis, and it has been acted on.** The retune (see *The
157-template retune* at the end of this document) filled loot on every som template that should
have it. Re-counted 2026-09-01, after Round C:

    grep -rl 'group = "'        mobile/custom_content/som/   -> 100 files
    grep -rl 'groups = {}'      mobile/custom_content/som/   ->   0 files
    grep -rl 'lootGroups = {},' mobile/custom_content/som/   ->  59 files
    ls -1                       mobile/custom_content/som/*.lua -> 161 files

161 files, two of which are not creature templates (`serverobjects.lua` and the `surveyor_jo.lua`
tombstone), so **159 creature templates; 100 + 59 = 159.** ⚠ An earlier version of this block said
96 / 62 / 158 — that was correct when written and is now stale, because this branch has since added
14 creature files to the directory and Round C moved three files between the buckets. The numbers
above are the re-counted current state, not an edit of the old ones.

The broken `groups = {}`-behind-a-live-`lootChance` state is gone from the directory entirely. The
remaining 59 carry an empty `lootGroups = {}` on purpose: they are the plain fauna and the
conversation NPCs, which in the base tree do not carry a loot table either. That is a real empty,
not a roll that resolves nothing.

#### Loot — the three trophy items (CLOSED 2026-09-01, commit `7e84038385`)

`blistmok`, `tulrus` and `xandank` were three of that deliberate-empty set. They should not have
been. Each is the sole live source of a bounty-hunt giver item, and with `lootGroups = {}` the
three shape-B hunts (`som_blistmok_hunt_25`, `som_tulrus_hunt_20`, `som_xandank_hunt_25`) had no
entry point at all — the giver templates were registered and carried
`objectMenuComponent = "BountyHuntGiverMenuComponent"`, but nothing in the tree ever created one.

**The rate is transcribed, not chosen.** Four hops in `SWG-Source/dsrc`, each read directly:

| hop | file | what it establishes |
|---|---|---|
| A | `object/tangible/item/som/blistmok_heart.tpf:9` | `scripts = +["quest.som.blistmok_heart"]` — the consume side only; nothing here creates the item |
| B | `datatables/loot/loot_items/mustafar/blistmok.tab` | 4 rows, row 4 is `object/tangible/item/som/blistmok_heart.iff` |
| C | `datatables/loot/loot_types/mustafar/mustafar_blistmok.tab` | exactly 2 pools: `mustafar/blistmok`, `mustafar/creature` |
| D | `datatables/mob/creatures.tab` col 44/45/46 | `intLootRolls=1`, `intRollPercent=100`, `lootTable=mustafar/mustafar_blistmok` |

`script/library/create.java:735-740` rolls `rand(1,99) < intRollPercent`; at 100 that always passes,
so exactly one item is made per kill. `script/library/loot.java:1155-1166` then picks one pool
uniformly (`rand(0, len-1)`) and one item from it uniformly. **No weights anywhere in that path.**
So `0.5 × 0.25 = 12.5% per kill`. Same shape for tulrus (`tulrus_parts`) and xandank (`xandank_jaw`).

Encoded in Core3 as `lootChance = 1250000` on the creature, a single group at `chance = 10000000`,
and a single item at `weight = 10000000`. `10000000 == 100%` is not an assumption —
`LootGroupCollectionEntry.h:42` computes a default of `2000000 + (level * 20000)` and comments it as
`20% + (0.2% * level)`.

**Applied to the three base species defs only.** Live explicitly routes the variants to loot types
that do not include these pools, so `blistmok_shrieker`, `blistmok_trampler`, `orf_tulrus`,
`orf_xandank`, `xandank_patriarch`, `xandank_onyx_plated` and `tulrus_magma_drenched` are
deliberately untouched, as are the named/quest creatures.

**Not included, and this is a real remainder:** the live companion drops — 5 ToW junk rows in
`mustafar/creature.tab` and the four `cube_loot` cubes per species. A faithful full pool would be 9
items at non-uniform weights. It is blocked on the cube path defect below and on mapping the ToW
junk static-item names to templates. Their absence is the status quo (these creatures dropped
nothing at all before), so nothing regressed — but the pool is narrower than live.

#### ~~⚠ NEW, unfixed~~: all 72 `cube_loot` server templates register under the wrong directory

> ⚠ **"NEW" IS WRONG — corrected 2026-09-01.** This was already found, explained and deliberately
> scoped out by an earlier round, in `jenha_tar_cube.lua:112-137`. I re-discovered this port's own
> record and wrote it up as a fresh finding. The paragraph below is otherwise accurate and the counts
> hold, but see item 10 in the closing section for what the earlier round established — in
> particular that the objects still resolve and **the cube quest is not broken**.

`object/custom_content/tangible/loot/mustafar/cube_loot/*.lua` — every one of the 72 `addTemplate`
calls registers under `object/tangible/loot/mustafar/cube/loot/<name>.iff`, with `cube/loot/` where
it should be `cube_loot/`. The shared client templates in the sibling `objects.lua` are correct
(`.../mustafar/cube_loot/shared_<name>.iff`), so it is the server path alone that is wrong.

    grep -c 'mustafar/cube/loot/' -> 72
    grep -c 'mustafar/cube_loot/' ->  0

No loot group references a cube, so no *drop* is affected. Three of them **are** referenced as quest
rewards — `som_jenha_tar_cube`'s Reward tasks 4, 5 and 6 grant `cube_loot_0a/0b/0c.iff` — and that
quest works, because `jenha_tar_cube.lua` addresses them by their registered path rather than the
`.qst`'s. Any *future* wiring that uses the live path will silently resolve nothing until this is
fixed. Left alone deliberately, by that earlier round's call and again here: 72 files, and the
one-line fix is in another port's file.

#### The loot lane mechanism — read this before writing any loot file

Three facts, all verified in C++, each of which fails **silently** if violated:

1. `LootGroupMap.cpp:63` — `includeFile` is `Lua::runFile("scripts/loot/" + filename)`. The loot
   lane root is **always `scripts/loot/`**, never relative-to-the-current-file. This is why
   `loot/serverobjects.lua` reaches the custom lane as `../custom_scripts/loot/serverobjects.lua`,
   and why files *inside* that custom lane must still climb out with `../`. It is the opposite
   convention from the object lane, which is rooted at `object/`.
2. `LootGroupMap.cpp:81-82` and `:97-98` — the template name must equal the file basename, or the
   server warns. `blistmok_heart.lua` must define `blistmok_heart`.
3. `LuaMobileTest.cpp:441` — `EXPECT_EQ(10000000, totalChance)`: within one `lootGroups` entry the
   `chance` values across `groups` must sum to exactly 10000000.

`custom_scripts/loot/serverobjects.lua` is the purpose-built custom lane and was **0 bytes** until
Round C; `loot/serverobjects.lua` includes it last, commented `-- Custom content - Loads last to
allow for overrides`.

**Positive runtime proof, not absence-of-error:** `[LootManager]` reported **659 → 662 Loot Groups**
and **2194 → 2197 Loot Items** across the before/after boots — exactly the three groups and three
items — with zero `does not match file name` warnings in either log.

Everything from here to the end of this section is the original finding, kept because it is the
evidence for *why* the retune was repair and not authoring. Its counts describe the shipped state,
not the current tree.

---

An earlier version of this heading said "135 of 160", which reads as though the other 25 drop
something. They did not. The directory holds 160 `.lua` files, two of which are not creature
templates at all (`serverobjects.lua` and the `surveyor_jo.lua` tombstone), leaving **158
templates — and as shipped, all 158 resolved to no loot.** They reached that state two ways:

    grep -rl 'group = "'      mobile/custom_content/som/   ->   0 files
    grep -rl 'groups = {}'    mobile/custom_content/som/   -> 135 files
    grep -rl 'lootGroups = {},' mobile/custom_content/som/ ->  23 files

135 + 23 = 158. The 135 carry `groups = {}` with a live `lootChance`, so the roll happens,
resolves no group and drops nothing; the other 23 have no `lootGroups` body to roll at all. Not
one som template names a single loot group anywhere in the tree — the first grep is the whole
proof, and it returns nothing.

The heading says "145 arrived that way" rather than "that is upstream", because 13 of the 158 are
files this branch adds and so cannot be attributed to upstream at all: `chief_armstrong`,
`chief_glost`, `engineer_cobar`, `foreman_donko`, `must_cruiser_ai`, `must_facility_ai`,
`som_kenobi_dying_miner`, the three `som_kenobi_moral_*`, `som_kenobi_obi_wan`,
`som_surveyor_keslev`, `urup_falco` — none exists in `origin/unstable`. Those 13 are this wave's
own, and they follow the wave's convention. The upstream claim covers the other **145**.

`origin/unstable` ships 140 in the `groups = {}` state. This branch has 135, and the net −5 is two
movements — neither of which changes what anything drops.

**Eight leave** the `groups = {}` string: the three treasure-hunter corpses, Epo Qetora, Menth Paul,
the computer technician, Ikt and the Pann protocol droid. They leave it by *representation*, not by
gaining loot. Each was rewritten from

    lootGroups = { { groups = {}, lootChance = 2100000 } }      -- origin/unstable
    lootGroups = {},                                            -- HEAD

and `grep -c 'group = "'` returns **0** on all eight at HEAD, exactly as at `origin/unstable`. An
earlier version of this paragraph said the eight left "because the quests actually need their
drops". The diff does not show that and it is withdrawn — all eight are conversation NPCs or
corpses whose quest items come from screenplay code, not from a loot roll.

**Three enter** it: `som_kenobi_moral_corrupt_guard`, `som_kenobi_moral_exec` and
`som_kenobi_moral_strike_leader`, all three new files this branch adds, so they follow the wave's
own convention rather than regressing anything. 140 − 8 + 3 = 135, and the no-loot total is 158
before and after.

The rest are Levarris's ambient population. This is a SoM-import
condition and not a Core3 convention: across all 9,172 files in `mobile/`, exactly **137** carry
`groups = {}` and **135 of them are som** — the only two outside it are `hutta/hutt_battle_droid.lua`
and `moraband/creatures/tukata.lua`.

**Why reproducing *retail* loot is authoring, even though the retune filled these tables.** The
two are different jobs, and only the second was done. The retune assigns loot groups that already
exist and are already registered in `loot/groups/` — `thug_tier_1`, `technician_tier_1`,
`dark_jedi_tier_5` and so on. Nothing was minted. Matching what the retail page actually lists is
the other job, and it remains upstream's; the worked example is below and its conclusion is
unchanged.

The retail Storm Lord page
(below) does list loot, for all five creatures: Credits, Mustafarian Junk, and the "glowing item"
family (Faintly Glowing Camera, Dimly Glowing Pair of Binoculars, Faintly Glowing Chance Die,
Faintly Glowing Powerpack, Dimly Glowing Recording Rod, Dimly Glowing Bone, Dimly Glowing Spool of
Wire), plus Robes of the Storm Caller and Caller of Storms on the boss. So here is one case where
the source names the drops exactly. It still cannot be wired, because **none of those items exist
in this repo**:

- no Mustafarian junk loot group — `loot/groups/` has no mustafar/mustafarian group at all; the
  generic `loot/groups/junk.lua:45` holds unrelated items
- no glowing-item family — every `glowing` hit in the tree is a collection rock, a TCG wearable or
  a particle effect; there is no Chance Die, no Powerpack and no Spool of Wire under any name
- no `storm_caller` / `caller_of_storms` anywhere in `MMOCoreORB/bin/scripts`

Wiring retail loot for even these five would mean minting a loot group plus nine item templates
that upstream never shipped. That is content authoring, and it is upstream's to do — which is the
same conclusion this section reached before, now with a case where the source data was in hand and
the answer did not change.

### Pet control devices — one of the two deaths is fixed, the other is not

7 devices ship under `object/custom_content/intangible/pet/som/` (blistmok, jundak,
kubaza_beetle, lava_flea, tanray, tulrus, xandank). As shipped, **all 158 som creature templates
carried `tamingChance = 0` and not one set `controlDeviceTemplate`** — the field every wired pet
uses (`mobile/corellia/bageraset.lua:31` is the pattern). SOE shipping a device for exactly those
seven families is a strong signal they were tameable; the taming chance itself is a number
nothing on disk records.

Correcting an earlier version of this section, which said "dead by data, not by search": they were
dead by BOTH. The load-chain walk below shows the directory holding the devices never runs, so the
device templates are not even registered. Either half alone is fatal; both were true.

**The creature half is now fixed.** The retune sets `tamingChance = 0.25` (the stock
plain-creature value, `mobile/corellia/bageraset.lua`) and the matching
`controlDeviceTemplate = "object/intangible/pet/som/<x>.iff"` on exactly those seven, and no
others:

    grep -rl controlDeviceTemplate  mobile/custom_content/som/
      blistmok.lua  jundak.lua  kubaza_beetle.lua  lava_flea.lua
      tanray.lua    tulrus.lua  xandank.lua

**The device half is now fixed too, and the gap was wider than first recorded.** An earlier
version of this paragraph said `object/custom_content/intangible/serverobjects.lua` never includes
`custom_content/intangible/pet/som/serverobjects.lua`. That is technically true but points at the
wrong seam: `custom_content/intangible/pet/serverobjects.lua` *already* includes the som file at
its line 2. The break is one level higher — `custom_content/intangible/serverobjects.lua` includes
only `vehicle/`, so the pet loader is never reached from anywhere in the tree. That strands every
custom_content pet control device, roughly 82 of them: ~45 at the top level, 30 under
`beast_master/`, and the 7 under `som/`. Their client halves are loaded
(`allobjects.lua:1128-1130`), which is exactly why the paths resolve and `createObject` still
returns nil.

This is the third instance of the loader gap documented in
`object/custom_content/serverobjects.lua`, after the Symbiosis sword and the Chu-Gon Dar cube, and
it is fixed the same way: a targeted `includeFile("custom_content/intangible/pet/som/serverobjects.lua")`
that switches on the 7 som devices only. The other ~75 are not this arc's to switch on and whether
they should be is upstream's call — the same reasoning the sword comment gives for not pulling the
whole weapon tree.

### The load chain — walked from the engine's own roots

The three `includeFile` bases and the three chain roots, read out of the C++ rather than assumed:

| what | base | root |
| --- | --- | --- |
| screenplays | `scripts/screenplays/` (`DirectorManager.cpp:1373`) | `screenplays/screenplays.lua` (`DirectorManager.cpp:928`) |
| mobiles | `scripts/mobile/` (`CreatureTemplateManager.cpp:188`) | `mobile/creatures.lua` (`CreatureTemplateManager.cpp:146`) |
| objects | `scripts/object/` (`TemplateManager.cpp:1025`) | `object/main.lua` (`TemplateManager.cpp:410`) |

Walking all three transitively reaches 866 + 9044 + 27081 files. **Every live Mustafar file is
reached** — the region screenplays, `mustafar_instances.lua`, `jedi_dog.lua`, the R7 radial
component, `mobile/custom_content/som/serverobjects.lua`, and the three direct includes at
`object/custom_content/serverobjects.lua:19`, `:30` and `:50`. Mustafar's own wiring is intact and
there are no unresolved include paths anywhere under it.

33 Mustafar/som `.lua` files were NOT reached when this walk was made. Every one is accounted for
below; 7 of them — the pet control devices — have since been switched on and are reached now, so
the current figure is 26.

- **2 are tombstones, correctly out.** `mobile/custom_content/som/surveyor_jo.lua` and
  `screenplays/mustafar/quest/conversation/jo_kelsev_conv_handler.lua` — both say MOVED in their
  own headers, both define nothing, both were deliberately dropped from their loaders when the NPC
  became Surveyor Keslev.
- **1 is loaded a different way.** `object/custom_content/mobile/som/shared_sansii.lua` — `shared_*`
  templates load on demand by iff name (`TemplateManager.cpp:1037`), never through the chain.
- **20 are the weapon and structure components**, 7 are the pet control devices. Their own
  directory loaders are correct; what is missing is one include line in each parent —
  `custom_content/tangible/serverobjects.lua` never names `component/`, and
  `custom_content/intangible/serverobjects.lua` never names `pet/`.

**The 20 components stay out. The 7 pet devices are now in — that half of this ruling is
reversed.** The original reasoning held that nothing could reach either set, and for the devices
the stated reason was that no som creature was tameable. The retune changed that fact: seven
creatures now carry `tamingChance = 0.25` and a `controlDeviceTemplate`, so the devices are
reachable and a tame would hit `createObject` on an unregistered template. They are switched on by
a targeted `includeFile("custom_content/intangible/pet/som/serverobjects.lua")` at
`object/custom_content/serverobjects.lua` — 7 templates, not the ~82 that adding `pet/` to
`custom_content/intangible/serverobjects.lua` would have registered.

For the 20 components nothing changed and they stay out: a search for all 20 component names
across `loot/`, `screenplays/`, and both `draft_schematic/` trees still returns zero hits. Adding
`component/` would register 355 templates to serve 20 that nothing can reach, which is precisely
the trade the comment at `object/custom_content/serverobjects.lua:12-18` rules against for the
Symbiosis sword. The convention there is to pull in the one file an arc needs — which is also
exactly what was done for the devices.

For scale, and so this is not mistaken for a Mustafar defect: the same shape covers **192
orphaned `serverobjects.lua` trees holding 12,767 files** across all of `custom_content` —
`custom_content/weapon` (351), `custom_content/ship` (316), `draft_schematic/weapon` (468) and so
on, almost none of them duplicated by a reachable file. That is a Stardust-wide loader condition,
not Mustafar's, and it is Levarris's call whether it is intentional. Mustafar's 27 are 0.2% of it.

### The final cross-reference — every string Mustafar hands the engine

The check: take every `spawnMobile`, `spawnSceneObject`, `createObject`, `giveItem`,
`conversationTemplate`, `primaryWeapon` / `secondaryWeapon` and `lootGroups` string in the live
Mustafar tree, and look each one up in a registration set built from the load-chain walk above —
so a template that exists on disk but never loads counts as missing, which is the whole point.

Two corrections had to be made to the checker before its output could be trusted:

- **It did not strip Lua comments.** That produced 4 false hits on
  `object/tangible/terminal/terminal_elysium_crystal_01.iff` at line 21 of all four region
  screenplays. Every one is commented out, identical, and passes zone `"yavin4"` — copy-paste
  boilerplate from an Elysium region stub, never a live call. Of 17 commented-out lines in the
  tree matching a spawn verb, 13 are prose explaining the API and 4 are that stub. No real
  content is commented out anywhere under Mustafar.
- **It walked only three of the chain roots**, so `loot/` was unreachable and the loot-group
  check silently compared against an empty set. `LootGroupMap.cpp:56-66` registers its own
  `includeFile` base of `scripts/loot/` and roots at `loot/lootgroup.lua` + `loot/serverobjects.lua`
  (`:38-39`); `CreatureTemplateManager.cpp:107` adds `managers/creature_manager.lua` under the
  `scripts/mobile/` base. With all six roots the set is 659 loot groups and the check runs for real.

Result over 807 live Mustafar/som files, against 6,066 creatures · 24,578 objects · 374
conversations · 659 loot groups · 124 weapon groups:

```
CONVERSATIONTEMPLATE -> UNREGISTERED CONVERSATION  (1)
   mobile\custom_content\som\obi_wan_ghost.lua:32  obi_wan_elysium
```

That one is pre-existing in `origin/unstable` at the same line and is inside the fence. Nothing
else in the tree names a creature, object, conversation, weapon group or loot group that does not
register. `screenplays.lua` names 69 Mustafar files, all 69 resolve, and the only `.lua` under
`screenplays/mustafar/` it does not name is the documented `jo_kelsev_conv_handler.lua` tombstone.

Syntax gate after the weapon revert, `luac5.3 -p` over
`mobile/custom_content/som` + `screenplays/mustafar`: **ok=230 fail=0**.

### The Storm Lord table — a real retail source, found late, and what it settled

⚠ **CORRECTING AN EARLIER CALL OF MINE.** An earlier pass looked at
`C:\swg-extract\Prophet_of_the_Storm_Lord.wiki`, found a Cloudflare "Just a moment..."
challenge page, and concluded the `.wiki` files there were worthless. **That generalised from one
file and was wrong.** 20 of the 27 are real; only 7 are challenge pages. The 7 happen to include
the individual creature pages, which is what made the sample misleading.

`Storm_Lord.wiki` is real and it is a datatable in prose:

| creature | Natural CL | Difficulty | Combat | Location | Respawn |
| --- | --- | --- | --- | --- | --- |
| Storm Lord Minion | 80 | Normal | Ranged weapons | — | — |
| Storm Lord Guard | 82 | Normal | Melee weapons | — | — |
| Storm Lord Zealot | 83 | Normal | Melee weapons | — | — |
| Prophet of the Storm Lord | 87 | Elite | Lightsaber | `3195, 770` | — |
| The Storm Lord | 90 | Boss | Lightsaber | `3069, 1131` | 10 minutes |

**It self-verifies against the transform.** Run the Prophet's listed `/way` through
`world_x = way_x - 2880`, `world_y = way_y + 2976` from the section above:
`3195 - 2880 = 315` and `770 + 2976 = 3746`. The repo spawns him at
`storm_lord_region.lua:151` as `spawnMobile("mustafar", "storm_lord_prophet", 1200, 315, ..., 3746, 0, 0)`
— **exact, to the metre, on both axes.** That is a new independent anchor for the transform, and it
identifies this page as the source an earlier round already used without naming it. (The Storm
Lord's own listing converts to `189, 4107` against a spawn at `194.4, 4096.3` — 12 m, inside the
precision a prose location page offers. Left alone.)

⚠ **THE LEVEL COLUMN OF THAT TABLE IS NGE, AND IT NO LONGER APPLIES.** An earlier round took
80 / 82 / 83 / 87 / 90 straight off this page and wrote them into the six Storm Lord templates.
Aaron ruled against it: *"ensure you are aligned with stardust combat and levels rather than
nge swg."* "Natural CL" is an NGE combat-level column. This is a Pre-CU server whose own
Mustafar content states its intended band, in shipped code, in six places:

| gate | file:line | value |
| --- | --- | --- |
| `requiredLevel` | `mensix/conversation/pei_yi_conv_handler.lua:37` | 46 |
| `requiredLevel` | `quest/collectors_business.lua:139`, `quest/cursed_shard.lua:181`, `quest/moral_choice.lua:171` | 61 |
| `minimumLevel` | `quest/map_exploration.lua:98`, `quest/som_poison_miners.lua:276` | 70 |
| `requiredLevel` | `quest/historian.lua:299`, `quest/samaritan.lua:189` | 75 |
| storyArcChapters `requiredLevel` | `quest/conversation/milo_conv_handler.lua:59` | 80 |

Those gates are the design speaking for itself, and they say Mustafar is a 45–105 planet.
The server's own level histogram agrees — the real clusters under `mobile/` are 4, 30, 45, 50,
70, 85, 100, 105, 300. So the whole pack is now tiered on **this server's** ladder, not the
NGE one: CIV 45 / FAUNA_L 50 / STD 70 / ELITE 85 / NAMED 100 / BOSS 120 / APEX 140 / RAID 200,
with every stat block copied verbatim from a stock creature at that level rather than derived.
The Storm Lord lands at 140 (APEX), the Prophet at 120 (BOSS), and the touched / zealot /
guard / minion at 85 / 85 / 100 / 70. The retail table survives as evidence for *ordering* and
for the Prophet's coordinates, which is what it is actually good for.

The Storm Lord's respawn stays at the `1200 → 600` this page justified
(`storm_lord_region.lua:127`); a spawn timer is not a combat level and is not affected.

⚠ **CORRECTING A FALSE CLAIM THIS DOCUMENT MADE.** The line that stood here read: *"No
registered weapon group anywhere on this server contains a lightsaber."* **That is wrong**, and
it was used to justify leaving lightsabers off the Storm Lord and the Prophet. Ten groups that
`mobile/weapon/serverobjects.lua` **does** load carry lightsabers:

```
dark_jedi_weapons_gen2         dark_jedi_weapons_gen3_ranged   light_jedi_weapons
dark_jedi_weapons_gen2_ranged  dark_jedi_weapons_gen4          light_jedi_weapons_ranged
dark_jedi_weapons_gen3         dark_jedi_weapons_ranged        darth_vader_weapons
                                                               luke_skywalker_weapons
```

`mobile/weapon/groups/dark_jedi_weapons_gen4.lua:1-5` is three `crafted_saber` `.iff`s and
nothing else. The true, narrower fact is the one the sentence over-generalised from: `jedi_dark`
and `jedi_light` specifically are not in `serverobjects.lua`. Those two being absent says
nothing about the other ten, and `mobile/thug/dark_jedi_master.lua:42-49` is the shipped
house pattern for a saber-carrying NPC — `dark_jedi_weapons_gen4` primary,
`dark_jedi_weapons_ranged` secondary, `merge(lightsabermaster,forcepowermaster)`.

**Weapons are now changed.** Every one of the six Storm Lord templates shipped
`primaryWeapon = "pirate_weapons_light"` — a blaster pistol and four melee weapons — which is
what the retail categories were being measured against. The assignments follow this server's
own registered groups:

| creature | tier | primaryWeapon | attacks |
| --- | --- | --- | --- |
| minion | STD 70 | `pirate_weapons_light` | `merge(marksmanmaster,pistoleermaster)` |
| touched / zealot | ELITE 85 | `melee_weapons` | `merge(brawlermaster,swordsmanmaster,forcewielder)` |
| guard | NAMED 100 | `melee_weapons` | `merge(brawlermaster,swordsmanmaster,forcewielder)` |
| prophet | BOSS 120 | `melee_weapons` | `merge(brawlermaster,swordsmanmaster,forcepowermaster)` |
| storm lord | APEX 140 | `melee_weapons` | `merge(brawlermaster,swordsmanmaster,forcepowermaster)` |

Sabers stay off this family on purpose, and now for a real reason rather than the false one:
nothing in SoM's own data shows a Storm Lord cultist holding one, and
`mobile/weapon/groups/pirate_weapons_light.lua:9-13` states the repo's rule that a group
assignment needs a source that *shows the weapon*. `forcewielder` and `forcepowermaster` give
the family its force-user character without inventing a saber the source does not show.
`creatureskills.lua:57` describes `forcewielder` as exactly this: *"npc force wielders use
standard profession mastery with the addition of this command."*

⚠ **A SECOND FALSE CLAIM, CORRECTED.** An earlier commit message called the Prophet
`prophet_of_the_storm_lord`. **No such template exists** — `grep -rn prophet_of_the_storm_lord .`
returns nothing. The registered name is `storm_lord_prophet`, and the family is **six**
creatures, not five: this document's own table above omits `storm_lord_touched`, which is a
separate registered template spawned ten times at `storm_lord_region.lua:105-123`. Both it and
`storm_lord_zealot` shipped the same `customName`, "a storm lord zealot"; `storm_lord_touched`
is now "a storm-touched acolyte". Its `templates` entry pointing at `storm_lord_touched.iff`
while `storm_lord_zealot.lua:29` points at the same file is **correct and must stay** — there
is no `storm_lord_zealot.iff` in `object/custom_content/mobile/som/`, only five object
templates for the six creatures.

### The one remaining TODO in the tree, and why it stays

`regions/storm_lord_region.lua:77` reads:

```lua
-- Skar tower   -- TODO add suitable NPC for Skar -  Closest appearance would be blackguard wilder.
```

The tower is not empty — `pMinion9` through `pMinion13` spawn there at `:78-88`. The TODO asks
for a *named* NPC called Skar. **SoM never shipped one.** A byte-exact search for `skar` in
ASCII, UTF-16LE and UTF-16BE across all 516 files of `C:\swg-extract\_som` returns **0
occurrences**, against controls of `sher_kar` in 9 files, `blackguard` in 8 and `storm_lord`
in 7 — so the search works and the absence is real. No creature template, no string table
entry, no `.qst` names Skar.

Note the method: `grep -c -ia skar` on `creature_names.stf` reports a match, but `grep -o`
prints nothing and a byte scan finds none in any encoding. That is a grep binary-mode artifact.
The counts above are from the byte scan, not from grep.

The comment's own suggestion — "closest appearance would be blackguard wilder" — is the author
guessing at an appearance, not citing a source. Naming and statting a boss the source data does
not contain is authoring, so the TODO stays where it is, unclosed and now explained.

### The Mensix page — a retail position list, and the strongest check in this audit

`C:\swg-extract\Mensix_Mining_Facility.wiki` is the second real page found in that folder, and it
is more useful than the Storm Lord one, because it is a *list of positions*. It gives in-game
`/way` coordinates for 16 quest NPCs, 3 other NPCs and 8 items of interest inside the facility —
27 objects.

One caveat on how much weight this carries, stated plainly because the repo cannot settle it. The
page was read *after* these placements were made, and the placements were derived from the
facility's dungeon spawn table and the snapshot — that is my record of the sequence, not something
a reader can verify from the tree. A provenance claim of that shape is unfalsifiable from the repo
alone, so it should not be leaned on. What *is* checkable, by anyone, is the agreement below: two
sources produced by different means, at different times, land on the same positions.

Run each `/way` through the Mensix cell-local transform already established above
(`local_x = way_x − 459.50`, `local_y = way_y + 1208.92`) and compare to the repo's spawn:

| retail object | repo | file:line | delta |
| --- | --- | --- | --- |
| Q4P3 | `som_pann_protocol_droid` | `collectors_business.lua:220` | 0.31 m |
| Urup Fal'co | `urup_falco` | `mensix_mining_facility_main.lua:134` | 0.38 m |
| Blistmok Skin Rug | `blistmok_rug.iff` | `trophy_hunts.lua:318` | 0.38 m |
| Milo Mensix | `must_milo_mensix` | `story_arc_chapters.lua:1186` | 0.42 m |
| Pei Yi | `pei_yi` | `mensix_mining_facility_main.lua:130` | 0.60 m |
| Master Pilot Menddle | `miner_pilot` | `story_arc_chapters.lua:755` | 0.63 m |
| Mining Network Terminal | `som_kenobi_network_computer.iff` | `moral_choice.lua:196` | 0.64 m |
| Ithes Olok | `npc_ithes_olok` | `jenha_tar_cube.lua:325` | 0.80 m |
| Ikt | `som_mustafarian_ikt` | `serpent_shard.lua:210` | 0.82 m |
| Menth Paul | `som_kenobi_menth_paul` | `cursed_shard.lua:272` | 0.89 m |
| Surveyor Jo Keslev | `som_surveyor_keslev` | `mining_field_markers.lua:469` | 0.90 m |
| Foreman Donko Jen | `foreman_donko` | `mensix_mining_facility_main.lua:133` | 0.92 m |
| Vat of Bleach | `bleach_vat.iff` | `trophy_hunts.lua:304` | 0.93 m |
| Chief Ulon Glost | `chief_glost` | `mensix_mining_facility_main.lua:136` | 1.05 m |
| Foreman Chivos | `must_foreman_chivos` | `story_arc_prelude.lua:417` | 1.49 m |
| A Bleached Jundak Skull | `jundak_skull.iff` | `trophy_hunts.lua:311` | 1.6 m |
| Epo Qetora | `som_kenobi_epo_qetora` | `historian.lua:466` | 1.72 m |
| Diskret Stahn | `diskret_stahn` | `mensix_mining_facility_main.lua:131` | 2.04 m |
| Chief Armstrong | `chief_armstrong` | `mensix_mining_facility_main.lua:135` | 2.4 m |
| Pwwoz Pwwa | `som_pwwoz_pwwa` | `samaritan.lua:275` | 3.02 m |
| Mensix Corp. Merchant | `must_junk` | `mensix_mining_facility_main.lua:108` | confirmed |

**Now 25 of 27 confirmed. Zero mismatches. Worst delta 3.02 m, median under 1 m** — which is
inside the error of a player standing next to an NPC and reading their own coordinates off the
map. Menddle's height checks too: cell-local `z = 31.5` on a facility floor of 199.40 gives 230.9
against the page's 230.

⚠ It read **21 of 27** when this section was written, and the four-prop bullet below explained
the shortfall wrongly. Both are corrected here. The four props are now placed
(`mensix_mining_facility_main.lua`, commit `8c2c93a99a`), from `som_mining_facility.tab` — not
from this page — and each lands on its `/way`:

| retail object | repo | tab row | delta |
| --- | --- | --- | --- |
| Bounty Document: Lava Flea | `lava_flea_bounty.iff` | row 28 | 0.49 m |
| Kubaza Beetle Beads | `lava_beetle_beads.iff` | row 16 | 0.59 m |
| Medical Hologram | `jundak_hunter_hologram.iff` | row 23 | 0.84 m |
| Plate of Tanray Meat | `lava_lizard_food.iff` | row 29 | 0.94 m |

That last row is the one worth keeping. Nothing in the filename `lava_lizard_food.iff` says
"Plate of Tanray Meat" — the only reason we know which object the page means is that the tanray
`/way` lands on it. Four independent agreements under a metre, from a shipped datatable and
players in the room years later.

The two still not confirmed are absences, and neither is a placement error:

- **Mining Corporation Executive** (`/way 307 -1222`) and **Uggo** (`/way 383 -1168`) are not
  modelled. Neither appears in the page's own quest list — they are ambient. The nearest thing
  the repo puts at each spot is 4.3 m away in both cases (Urup Fal'co in Milo's office; a generic
  `mustafarian_miner_01` in the cantina).

**Why the four-prop bullet was wrong, since the mistake is the reusable part.** It read:

> **Bounty Document: Lava Flea**, **Kubaza Beetle Beads**, **Medical Hologram** and **Plate of
> Tanray Meat** are not placed as props. Their quests *are* modelled — `bounty_hunts.lua` runs
> all seven — and `bounty_hunts.lua:99-107` already records why: these are "live server-side
> static item names, not object templates", so there is nothing to spawn.

`bounty_hunts.lua:99-107` says nothing about these four props. It is about the **loot legs** of
two hunts — the drop items "Jagged Jundak Tooth" and "Kubaza Beetle Bead" (singular; the item a
corpse yields), not "Kubaza Beetle Beads" the object on the floor. Two different things with
almost the same name, and the citation crossed them. The source file was right and stayed right;
it even says `lava_beetle_beads.iff` "does exist and is registered … if real beads are wanted
later". This document misread it into a reason not to place anything, and the real reason nothing
was placed was simpler: nobody had read rows 16/23/28/29 out of the table yet.

**These are props, not quest starters.** The `script` column is empty on all four rows, so the
shipped data attaches no behaviour to clicking them. `grantHunt` is still uncalled and the bounty
arc still has no giver — that is unchanged and remains Aaron's call. See "Bounty hunts — all
seven mapped, no NPC giver by design".

This section corrected two errors made while producing it, both worth recording because both were
the same kind. A subagent reported all 8 items "NOT SPAWNED" and Menddle "NOT SPAWNED"; direct
greps found 4 of the 8 placed and Menddle placed to 0.63 m. It had searched for the retail *display
names* rather than the repo's template names (`miner_pilot` carries `customName = "Master Pilot
Menddle"`). **The primary read caught it; the summary would not have.**

### `som_mining_facility.tab` — now fully reconciled: 49 rows, 49 accounted for

The four props above were part of a larger gap. The facility's *quest* NPCs had been placed from
`datatables/spawning/dungeon/som_mining_facility.tab` long ago, so the table was always trusted —
but sixteen of its rows had never been read out of it. Not ruled out, just missed. Placed
2026-08-31 in `mensix_mining_facility_main.lua` (commit `8c2c93a99a`, plus row 47 after the
reconciliation below):

- **5 props** via `spawnSceneObject` — the four above, plus row 22 `cloning_tube` in
  `small_room_01`.
- **8 background miners** via `spawnMobile` — rows 44/45/46 (`hall_08`), 47 (`hub_room`),
  52 (`hall_04`), 53 (`hall_03`), 68/71 (`medium_room_01`).
- **2 mining droids** — rows 62/63, `small_room_03`.
- **1 `clone_droid`** — row 79, `small_room_01`, beside the cloning tube from row 22.

**The whole table was then reconciled, and that is what makes this closed rather than improved.**
Every one of the 49 non-`npe_node` rows was matched against every coordinate this tree declares
inside a Mensix cell — both literal `spawnMobile`/`spawnSceneObject` calls and the data-table
declaration form `trophy_hunts.lua` and `story_arc_chapters.lua` use. **47 of 49 matched within
3 m.** The two that did not:

- **Row 47**, `som_mustafarian_miner_a` in `hub_room` at (-94, 14.9, 3) — a **real gap**, and the
  first pass here missed it. Rows 44/45/46 are the `hall_08` group and row 47 is the next line in
  the file; the pass walked the block and moved on. Now placed. Note what did *not* catch it: the
  boot counter read "15 of 15" because 15 was what the file asked for. **A counter proves the
  placements ran; it does not prove the table was finished.** Only the reconciliation could.
- **Row 78**, `communication_console` in `conference_room` — **not a gap**. It is spawned at
  `story_arc_chapters.lua:1206` at exactly the table's coordinates. The reconciler missed it
  because the field is named `miloTerminalTemplate`, not `template`. A tool artifact, checked by
  direct read before it was believed.

**A useful thing fell out of the sweep: the `script` column is not empty everywhere.** Every one
of the twelve miner rows carries one — `joker_one/two/three` in `hall_08`, `patrol1/2` in the
corridors, `cantina1/2` and `patron1/2` in the bar, `working_miner1` in `hub_room`. They are
`content_tools` sequencer entries, and Core3 has no sequencer, so the behaviour cannot be ported;
a mood string is the nearest this engine has and is used as a disclosed approximation. **This
also strengthens the prop argument above.** The four bounty props' `script` column is empty — and
now we know that column is *populated where SOE attached behaviour*, so its emptiness on those
rows is a real signal rather than an unused column.

**Boot-proven, not gate-proven.** `spawnSceneObject` and `spawnMobile` both return `nil` on failure
and print nothing — an unregistered server template, a wrong cell id or a typo'd creature name all
fail *silently*. This tree has been bitten by that exact silence three times (the Symbiosis sword,
the Chu-Gon Dar cube, the som pet control devices — all unregistered server templates whose client
halves resolved fine). So every placement here goes through a `:placed()` helper that logs a FAILED
line naming the row, and `start()` prints the tally, following
`mustafar_dungeon_population.lua:456`. Boot log:

    MensixMiningFacility: 16 of 16 som_mining_facility.tab rows placed

Zero FAILED lines. That is positive proof of placement, which "no errors in the log" is not — but
see the row 47 miss below for what it still does not prove.

**One substitution, disclosed.** The table asks for `som_mining_droid_fork` and
`som_mining_droid_claw`. Neither exists as a template here or anywhere in the extract. Live has
three variants (`ground_spawning/types/mustafar/mining_droids.tab`: bucket, claw, fork) and this
repo ships three marks (`must_mining_droid_mark_01/02/03`) — three for three, but the two schemes
describe different things, an attachment versus a model generation, and nothing supplies a mapping.
So the **placement is sourced verbatim** and **which mark is ours**, by a stated alphabetical rule
rather than an undocumented coin toss. Same trade `mustafar_dungeon_population.lua` makes out loud
for seventeen other names.

**The 30 `npe_node.iff` rows are deliberately NOT placed**, recorded here so it is not re-derived
as a gap. They are NPE anchor markers, each sitting on a creature row to the centimetre (rows 47
and 48 are the same point). Core3 has no NPE node consumer, so 30 invisible objects would add
nothing visible and nothing any code reads.

### The other three dungeon tables — the same miss, found by the same reconciliation

The Mensix sweep above was run on one table. Run on the other four, it found the same class of
gap in the three instanced ones: `mustafar_dungeon_population.lua` read only the **creature** rows
and never the rest. The dungeons were geometry with monsters in them and no fittings at all.
Placed 2026-08-31, commit `fdd0c9e972`:

    old_republic_facility    21 rows x 12 copies  =  252
    decrepit_droid_factory   10 rows x  9 copies  =   90
    working_droid_factory     2 rows x 12 copies  =   24
                                                    ----
                                                     366

33 distinct objects, transcribed straight across — template, cell, x, z, y, yaw. Nothing invented
and nothing substituted: unlike the creature rows, `row[1]` here is already a full template path,
so there is no substitutes lookup and no naming judgement to make.

**One real code difference, and it is the kind that is silently wrong if missed.** `spawnMobile`
takes heading in DEGREES and the cell id LAST; `spawnSceneObject` takes RADIANS and the cell id
BEFORE the heading. Both conventions now live in that one file, so `spawnProp` does the `math.rad`
conversion in a single place and the tables stay in the table's own units.

**How the row set was decided**, because "place the rest" would have doubled things. The three
tables hold 34 non-creature non-waypoint rows, and each was read before it was placed or skipped:

- **33 placed.**
- **1 not placeable** — ORF line 23, `avatar_platform/avatar_lockbox.iff`. No server template
  exists for it anywhere in this tree, so `spawnSceneObject` would return `nil`. A genuine missing
  asset, not a decision.
- **8 further rows are placed by other files** and are deliberately absent, each named in the
  props table that would otherwise carry it: `story_arc_chapters.lua:1071/1101/1116/1117` owns
  Delta Five, the `system_controller`, the `master_power_core` and the `security_controller` in
  every copy; `mustafar_instances.lua:374-408` owns the interior door and the exit terminal
  because they are the instance's own entrance furniture; `historian.lua:329` and
  `reunite_shard.lua:274` own the two Kenobi quest objects.
- **ORF line 17 is the subtle one.** `terminal_bank_floor_on_01` in `smallroom12` is NOT placed,
  because `story_arc_chapters.lua:533` already puts its power terminal on exactly those
  coordinates and its own comment says it is borrowing live's spot while wearing
  `must_control_computer`. Placing the live template too would stack two objects on one point.

**The 59 `patrol_waypoint` rows stay unplaced**, same call as the 30 `npe_node` rows above and
recorded for the same reason. They are invisible pathing markers for live's sequencer, which Core3
does not have. Spawning them would not make the paths walked; it would put 59 invisible objects in
every copy.

**Boot proof, and it is worth more than the count.** Every cell name resolved in every copy —
`resolveCell` returning 0 prints the missing cell *by name*, and the log has no such line. Sixteen
of these cell names had never been exercised by any row in this file before: `hall2`, `hall16`,
`hall26`, `hall29`, `hall30`, `hall11`, `hall19`, `hall32`, `hall33`, `mediumroom13`,
`mediumroom28`, `smallroom22`, `smallroom23`, `smallroom26`, `smallroom34` and `entrance`. They
are read off the live tables with **no `.ilf` and no `.pob` in this tree to check them against**,
so the boot IS the check. Gate `ok=264 fail=0` / `ok=14022 fail=0`; boot READY in 40s:

    MustafarDungeonPopulation: 921 creatures placed across the Mustafar dungeon pools,
                               plus 12 lair bosses
    MustafarDungeonPopulation: 366 non-creature objects placed from the same tables
    MensixMiningFacility: 16 of 16 som_mining_facility.tab rows placed

Zero `failed to place`, zero `no cell named`, zero `failed to spawn`. 202 ERROR lines, unchanged
from the previous boot and all off-planet (corellia 48 / naboo 14 snapshot failures); **0 touching
mustafar, som or mensix.**

**The five dungeon tables are now fully reconciled.** With this and the Mensix pass above, every
content row of all five `som_*.tab` files is either placed or has a written reason not to be.

### ⚠ A census scope hole this found: 53 dungeon-interior templates were never in the count

The "127 non-creature objects" count above was scoped by `som_*` / `must_*` filename prefix —
which is the exact mistake this document opens by warning against. The dungeon interior objects
are named `core_room_terminal.lua`, `access_controller.lua`, `workstation.lua`; no prefix, so none
of them were ever counted. There are **53** of them, under
`object/custom_content/tangible/dungeon/mustafar/`. Checked by iff path across all of `scripts/`,
after the commit above: **10 referenced, 43 not.** Eight of the 43 are `objects.iff` directory
manifests, not objects. That leaves **35 real templates that nothing places**, and the buckets say
why this is smaller than it looks:

| bucket | n | what it is |
| --- | --- | --- |
| `valley_battlefield` | 20 | the GCW valley battlefield — turrets, demo charges, bunkers, fences |
| `obiwan_finale` | 5 | the final chamber, already an open item below |
| `working_droid_factory` | 4 | `inhibitor_storage`, `radioactive_pile`, `rapid_assembly_station`, `reactive_repair_module` |
| `uplink_trial` | 3 | `beetle_lair`, `exit_door`, `relay_object` |
| `volcano_battlefield` | 1 | `launch_mechanism` |
| `decrepit_droid_factory` | 1 | `workstation` |
| `old_republic_facility` | 1 | `terminal_delta_five` |

**Nine of these were checked against the tables and none has a row.** `workstation`,
`inhibitor_storage`, `radioactive_pile`, `rapid_assembly_station`, `reactive_repair_module`,
`beetle_lair`, `exit_door`, `relay_object` and `launch_mechanism` appear in **no row of any of the
23 tables in `spawning/dungeon/`**. So the prop batch above is complete with respect to the
tables; these are art with no table-side placement source, which is a different question and needs
a different source to answer.

**`terminal_delta_five` is not a gap at all** and is the clearest case of why the count misleads.
Live's own ORF table names `terminal_bank_floor_on_02.iff` for Delta Five, and
`story_arc_chapters.lua:516-524` places that verbatim with the row cited. The custom
`terminal_delta_five.iff` is client art the live table does not use. Placing it would be *less*
faithful, not more.

The remaining 26 — valley battlefield, volcano battlefield, uplink trial, obiwan finale — are
whole content systems this port does not implement, not loose props. **Recorded, not counted as
closed.** Nothing here was placed on the strength of this section.

### XP — no *quest reward* pays any, and the wiki's figures match nothing in the shipped data

The two quest walkthroughs give hard XP numbers: Miner Madness 91,383 and Skull of the Jundak
78,265. The repo awards neither. **Where those two figures came from is unresolved, and this
section does not close it.**

An earlier version of this section claimed the wiki numbers "corroborate that the `[list]` field
was live" and cited `bounty_hunts.lua:111-116` for the rule. The gate refuted both halves and it
is withdrawn. `bounty_hunts.lua` covers the seven *bounty* quests; Miner Madness is
`som_poison_miners.lua` and Skull of the Jundak is `trophy_hunts.lua`, and those two record zero
in *both* places, not a non-zero `[list]`:

    som_poison_miners.lua:40   Bank Credits 0, Experience Amount 0
    som_poison_miners.lua:46   Experience Type quest_combat with Experience Amount 0, Bank Credits 0.
    trophy_hunts.lua:277         * Bank Credits 0 and Experience Amount 0 are honoured literally

(Those three are verbatim; :40 is the task 8 Reward line and :46 is the `[list]` line, and
`trophy_hunts.lua:277` continues "…: no credits and no XP are granted, because that is what the
`.qst` says.")

Grepping `Experience Amount` across the whole of `screenplays/mustafar/` settles the shape of it.
Every recorded value in the tree is **0** — on Reward tasks and in `[list]` blocks alike, across
the 22 files that record one — with exactly one exception: `bounty_hunts.lua:113`, where the seven bounties'
`[list]` carries `Experience Amount 1000 / quest_combat`. One non-zero figure in the entire
Mustafar quest set, and it is 1000, which is not 91,383 either.

So the honest reading is narrower than the one it replaces:

- **Why no quest *reward* pays XP** — because every `Experience Amount` in the shipped data those
  rewards are built from is 0. That part needs no external fact and is not in doubt. It is a
  statement about the quest-reward path only; see the last paragraph for the one award this tree
  does make outside it.
- **The single exception** — the bounties' `[list] 1000` is journal-level data the quest system
  awards, and this build has no quest-system row for it: `datatables/player/quests.iff` as loaded
  resolves to `stardust_03.tre`'s copy, whose only Mustafar rows are the 45 exploration markers.
  That is a property of the server's mounted `.tre` set, which the fences forbid editing and which
  can change without this tree changing — so it is a dependency, not a proof.
- **The 91,383 and the 78,265** — these are in the shipped `.qst` data nowhere, in either field,
  for either quest. They may be a player's measured session gain, a different publish's values, or
  a wiki error. This audit cannot tell which, and guesses nothing. **OPEN.**

Nothing is changed on the strength of it. Inventing an `awardExperience` call to hit a number the
loaded data does not carry would be authoring a reward, not restoring one.

**The tree does award XP in exactly one place, and it is not a quest reward.**
`mining_field_markers.lua:607` calls
`CreatureObject(pPlayer):awardExperience("combat_general", self.areaXpReward, true)` with
`areaXpReward = 290` (`:124`), per surveyed area. That is a screenplay award on a survey action,
not a `.qst` Reward task and not journal-level, so it sits outside everything above rather than
contradicting it. An earlier heading here read "the tree pays none", which this line falsifies;
the claim is now scoped to quest rewards.

### The Kenobi finale — retail says what was in the room, still not where

Publish 28's notes (26 April 2006) say, verbatim:

> Trials of Obi-Wan: The Cursed Shard: The Dark Jedi at the end of the Kenobi trials can be killed
> only once. If you kill him, make sure to finish the quest by destroying or taking the crystal
> because once the Dark Jedi is dead, you can't go back into the lair.

`kenobi_spine.lua:213-216` calls the two unplaced tangibles "an open question about what SOE meant
the finale room to contain". This note answers **that** question — the room held a crystal the
player destroys or takes — and it is the first source of any kind to say so. It still gives no
coordinate, and the search behind that passage stands, stated at the width the search actually
supports: `som_kenobi_final_crystal_pedestal` and `som_kenobi_final_force_crystal` have no *live*
reference anywhere in `MMOCoreORB/bin/scripts` — no screenplay code, no loot table, no dungeon
table, Mustafar's five included. Every hit on either name is one of three kinds: the object
declaration, the `serverobjects.lua` include that registers it, and the comment at
`kenobi_spine.lua:211` that raises the question in the first place. (An earlier version said "no
`.qst`, no screenplay, no loot table and no dungeon table"; that phrasing is falsified by its own
comment, and the `.qst` half was never searched here at all.) So the item narrows but does not
close: **we now know what, and still not where.** Nothing is placed on the strength of it.

Two things the note does *not* argue for changing:

- The repo already sends the narrative the note describes —
  `kenobi_spine.lua:1635` "The way into the chamber is open. Destroy the crystal, and whatever came
  for it." and `:1660` "Sinistro is dead and the Soul Crystal is destroyed." The crystal's
  destruction is told, not simulated, and that matches a room with nothing sourced to put in it.
- "Killed only once … can't go back into the lair" is a live-era *constraint SOE warned players
  about*, not a target to reproduce. The repo gives each player their own instance copy with the
  boss on a 600 s respawn, and `kenobi_spine.lua:466-470` states why: `start()` runs once per
  server lifetime, so without a timer the first kill empties that copy for good and `findFreeCopy`
  hands the cleared copy to the next player, who then has nothing to kill and no route to
  `STAGE_DONE`. Copying the retail behaviour here would strand players; the deviation is
  deliberate and reasoned.

### ⚠ Open decision — the Ancient Jundak's level — CLOSED BY THE SWEEP, NEEDS A RULING

**Read this before trusting the section below.** This was written as an open design call that was
Levarris's to make. The retune then made it, as a side effect of a tier sweep rather than as a
decision anyone took: `jundak_devourer` was assigned the ELITE tier and is now `level = 85`
(`jundak_devourer.lua:6`). The consequence the section warned about is now live in the tree —
`jundak` and `orf_jundak` are still `level = 70`, so the "hunt 15 jundak" bounty now has a 70/70/85
spread across its three interchangeable targets.

85 is not a considered answer to the question below; it is where the ELITE tier lands. It happens
to sit one level off the retail CL 84, which is the argument *for* keeping it. The argument against
is unchanged and is the whole reason this was left open. **Either outcome is defensible and neither
has been chosen — the options are: keep 85, revert `jundak_devourer` to 70, or raise all three.**
Flagging rather than filling.

The original finding follows, unedited.

`Skull_of_the_Jundak.wiki` puts the Ancient Jundak at **CL 84, Elite**. `trophy_hunts.lua:429`
spawns `jundak_devourer`, whose template carried `level = 70` (`jundak_devourer.lua:6`), renamed at
spawn — a substitution the file documents, because `som_ancient_jundak` ships nowhere.

This is **not** treated like the Storm Lord levels, and the difference is why it is left open. The
storm_lord templates are dedicated: each is consumed only by `storm_lord_region.lua` and the arc's
own kill lists, so raising them touches nothing else. `jundak_devourer` is shared — it is also one
of three interchangeable kill targets in the "hunt 15 jundak" bounty
(`bounty_hunts.lua:185`, alongside `jundak` and `orf_jundak`, both level 70). Raising it to 84
would make one of three otherwise-equivalent bounty targets markedly harder, and Core3's
`spawnMobile` has no per-spawn level argument to scope the change to the trophy hunt. Retail is
clear on the number; what it costs elsewhere is a design call, so it is Levarris's.

### What this census does not do

It does not place anything. Every item above needs a value — a coordinate, an encounter design —
that no shipped file contains. Those are authoring calls, not findings. (Two items that used to be
on this list, taming chance and the weapon-to-creature mapping, were resolved by the retune below
against stock anchors rather than invented; the *retail* weapon mapping is still unrecoverable.)

## The 157-template retune — the tier table every som header comment points at

This is the table, and it is the authority for what the numbers are and where each one came from.

Six of the 157 files carry a header note pointing here by name —
`som_alien_parasite`, `som_ancient_guardian_droideka`, `som_ancient_guardian_ig`,
`som_dark_jedi_boss`, `som_mustafarian_phantom_bandit`, `union_sentry_droid`. Those six are the
ones whose existing header comments asserted the old block was tuned and untouchable, so each had
to be corrected in place and pointed here. **The other 151 carry no note.** They were retuned by
the same table and are equally covered by it; the absence of a comment is not a sign a file was
skipped. To see whether a given file was retuned, compare it against `origin/unstable` — the
placeholder is unmistakable (`chanceHit = 0.27`, `baseXp = 235`).

**Why this was repair, not rebalancing.** All 158 som templates shipped carrying one identical
placeholder block — `level = 70`, `chanceHit = 0.27`, 550–800 damage, 16000/19000 HAM,
`baseXp = 235`, and a `lootGroups` entry whose `groups` list was empty behind
`lootChance = 2100000`, which fires a roll that resolves nothing
(`LootGroupCollectionEntry.h`). One block on a beetle and on the arc's final boss alike is not a
balance pass anyone made; it is an unfilled field. Several earlier header comments in this
directory described that block as a tuned port value not to be touched — those notes were wrong
and have been corrected in place.

**157 of 160 files changed.** Three are fenced and untouched: `obi_wan_ghost.lua` (Elysium /
World Beyond Worlds content, another project's), `surveyor_jo.lua` (a deliberate comment-only
tombstone that defines nothing) and `serverobjects.lua` (the loader).

**The level band is the planet's own.** Mustafar's shipped gates run 46
(`mensix/conversation/pei_yi_conv_handler.lua:37`), 61 (`quest/collectors_business.lua:139`,
`quest/cursed_shard.lua:181`, `quest/moral_choice.lua:171`), 70 (`quest/map_exploration.lua:98`,
`quest/som_poison_miners.lua:276`), 75 (`quest/historian.lua:299`, `quest/samaritan.lua:189`) and
80 (`quest/conversation/milo_conv_handler.lua:59`) — a 45–105 band, which is what the ladder
targets.

### The tier ladder

Every row is anchored on a stock base-tree template at that level. `level`, `chanceHit`,
`damageMin`, `damageMax`, `baseXp`, `baseHAM` and `baseHAMmax` are copied from the anchor exactly —
verified by direct read of all eight files.

**`armor` is the one exception and is a deliberate ladder, not a copy.** It diverges from the
anchor on three rows: `ancient_graul` and `gronda_juggernaut` both carry `armor = 1` where the
table uses 0, and `acun_solari` carries `armor = 0` where the table uses 1. The anchors are
inconsistent with each other on this field — a level-50 graul out-armouring a level-100 named NPC
is not a progression — so the column was smoothed to monotone 0/0/0/1/1/2/2/3 instead. The other
five rows happen to match their anchor. Calling this out because it is the only authored number in
the table.

| tier | level | chanceHit | dmgMin | dmgMax | baseXp | HAM | HAMmax | armor | stock anchor |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CIV     | 45  | 0.44 | 345  | 400  | 4461  | 9300   | 11300  | 0 | `mobile/corellia/gronda_patriarch.lua` |
| FAUNA_L | 50  | 0.47 | 370  | 450  | 4825  | 9700   | 11900  | 0 | `mobile/dantooine/ancient_graul.lua` |
| STD     | 70  | 0.65 | 430  | 570  | 6747  | 12000  | 15000  | 0 | `mobile/corellia/gronda_juggernaut.lua` |
| ELITE   | 85  | 0.75 | 555  | 820  | 8130  | 12000  | 15000  | 1 | `mobile/dathomir/spiderclan_crawler.lua` |
| NAMED   | 100 | 1    | 645  | 1000 | 9429  | 24000  | 30000  | 1 | `mobile/corellia/acun_solari.lua` |
| BOSS    | 120 | 4.0  | 745  | 1200 | 11390 | 44000  | 54000  | 2 | `.../corellian_corvette/neutral/corsec_security_specialist.lua` |
| APEX    | 140 | 7    | 845  | 1400 | 13273 | 68000  | 83000  | 2 | `.../corsec_special_ops_master_sergeant.lua` |
| RAID    | 200 | 16   | 1145 | 2000 | 19008 | 160000 | 195000 | 3 | `.../imperial/rebel_rear_admiral.lua` |

### Resists

| key | value | source |
| --- | --- | --- |
| R_BASE / R_DROID | `{0,0,0,0,0,0,0,-1,-1}` | `mobile/thug/thug.lua:16` |
| R_HEAT_L | `{5,5,5,30,-1,30,-1,-1,-1}` | `mobile/tatooine/tusken_raider.lua:14` |
| R_HEAT_H | `{130,130,-1,160,160,160,-1,-1,-1}` | `mobile/dathomir/rancor.lua:14` |

Tier overrides the key in two cases: `BOSS`/`APEX` take `{90,90,90,90,90,90,90,90,-1}`
(`mobile/thug/dark_jedi_master.lua:16`) and `RAID` takes `{165,145,35,35,35,35,35,35,-1}`
(`mobile/endor/gorax.lua:14`).

### Weapons

Only groups that `mobile/weapon/serverobjects.lua` actually includes are used — that is the
constraint that killed the `jedi_dark` attempt recorded earlier in this document. `"unarmed"` and
`"none"` are engine literals, not groups. Attack identifiers all resolve in
`mobile/creatureskills.lua`; `merge` is variadic (`mobile/creatures.lua:72`).

Three files keep `defaultWeapon` / `defaultAttack` instead of the group form, because they are
droids and follow the shipped droid templates (`mobile/lok/ig_assassin_droid.lua`,
`mobile/lok/droideka.lua`): `som_ancient_guardian_droideka`, `som_ancient_guardian_ig`,
`union_sentry_droid`.

### Loot

Every group named is one that already exists and is already registered by
`addLootGroupTemplate()` in `loot/groups.lua`. Nothing was minted. `lootChance` values follow the
stock bands: creature 2000000 (`mobile/dathomir/rancor.lua`), elite 7000000
(`mobile/tatooine/canyon_krayt_dragon.lua`), boss 7000000 (`mobile/endor/gorax.lua`), custom boss
10000000 (`mobile/kaas/creatures/vitiate.lua`). Counts after the pass: 96 templates name at least
one group, 62 carry a genuinely empty `lootGroups = {}`, and 0 remain in the broken
`groups = {}`-behind-a-live-`lootChance` state.

⚠ Those 96 / 62 counts describe the retune, which is what this section is about — leave them.
The **current** directory counts are 100 / 59 / 159; see *Loot — the three trophy items*. Round C
also introduced the first `lootChance` in this tree that is **not** from the stock bands above:
`1250000`, which is a transcription of live's 12.5%, not a band choice.

### What the retune deliberately did not touch

`pvpBitmask` and `creatureBitmask` — spawn and aggression behaviour is region design, not combat
maths, and changing it would alter how Levarris's placed populations play. `milk` stays 0.

### Verification

    som + mustafar scope:          ok=230   fail=0
    object/custom_content scope:   ok=14022 fail=0

Both under Lua 5.3.6. The applier is idempotent — a third run reported `files changed: 0`.

## The first boot — runtime evidence, which this port had never had

Everything above this section was proved by reading files. A Lua syntax gate proves a file parses;
it does not prove the server can load it, and nothing in this round had ever been run. On
2026-08-31 the branch was booted. It reached `READY` in 40 seconds.

Recipe, matching the space round's: sync the branch into the built WSL tree (CRLF→LF), then boot
and read the log.

    wsl -d StardustDev bash -lc "bash /mnt/c/stardust-3-space-port/_setup/sync-mustafar.sh"
    wsl -d StardustDev -u root bash -lc "bash /mnt/c/stardust-3-space-port/_setup/boot-mustafar.sh 900"
    wsl -d StardustDev -u root bash -lc "bash /mnt/c/stardust-3-space-port/_setup/triage-mustafar-boot.sh"

Two things about that lane are not obvious and cost real time:

- **Distro.** The build lives in `StardustDev` (user `ciiv`), not the default `Ubuntu` distro.
  `Ubuntu` has no `/home/ciiv` at all, so every build and boot command needs `-d StardustDev`.
- **User.** It must boot as root. The earlier space-round boots ran as root — `service mysql start`
  needs it — so `bin/log/*` and all 32 files in `bin/databases/` are `root:root`, and the object
  database is mode 640. Booted as `ciiv` the server dies in under five seconds, before it reads a
  single script, with `FileWriterOpenException` and then a Berkeley DB `DB_RUNRECOVERY` panic. That
  is a file-ownership artifact of how the tree was staged. It is not a defect in this content, and
  reading it as one wasted a cycle.

`boot-mustafar.sh` rotates the six root-owned files in `bin/log/` aside (renamed `*.pre-mustafar`,
never deleted — the 6.3 MB `core3.log` from 2026-08-28 is the only other runtime record this tree
holds) and stops the server once it sees `READY`, so it never leaves one running.

### What Mustafar did at runtime

    (18 s) [ZoneServer Core3] Ground Zone: Mustafar deployed.
    (23 s) [PlanetManager mustafar] Loaded 71 total regions.
    (26 s) [PlanetManager mustafar] Loaded 5947 client objects from world snapshot.
    (39 s) [DirectorManager] Started 925 global screenplays in 7.895 s
           MustafarDungeonPopulation: 921 creatures placed across the Mustafar dungeon pools

That last line is the one worth having. The 921 is the placement layer actually running against
the retuned templates, not a count derived from reading spawn tables.

### Every residual error, attributed

The boot emitted 202 `ERROR` lines and 46 `WARNING`s, and 0 `FATAL`. **None of them are this
port's.** Attribution, so the claim is checkable rather than asserted:

| count | error | owner |
| --- | --- | --- |
| 62 | `could not create snapshot object` | upstream: 48 corellia (meatlump quest props — `meatlump_hideout_map_location.iff` ×10, safes, maps, palettes), 14 naboo (elevator click terminals ×9, `carbine_e11_mark2`) |
| 62 | `could not create object CRC` | same 62 events, logged twice |
| 62 | `Failed to create object with unknown CRC` | same 62 events, logged a third time |
| 10 | `ObjectMenuComponent not found` | upstream FS village: `FsCrafting1AnalyzerMenuComponent`, `FsCrafting1CalibratorMenuComponent`, `SensorArrayAccessTerminalMenuComponent` |
| 3 | `Could not create command` | upstream: `findStructure`, `regrantSkills`, `village` |
| 2 | `InvalidChunkTypeException` / `Could not open chunk` | upstream TRE: `appearance/defaultappearance.msh` |

The 62 snapshot failures are three log lines per event, which is why 62 × 3 + 10 + 3 + 2 + 1
(`setStringFromFile Core3.Revision`, a missing `conf/rev.txt`) accounts for all 202.

The test that matters: filtering all 202 error lines and all 46 warnings for `som`, `mustafar` or
`custom_content` returns **nothing**. Not one template in this port failed to create, and there is
not a single Lua error, stack traceback, or `unknown template key` in the log.

The warnings are likewise all upstream and all pre-existing: corellia's `*_white` skyscraper and
filler buildings missing from the TREs, `snapshot/tutorial.ws`, the `space_kashyyyk` nebula table,
`bm_mobile.iff` derv failures on beast-master templates, and `expecting SHOT got SSHP` on the space
station shared templates — that last group is the space round's, already known there.

### What this boot does and does not prove

It proves the branch loads: every som template parses, resolves, and instantiates; the zone
deploys; the regions load; the screenplays start; the dungeon population layer runs and places 921
creatures. That is the whole load-and-register question, closed.

It does not prove behaviour. A boot cannot tame a creature, open a lair, fire a conversation
branch, or roll a loot table. The pet-control-device fix in `a1b872598e` is proved *registered* by
this boot and still unproved *in play* — that needs a client. Same for the conversation trees, the
bounty and trophy chains, and every `lootChance` this round set. Those stay open, and the sections
above that mark them open still mark them open.

---

## Final completeness sweep — 2026-09-01

Run after Rounds A, B and C, to answer one question: **is anything in this port still broken or
unreachable for a mechanical reason?** Four checks, each run directly against the tree, each
mechanical enough that the result is a count rather than an opinion. Script: `C:\tmp\sweep.sh`.

| # | check | result |
| --- | --- | --- |
| 1 | `registerScreenPlay("X")` vs the object actually defined in that same file, across `screenplays/mustafar/**` | **35 checked, 0 mismatches** |
| 2 | every distinct `conversationTemplate` on a som mobile resolves to a definition under `mobile/conversations/` | **34 checked, 0 unresolved** |
| 3 | every mobile name passed to `spawnMobile` by a mustafar screenplay is a registered creature template | **51 checked, 0 unregistered** |
| 4 | every `screenplays/mustafar/**` file is reachable from an include | **71 files, 71 matching lines in `screenplays.lua`, 1 not named** |

Check 4's single hit is `screenplays/mustafar/quest/conversation/jo_kelsev_conv_handler.lua`. **It
is not a defect.** The file is a deliberate tombstone — its own header says the handler moved to
`keslev_conv_handler.lua`, that the NPC is Surveyor Keslev with no "Jo" in his name, that it is
intentionally out of `screenplays.lua`, and that it defines nothing so it loads as a no-op. It is
also on the fenced list and was not touched.

**So: no new mechanical defects.** The remaining Mustafar work is not repair. It is the design
questions below, plus the two genuine remainders already written up — the narrower-than-live loot
pool for the three trophy species, and the 72 mis-pathed `cube_loot` registrations.

An independent sweep agent was also run over the same question and returned no new findings. Its
report is **not** the basis for the table above; every row there was re-run and counted directly,
because a sweep that reports "clean" is exactly the kind of claim that has to be checked rather
than accepted.

## The ten "design calls" — mostly mislabelled, corrected 2026-09-01

⚠ **This section used to be headed "Open design calls — Aaron's, not mine". That framing was wrong
and Aaron rejected it:** *"these are not design questions for me. they are gaps you didn't do or
didn't research well enough."* He is right, and the proof is that one pass over `dsrc` and
`_allqst_dump.txt` settled six of the ten without needing him at all.

The corrected split:

- **Four were real gaps — research not done:** 1 (tiers), 6 (battlefields), 8 and 9 (weapons).
- **One is a small real gap:** 2 (`invulnerable` on `npc_ithes_olok`).
- **Three were never gaps.** The port had already handled 3, 7 and 10 correctly, with the reasoning
  written into the screenplay files. Listing them here as open questions misrepresented finished
  work as unfinished. Each is marked below.
- **One is genuinely unknown:** 5 (pedestal height).
- **One is a confirmed negative:** 4 (seismic charges) — recorded, not open.

**The rule that earns:** before anything goes on a list addressed to Aaron, check whether the answer
is already in the shipped data or already in this port's own files. "I have not looked yet" is not a
design question. Neither is "a previous round already decided this and wrote down why."

1. **Creature tiers vs live `difficultyClass`.** ⚠ **NOT A CALL ANY MORE — live decides it.**
   `creatures.tab` col 7, typed `e(NORMAL=0,ELITE=1,BOSS=2)`. There is no fourth value. The 292
   `som_*` rows split **203 NORMAL / 58 ELITE / 31 BOSS**. Note this is *not* what scales stats —
   cols 3–6 (`Damagelevelmodifier`, `StatLevelModifier`, `ToHitLevelModifier`,
   `ArmorLevelModifier`) are explicit and separate.

   ⚠ **RETRACTED — the sentence that used to end this item said "re-keying the retune on col 7 is
   now mechanical." That was wrong, and two later rounds proved it wrong in code.** Col 7 carries
   **three** values. The retune ladder from commit `189d4f1622` has **eight** rungs — CIV 45,
   FAUNA_L 50, STD 70, ELITE 85, NAMED 100, BOSS 120, APEX 140, RAID 200. Three values cannot key
   eight rungs; every mapping from one to the other is a judgement, not a lookup. Rounds F1(a)
   (`852e2074b4`) and F2(a) (`34dccdf96c`) both had to make that judgement by hand and both said so
   in their own commit messages: the valley took live BOSS → 120 and live ELITE → 85, the volcano
   took live BOSS → 140 and live ELITE → 120, because the volcano is gated behind the valley and
   live encodes that gap in raw HP that the ladder replaced. The autopilot broke the mapping again —
   live level 100, placed at CIV 45, because live's number is not a difficulty rating.

   **So: not mechanical, and ROUND D(a) is closed as NOT-A-GAP rather than as done work.** The port
   does not re-key on col 7 and should not. The ladder IS the tuning; col 7 is one input to a
   per-row decision. Live's split is recorded above as reference data, which is all it ever was.
2. **`pvpBitmask = ATTACKABLE` on the four quest givers.** ⚠ **MOSTLY ANSWERED, and the answer is
   "leave three alone."** Live has an explicit `invulnerable` column (`creatures.tab` col 56). Only
   **18 of 292** `som_*` rows set it to 1. Of our four:
   `som_cube_ithes_olok` = **1** (invulnerable); `som_naboo_historian`, `som_doctor_lu` and
   `som_reporter_jural` are all **blank** — attackable on live, exactly as we ship them.
   `som_foreman_nurfa`, the sibling that pinned the `optionsBitmask` fix, is also blank, yet our
   tree gives it `pvpBitmask = NONE`. So the only real item here is `npc_ithes_olok`, plus an
   unexplained `NONE` on nurfa. The remaining call is whether to encode col 56 at all.
3. **Quest XP policy.** ⚠ **NOT A GAP — the port already got this right, and listing it was the
   error.** `bounty_hunts.lua:117-122` reads the `.qst` correctly: the **Reward task** pays Bank
   Credits and `Experience Amount = 0`; the `1000 / quest_combat` sits on the quest-list block, which
   only the live quest system awards, and there is no quest-system row in this port to award it from.
   Raw proof, `som_lava_flea_hunt`:

   ```
   34:      [task id=2 type='Reward']
   47:        Experience Amount   = 0
   50:        Bank Credits        = 7000     <- what the task pays
   91:  Bank Credits              = 0
   94:  Experience Amount         = 1000     <- quest-list level, not the task
   ```

   I wrote two extraction scripts trying to show seven quests were missing a 1000 XP award. **Both
   were wrong** — they conflated the indent-2 quest-list block with the Reward task. The raw read
   settles it and the existing code is correct. The amounts were never untranscribed either: they
   are all in `_allqst_dump.txt`, which this very file cites by line number elsewhere.
4. **The five `som_sceismic_charges` fields** — see *Seismic charges*, a confirmed negative. To be
   exact about what the five are: every `LocationX/Y/Z` is 0.0, the Encounter task has no Creature
   Type, the Wait for Signal task has no Signal Name, and Reward is 0 XP / 0 credits. The server
   source has nothing either — every "seismic" hit in it is a **space** missile launcher.
5. **The Kenobi pedestal height.** Still open. The object exists
   (`object/tangible/quest/som_kenobi_final_crystal_pedestal.tpf`); no placement or elevation
   figure is recorded anywhere in the server source.
6. **Two unimplemented battlefield instances:** `mustafar_droid_army`, `mustafar_volcano`.
   ⚠ **NOT "cut content" — both ship complete in the server source.** `instance_datatable.tab` has
   a row for each, with entry and exit coordinates and a daily lockout:
   `mustafar_droid_army` enters at `-79,12,-152` and exits to `541,155,-160,mustafar`;
   `mustafar_volcano` enters at `-256,-1,233` and exits to `-2397,210,1850,mustafar` with player
   script `theme_park.dungeon.mustafar_trials.volcano_battlefield.volcano_player`.
   The script trees are `valley_battleground/` (**20 files** — turrets, demolition packs, droid and
   mining squads, Foreman Koseyet) and `volcano_battlefield/` (**29 files** — five numbered events
   each with a boss and guards, the HK-47 arc, an exit terminal, an event manager).
   `mustafar_trials/` is 200 files total. This is the largest implementable block on the list, and
   it is a scope decision, not a design one.
7. **The `som_poison_miners` task-8 reward** — whether to swap it to a SoM pistol. ⚠ **NOT A GAP —
   already exact.** The live Reward task pays nothing at all:

   ```
   128:                [task id=8 type='Reward']
   140:                  Experience Amount   = 0
   143:                  Bank Credits        = 0
   ```

   No `Item` line either. Our `som_poison_miners.lua:325` carries `rewardCredits = 0` and guards the
   grant behind `if (self.rewardCredits > 0)`. That matches live exactly. There was nothing to
   decide; swapping in a pistol would have *introduced* a deviation, not fixed one.
8. **The `experimental*` crafting curves on the two rewritten heavy weapons.** ⚠ **The source
   exists — this is transcription, not design.** `datatables/crafting/weapon_schematics.tab` has one
   row per SoM weapon with the full crafted spread. Example, `som_lance_xandank`: complexity 36,
   xp 450, hit points 800–1100, min damage 334–667, max damage 1000–1333, kinetic.
9. **Which creature drops which of the 23 SoM weapon templates.** ⚠ **FALSE PREMISE — live does not
   drop them at all.** Thirteen of the fourteen distinct SoM weapons have exactly one
   `weapon_schematics.tab` row and a `draft_schematic`; **zero** appear in any loot table anywhere
   in the server source. They are **crafted**, not looted. The fourteenth,
   `som_2h_sword_massassi`, has neither — it exists only in `master_item.tab` and its own `.tpf`.
   The three trophy tabs are the only mustafar loot files that reference a `som/` path at all, and
   those are already wired (Round C). This item is closed as asked and reopens as "wire the
   fourteen draft schematics", which is item 8's work.
10. **Whether to widen the three trophy loot pools to live's full 9 items.** Still a real question,
    but the `cube_loot` half of it was ⚠ **not a new finding and I should not have written it up as
    one.** `jenha_tar_cube.lua:112-137` already found the split path, traced why the objects still
    resolve (`TemplateManager.cpp:456` reads `clientTemplateFileName` off the Lua table and uses the
    registration string only as a lookup key), addressed the reward items by their registered path so
    the quest works, and deliberately left the one-line fix alone as "not this port's file to change."
    My "⚠ NEW, unfixed" subsection above re-discovered our own record. **The cube quest is not
    broken.** Corrected in place rather than deleted, since the earlier text is what was committed.

One item that was on this list and should not have been: the `som_xandank_trophey` NPC giver was
recorded as a deviation from the click-to-start pattern. It is not — Miner Renlo Hens is the live
design, with a full grant and turn-in transcript, and he is wired. Removed rather than left to be
"fixed" into a defect later.

## Where the answers in that list came from — 2026-09-01

Aaron passed in a second agent's report on the ten items. **Six of its ten answers did not survive a
check against the server source**, so none of the text above is taken from it. Every figure in the
list is from a direct read of `SWG-Source/dsrc`, and the checks are re-runnable
(`C:\tmp\verify3.sh`, `verify11.sh`, `verify13.sh`, `verify15.sh`).

What failed, recorded so it is not re-imported later:

- A shared loot sub-table named `som_weapon_loot` — **zero occurrences in the entire server
  source.** The real answer is the opposite of the premise: the weapons are crafted.
- `difficultyClass = 3 (WorldBoss)` — the enum is `NORMAL=0, ELITE=1, BOSS=2`. There is no 3.
- All four quest givers being invulnerable on live — three of the four are not.
- Five named seismic-charge fields (`charge_location`, `detonation_timer`, `blast_radius`,
  `damage_amount`, `charge_state`) — none of those exist; the quest is a stub with 0.0 locations.
- A 1.25 m Kenobi pedestal elevation offset — no such figure anywhere.
- Both battlefields being cut before Publish 25 — 49 script files and two `instance_datatable.tab`
  rows say otherwise.

Three of its weapon names (Searing Blade, Mustafarian Disruptor, V-1 Thermal Rifle) return zero hits
in the server source. Every claim carried a wiki citation.

**The standing rule this earns, alongside the two at the top of this file:** a report with citations
is still a claim. Check it against `dsrc` before it enters this document. It cost one pass to check
and the pass closed four items, so the checking is worth doing rather than skipping.
