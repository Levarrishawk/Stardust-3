You are the verification gate. Read-only. Do not edit any file.

Produce a SHORT report (under 150 lines). End with exactly one line:
VERDICT: ACCEPT   or   VERDICT: REJECT
followed by a line `EXIT:0` (accept) or `EXIT:1` (reject).

## What this is

A SWGEmu Core3 Lua conversation tree AND its handler were drafted by an outside
model. They are NOT in the source tree. Decide whether they are faithful and
correct enough to install.

CANDIDATES (the things under review):
  scratch/gate-storm-lord/som_storm_lord_jural.CANDIDATE.lua
  scratch/gate-storm-lord/storm_lord_jural_conv_handler.CANDIDATE.lua

Intended install paths (currently DO NOT EXIST — do not create them):
  MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_storm_lord_jural.lua
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/storm_lord_jural_conv_handler.lua

## Ground truth — all inside this repo

1. THE SHIPPED STRING TABLE (the ONLY legal source of dialogue text)
   scratch/gate-storm-lord/som_storm_lord_jural.stf.dump.txt
   A dump of string/en/conversation/som_storm_lord_jural.stf, `key => value`.
   NOTE: s_2 has an empty value and was never offered to the drafting model.

2. THE SCREENPLAY (already in the tree, already loads, DO NOT judge it)
   MMOCoreORB/bin/scripts/screenplays/mustafar/quest/storm_lord.lua
   Read its `legs` table (around line 281) and `raiseSignal` (around line 511).

3. HOUSE STYLE — the siblings these must resemble
   MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_glyph_hunt.lua
   MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/glyph_hunt_conv_handler.lua
   MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_pei_yi.lua
   and the eleven handlers in screenplays/mustafar/quest/conversation/

## The governing project rule

**Live-faithful. Invent nothing.** Every line of dialogue must reference a row that
actually exists in the shipped table. Inventing dialogue, or importing text from
another emulator project's reconstruction, is a REJECT.

## What I already verified mechanically — RE-CHECK, do not assume

I ran these myself and got a clean result. Contradict me if I am wrong; a false
pass from me is worse than a slow gate.
  - 61 distinct s_NN referenced, every one present in the dump, none invented.
  - Every trailing `--` English comment matches the dump value for its key.
  - 35 screens defined, 35 addScreen, no dangling targets, no orphans, no dup ids.
  - All 8 screenplay methods called (getStage, reportProgress, canGrantQuest,
    grantQuest, signalMinionsDefeated, signalZealotsDefeated, signalProphetDefeated,
    signalStormLordDefeated) exist on somStormLordScreenPlay.
  - Hand-in guards are stages 2/4/6/8, matching legs[1..4].waitStage.
  - addConversationTemplate is the tree file's last statement.
  - Both files pass `luac5.3 -p`.
  - Unplaced rows: s_2 (empty, never offered) and s_62 (declared in ROWS NOT PLACED).

So spend your effort on the JUDGEMENT calls below, which no script can check.

## Checks, in priority order

**G1 — SPEAKER DIRECTION (fatal if wrong).** A `leftDialog` is spoken by JURAL, a
Corellian Times reporter whose brother Talper is dying of a Storm Lord affliction.
An entry in `options` is spoken by THE PLAYER. Read every screen and flag any row on
the wrong side. This table is large and has four near-identical check-in / hand-in
cycles, which is exactly where a swap hides. Pay special attention to:
  - The four progress lines the player says vs the four Jural says about Talper's
    condition (s_8, s_18 and their siblings). Say which mouth each belongs in.
  - s_55 "You did it! Talper is already feeling better..." and s_64 "No, it was
    something. Please, take this as payment..." — both must be Jural.
  - Any row that reads as a decline ("I wish I could help you, but I just cannot",
    s_124) — decide whose line that is and whether the candidate agrees.

**G2 — STAGE GATING.** The four legs use killStage 1/3/5/7 and waitStage 2/4/6/8.
getInitialScreen must send the player somewhere sensible for each of stages 0-8,
and a hand-in must be offered ONLY where raiseSignal will succeed (i.e. on the
waitStage). Verify the leg numbers in storm_lord.lua yourself. Flag any hand-in
reachable at a stage where the signal returns false, and flag any stage that
routes to a screen offering the WRONG leg's hand-in.

**G3 — PAIRING LOGIC.** The header comment claims a spine and justifies the
non-obvious pairings, including which check-in belongs to which leg. Are the claims
actually supported by the text of the rows, or is any of it asserted without
evidence? With four similar cycles, the leg-to-row assignment is the highest-risk
claim in the file. Quote any claim you think is unsupported.

**G4 — PROVENANCE.** Does either file cite another emulator project, wiki, or a
recorded playthrough as authority? That is a defect on its own. (I grepped and found
none, but check the reasoning too — an uncited claim that could only come from
outside the table is the same problem.)

**G5 — HOUSE STYLE.** Tabs not spaces; `templateType = "Lua"`; luaClassHandler name
matches the handler actually defined; `stopConversation` is the string "true"/"false";
the handler returns `pClonedScreen` like its eleven siblings do.

## Known and already accepted — do NOT report these as findings

- s_64 promises the player payment, but storm_lord.lua:awardQuest deliberately pays
  nothing because the shipped quest data has Bank Credits 0. That mismatch is a known
  open item on the screenplay side, already documented there. The tree quoting the
  shipped line is correct behaviour.
- `clonedConversation` is assigned but unused in the handler. The sibling handlers do
  the same. Advisory at most.

## Reporting rules

- Cite file:line for every finding.
- Distinguish FATAL (invented text, wrong speaker, hand-in at an impossible stage,
  wrong screenplay call, wrong leg assignment) from ADVISORY (style, comment wording).
- If you could not check something, say "UNCHECKED" and why. Do not assert a check
  passed unless you actually performed it.
- REJECT if any FATAL is present. Otherwise ACCEPT, listing advisories.
