# Round M2 — the display-name defect class

Read `scratch/round-m2/EVIDENCE.md` first. It carries the proof for everything below.
Every fact in it was produced and read firsthand by the orchestrator; treat it as
ground truth and do not re-derive it.

## The defect

Fifteen sites across fourteen Mustafar quest files justify a "reward NOT granted" or
"reward SUBSTITUTED" conclusion with a claim that is **false**:

  - *"There is no string/en/static_item_n.stf in _som to look it up in"*
  - *"no string/en STF row"*
  - *"None of the four reward items has a display name anywhere in the extract"*

`static_item_n.stf` **ships** — 1,052,886 bytes in `stardust_03.tre`, 9,754 keys — and
**all 20 reward tokens referenced under `screenplays/mustafar/` resolve in it.** The
files describe the contents of one local extract and state it as a fact about what the
game shipped. `trophy_hunts.lua:106` already had this right.

## The hard scope limit — read this twice

**A display name is NOT an object template.** An exhaustive sweep of all 31,074 shipped
`shared_*.iff` templates found an object for only **6** of the 20 keys. For the other
**14 the "NOT granted / substituted" conclusion is CORRECT and MUST STAND.**

Your job on those 14 is to **fix the reasoning, not the conclusion.** The corrected
reason is:

> the name resolves to `<display name>` in `string/en/static_item_n.stf`, but an
> exhaustive sweep of every shipped `shared_*.iff` finds no object template carrying
> that `objectName`, so granting the live item would mean authoring an object.

Do not weaken, strengthen, or reverse any conclusion. Do not add a reward grant to any
file except the one named in task A.

## A. The one real content fix — `lava_beetle_nests.lua:155-187`

`item_tow_trophey_02_01` = **"Mounted Kubaza Beetle Head"**, and
`object/tangible/loot/mustafar/shared_trophey_lava_beetle.iff` carries exactly that as
its `objectName` (`static_item_n : item_tow_trophey_02_01`). The server template is
registered — `trophey_lava_beetle.lua:3` `addTemplate`, `serverobjects.lua:15`.

**The file already grants `trophey_lava_beetle.iff`.** It is correct. It is just
labelled wrong: the header calls it `THE REWARD -- SUBSTITUTED`, a "SUBSTITUTE picked
on that reasoning, not a resolution", and marks it `-- OPEN`.

Change the prose only:
  - `THE REWARD -- SUBSTITUTED` → `THE REWARD -- RESOLVED`
  - delete the false "There is no string/en/static_item_n.stf..." sentence
  - replace the "obvious match / SUBSTITUTE / OPEN" reasoning with the actual proof:
    the objectName record in the shipped shared template
  - keep the sibling table at :170-172; it is right and it is now four of a family,
    not three
  - the parenthetical at :186-187 about maneater must change — see task B

**No code change in this file.** The `giveItem` call is already correct.

## B. `maneater.lua:147-160` — the hypothesis died, record why

I expected `trophey_tulrus_spine` to resolve to `item_tow_trophey_02_02`
("Mounted Tulrus Spine"). **It does not.** Its `objectName` record carries an *empty*
string table and the key `trophey_tulrus_spine_n`, which appears in no shipped STF —
`som_item.stf` ships and does not contain it. The template has no resolvable display
name at all. The sweep confirms no shipped object carries `item_tow_trophey_02_02`.

So maneater **stays a substitution.** Correct the false STF sentence, and record the
new, stronger reason: the wanted item has a shipped display name but no object, and
the substitute chosen has an object but no resolvable name.

## C. The twelve reason-only corrections

Apply the corrected reason from "hard scope limit" above, using each file's own item
and display name. Conclusions stand unchanged.

    blackguard_problem.lua:161-168   item_tow_proc_ranged_03_01     Mustafarian Distance Globe
    collectors_business.lua:77-79    item_tow_holocron_ab_immune_02_01  Sith Holocron
    cursed_shard.lua:119-122         item_tow_gloves_microsensory_02_01 Microsensory Mesh Gloves
    glyph_hunt.lua:165-172           weapon_tow_rifle_03_01         DP-23 Rifle
    hidden_treasure.lua:65-69        item_tow_schematic_reactor_02_01   Modified Fusion Reactor Schematic
    jedi_dog.lua:186-198             item_tow_clothing_03_03        Mustafarian Miner's Boots
                                     item_tow_clothing_03_02        Mustafarian Mining Suit
    reunite_shard.lua:155-158        item_tow_buff_crystal_02_02    Wild Force Shard
    som_striking_miners.lua:221-224  item_tow_clothing_03_02        Mustafarian Mining Suit
    storm_lord.lua:177-183           item_tow_proc_generic_03_01    Mustafarian Injector
    story_arc_prelude.lua:179-181    item_tow_necklace_03_01        Miners Medallion
    som_poison_miners.lua:177-181    weapon_tow_pistol_02_01        Mustafarian Modified Disruptor Pistol
    symbiosis.lua:76-81              weapon_tow_sword_1h_03_02      Caller of Storms

**`som_poison_miners.lua` and `symbiosis.lua` are special — read carefully.** These two
ARE among the six hits, but the object that carries the name is a *display tangible*
(`SharedTangibleObjectTemplate`, `gameObjectType = 8211`, no damage, no speed, no
xpType, no cert), while each file currently grants a *functional* weapon
(`pistol_dl44.iff`, `som_sword_obsidian.iff`).

For these two: state that the exact-named object **does** ship and name its path, then
state plainly that it is a non-functional display tangible and that swapping the
working weapon for it is **an open decision for Aaron, not taken here.** Change no
code. Do not swap the reward.

## D. `jenha_tar_cube.lua:139-142` and `:574`

Its four reward items are `som_cube` and `cube_loot_0a/0b/0c` — **not** tow items, so
the table above does not cover them. The claim to fix is the factual error at :140-141:
*"string/en carries only conversation/, quest/, dance_advancement.stf and
performance.stf, no item table."* `static_item_n.stf` ships. Correct that sentence.

Do **not** replace it with a new assertion that these four have no display name — that
has not been checked. Say the display names of these four are **unverified**. Same at
`:574`. Leave the reward logic and the `cube_loot` path finding untouched.

## Fences — hard

- **Lua only, additive only.** Never edit C++, `.tre`, or `snapshot/*.ws`. Read only.
- **Do not touch `trophy_hunts.lua`.** It was already correct.
- Never repoint an existing `conversationTemplate`.
- Never touch elysium / World Beyond Worlds, `obi_wan_elysium`, `obi_wan_ghost`.
- **Never delete a file. Never commit, never push, never add a remote.**
- No new `quests.iff` row, no `quest_manager.lua` id, no creature-template edit.
- `spatialChat` does not work in cells on this build — add none.
- Do not edit the four Round M1 files' giver/spawn logic. `blackguard_problem.lua`,
  `glyph_hunt.lua`, `storm_lord.lua` and `jenha_tar_cube.lua` are in this round for
  their **reward prose only**.

## Done means

Every file still passes `luac5.3 -p`. `git status --porcelain` shows only the files
named here. No conclusion changed except `lava_beetle_nests.lua` SUBSTITUTED→RESOLVED.
Every corrected paragraph names its item's real display name and says an object
template is what is missing.
