# Round: the two SoM pistols carry carbine certifications

## The defect

`som_disruptor_pistol` and `som_ion_relic_pistol` are PISTOLS that require a CARBINE
certification and grant CARBINE experience. A player who has mastered Pistoleer cannot
equip them; a Carbineer can. That is backwards.

Cause: every file in `object/custom_content/weapon/ranged/` was stamped from one stencil
(`carbine_bothan_bola.lua`). Both pistols are byte-identical to that stencil except their
object name and `addTemplate` path. The rest of the SoM weapon set was corrected off the
stencil afterwards — swords carry sword certs, lances carry lance certs, rifles carry rifle
certs, and `som_carbine_republic_sfor` correctly carries a carbine cert because it IS a
carbine. Only these two were missed.

External confirmation: the NGE-era Mustafar reference lists
"Coynite Disruptor Pistol [CL55, Pistoleer:Master]",
"Mustafarian Modified Disruptor Pistol [CL55, Pistoleer:Master]" and
"Ion Relic Pistol [CL??, Pistoleer:Master]" — Pistoleer, not Carbineer.

## The four files to change

```
object/custom_content/weapon/ranged/som_disruptor_pistol.lua
object/custom_content/weapon/ranged/som_disruptor_pistol_generic.lua
object/custom_content/weapon/ranged/som_ion_relic_pistol.lua
object/custom_content/weapon/ranged/som_ion_relic_pistol_generic.lua
```

## The exact change — five fields, in each of the four files

Change ONLY these five assignment lines. The correct values are copied from
`object/custom_content/weapon/ranged/pistol_dl44_metal_light.lua`, which is the
correctly-authored custom pistol in this same directory — read it first and match it.

| field | from | to |
| --- | --- | --- |
| `xpType` | `"combat_rangedspecialize_carbine"` | `"combat_rangedspecialize_pistol"` |
| `certificationsRequired` | `{ "cert_carbine_cdef" }` | `{ "cert_pistol_cdef" }` |
| `creatureAccuracyModifiers` | `{ "carbine_accuracy" }` | `{ "pistol_accuracy" }` |
| `creatureAimModifiers` | `{ "carbine_aim", "aim" }` | `{ "pistol_aim", "aim" }` |
| `speedModifiers` | `{ "carbine_speed" }` | `{ "pistol_speed" }` |

## HARD CONSTRAINTS — do not exceed this scope

- Touch ONLY those four files. Nothing else in the repo.
- Change ONLY those five assignment lines per file. Do not reformat, do not reorder,
  do not touch the comment blocks above each field, do not touch the vendor list.
- DO NOT touch `minDamage`, `maxDamage`, `attackSpeed` or `woundsRatio`. The placeholder
  damage values (99999999998 / 99999999999) are a SEPARATE open decision that belongs to
  the repo owner. Leaving them is correct for this round.
- Do not touch any other `som_*` weapon. The rifles and the carbine are already correct.
- Do not touch the 26 non-som files that share the stencil. Out of scope.
- Do not run a build, a server, or any test. Do not commit. Do not create branches.
- Preserve the existing line endings and indentation (tabs).

## Definition of done

All four files changed, five lines each, twenty lines total. Report the exact `git diff
--stat` and confirm the count. If any file does not contain one of the five source values
verbatim, STOP and report that instead of guessing.
