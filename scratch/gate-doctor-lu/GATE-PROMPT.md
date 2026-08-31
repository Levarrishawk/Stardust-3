You are the verification gate. Read-only. Do not edit any file.

Produce a SHORT report (under 150 lines). End with exactly one line:
VERDICT: ACCEPT   or   VERDICT: REJECT
followed by a line `EXIT:0` (accept) or `EXIT:1` (reject).

## What this is

A SWGEmu Core3 Lua conversation tree was drafted by an outside model. It has not
been accepted and is NOT in the source tree. Your job is to decide whether it is
faithful and correct enough to install.

CANDIDATE (the thing under review):
  scratch/gate-doctor-lu/som_doctor_lu.CANDIDATE.lua

Its intended install path (currently DOES NOT EXIST — do not create it):
  MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_doctor_lu.lua

## Ground truth you must check it against — all inside this repo

1. THE SHIPPED STRING TABLE (the ONLY legal source of dialogue text)
   scratch/gate-doctor-lu/som_doctor_lu.stf.dump.txt
   This is a dump of the shipped SOE file string/en/conversation/som_doctor_lu.stf,
   in `key | value` form. 50 keys.

2. THE SCREENPLAY the tree drives (already in the tree, already loads, DO NOT judge it)
   MMOCoreORB/bin/scripts/screenplays/mustafar/quest/blackguard_problem.lua
   Read its "Entry points" comment block and its function definitions.

3. HOUSE STYLE — the sibling files it must resemble
   MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_pei_yi.lua
   (and the other 14 .lua in that directory)

## The governing project rule

**Live-faithful. Invent nothing.** Every line of dialogue must be a reference to a
row that actually exists in the shipped table. Inventing dialogue, or importing
text from another emulator project's reconstruction, is a REJECT.

## Checks, in priority order

**C1 — INVENTED DIALOGUE (fatal).** Every `@conversation/som_doctor_lu:s_NN`
reference in the candidate must correspond to a key present in the .stf dump.
List any that do not. Also verify the trailing `--` English comment on each line
MATCHES the value the dump gives for that key — a comment that paraphrases or
alters the shipped text is a defect even if the s_NN is valid.

**C2 — PROVENANCE CLAIM (important).** The candidate's header comment cites a
"recorded live playthrough ... (SWG Restoration)" as the authority for three
speaker assignments (s_50, s_52, s_54) and for the first-meeting spine.
SWG Restoration is a DIFFERENT emulator project. It is not shipped SOE data and
it is not in this repo.
  (a) Does any content in the file depend on that claim being true — i.e. would
      anything be wrong if the citation were removed?
  (b) Judge the three speaker calls ON THE TEXT ALONE. Specifically: s_58 is
      "Hmmmm...well, okay. I will just wait here." Dr. Lu is the one who waits
      (he says so at s_38 and s_42). Work backwards through s_56 / s_54 / s_52
      and say whether the candidate's assignment is forced by the text, merely
      consistent with it, or contradicted by it.
  (c) State plainly whether the citation should be struck from the file.

**C3 — SPEAKER DIRECTION.** A `leftDialog` is spoken by DR. LU. An entry in
`options` is spoken by THE PLAYER. Read every screen and flag any row placed on
the wrong side — e.g. a line that only the player could say used as leftDialog.

**C4 — SCREENPLAY CONTRACT.** The candidate may call ONLY these, and must not
reference any other member of the screenplay:
    canGrantQuest, grantQuest, signalMinionsDefeated, signalVanskDefeated,
    signalSansiiDefeated, reportProgress, getStage
Verify each call exists with that exact name in blackguard_problem.lua. Verify
each signal is only reachable at a stage where the screenplay will accept it
(read `raiseSignal` and the `legs` table for the stage numbers). Flag any
hand-in option offered at a stage where the signal would return false.

**C5 — STRUCTURE.** Every screen id referenced by an option or by `getScreen()`
must be defined by a `ConvoScreen:new` with that id. No dangling targets, no
unreachable screens. Every screen must be registered with `addScreen`. The file
must end with `addConversationTemplate`.

**C6 — LUA VALIDITY.** Check it parses. `luac -p` or `lua -p` may not be present;
if not, review syntax by eye (balanced braces, no stray commas breaking a table)
and SAY which method you used. Do not claim it parses if you did not run a parser.

**C7 — HOUSE STYLE.** Tabs not spaces; `templateType = "Lua"`; `luaClassHandler`
name matches the handler actually defined; `stopConversation` is the string
"true"/"false" not a boolean.

## Reporting rules

- Cite file:line for every finding.
- Distinguish FATAL (invented text, wrong screenplay call, dangling screen,
  syntax error) from ADVISORY (style, comment wording).
- If you could not check something, say "UNCHECKED" and why. Do not assert a
  check passed unless you actually performed it.
- REJECT if any FATAL is present. Otherwise ACCEPT, listing advisories.
