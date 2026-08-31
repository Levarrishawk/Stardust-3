You are the verification gate. Read-only. Do not edit any file.

Produce a SHORT report (under 150 lines). End with exactly one line:
VERDICT: ACCEPT   or   VERDICT: REJECT
followed by a line `EXIT:0` (accept) or `EXIT:1` (reject).

## What this is

A SWGEmu Core3 Lua conversation tree AND its handler were drafted by an outside
model. They are NOT in the source tree. Decide whether they are faithful and
correct enough to install.

CANDIDATES (the things under review):
  scratch/gate-glyph-hunt/som_glyph_hunt.CANDIDATE.lua
  scratch/gate-glyph-hunt/glyph_hunt_conv_handler.CANDIDATE.lua

Intended install paths (currently DO NOT EXIST — do not create them):
  MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_glyph_hunt.lua
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/glyph_hunt_conv_handler.lua

## Ground truth — all inside this repo

1. THE SHIPPED STRING TABLE (the ONLY legal source of dialogue text)
   scratch/gate-glyph-hunt/som_glyph_hunt.stf.dump.txt
   A dump of string/en/conversation/som_glyph_hunt.stf in `key | value` form.

2. THE SCREENPLAY (already in the tree, already loads, DO NOT judge it)
   MMOCoreORB/bin/scripts/screenplays/mustafar/quest/glyph_hunt.lua
   Read its "Entry points" comment block (near line 447) and its stage handling.

3. HOUSE STYLE — the siblings these must resemble
   MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_pei_yi.lua
   MMOCoreORB/bin/scripts/screenplays/mustafar/mensix/conversation/pei_yi_conv_handler.lua
   and the ten handlers in screenplays/mustafar/quest/conversation/

## The governing project rule

**Live-faithful. Invent nothing.** Every line of dialogue must reference a row that
actually exists in the shipped table. Inventing dialogue, or importing text from
another emulator project's reconstruction, is a REJECT.

## What I already verified mechanically — RE-CHECK, do not assume

I ran these myself and got a clean result. Contradict me if I am wrong; a false
pass from me is worse than a slow gate.
  - 40 distinct s_NN referenced, every one present in the dump, none invented.
  - Every trailing `--` English comment matches the dump value for its key.
  - 22 screens defined, 22 referenced, no dangling targets, no orphans, 22 addScreen.
  - Only canGrantQuest / grantQuest / signalGlyphsFound / signalGlyphFinish / getStage
    are called on the screenplay.
  - addConversationTemplate is the tree file's last statement.
  - Both files pass `luac5.3 -p`.
  - Unplaced rows: s_2 (empty) and s_36 (declared in ROWS NOT PLACED).

So spend your effort on the JUDGEMENT calls below, which no script can check.

## Checks, in priority order

**G1 — SPEAKER DIRECTION (fatal if wrong).** A `leftDialog` is spoken by PLETUS
CROIX, the elderly Naboo historian. An entry in `options` is spoken by THE PLAYER.
Read every screen and flag any row on the wrong side. Pay special attention to:
  - s_5 and s_13 are both questions about "the missing sections". One of them may
    be the player's and one Croix's, or both may be his. Judge from the wording.
  - s_25 "I managed to get copies of two of the ruins. Here." — is that the player
    handing over, or Croix describing? Say which and why.
  - s_68 and s_70 are the SAME question with different wording ("Razor Runners" vs
    "the Coyn"). Both shipped. Judge whether the candidate's handling is defensible.

**G2 — STAGE GATING.** For each stage 0-5, does getInitialScreen send the player to
a screen that makes sense for that stage, and is a hand-in option offered ONLY where
its signal will succeed? signalGlyphsFound requires stage 2; signalGlyphFinish
requires stage 4 (verify these numbers in glyph_hunt.lua yourself). Flag any hand-in
reachable at a stage where the signal returns false.

**G3 — PAIRING LOGIC.** The header comment claims a spine and justifies the
non-obvious pairings. Are the claims actually supported by the text of the rows, or
is any of it asserted without evidence? Quote any claim you think is unsupported.

**G4 — PROVENANCE.** Does either file cite another emulator project, wiki, or a
recorded playthrough as authority? That is a defect on its own. (I grepped and found
none, but check the reasoning too — an uncited claim that could only come from
outside the table is the same problem.)

**G5 — HOUSE STYLE.** Tabs not spaces; `templateType = "Lua"`; luaClassHandler name
matches the handler actually defined; `stopConversation` is the string "true"/"false";
the handler returns `pClonedScreen` like its ten siblings do.

## Reporting rules

- Cite file:line for every finding.
- Distinguish FATAL (invented text, wrong speaker, hand-in at an impossible stage,
  wrong screenplay call) from ADVISORY (style, comment wording).
- If you could not check something, say "UNCHECKED" and why. Do not assert a check
  passed unless you actually performed it.
- REJECT if any FATAL is present. Otherwise ACCEPT, listing advisories.
