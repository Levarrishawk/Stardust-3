# Round D(b) + E — spec for the coder seat

Repo root: `C:\stardust-3-space-port\server`   Branch: `mustafar-content`
**Do not commit. Do not run git. Leave the working tree dirty.**
**Change only the lines named below. No reformatting, no field reordering, no comment churn.**
Files are tab-indented under `mobile/`, space-indented under `draft_schematic/`. Preserve existing
indentation exactly.

---

## ROUND D(b) — encode live `invulnerable` into `pvpBitmask`

Live `datatables/mob/creatures.tab` has an explicit `invulnerable` column (col 56, type `b[0]`).
18 of the 292 `som_*` rows set it. This port already encodes that as `pvpBitmask = NONE` — proven
by `diskret_stahn` and `pei_yi`, which are live-invulnerable and already `NONE`.

The retune commit `189d4f1622` states in its own message: *"pvpBitmask and creatureBitmask are
untouched throughout -- spawn and aggression are region design, not combat maths."* So every current
value is inherited from the SD-2 merge `aa044fc863` and was never set from live. This is unclaimed
work, not a re-litigation.

Dir: `MMOCoreORB/bin/scripts/mobile/custom_content/som/`

**D1.** `npc_ithes_olok.lua` line 24 — live row `som_cube_ithes_olok`, invulnerable = 1.
Identity confirmed by this file's own `conversationTemplate = "som_cube_ithes_olok"`. He is the
giver for the Jenha Tar cube quest (`jenha_tar_cube.lua:325`); today a player can kill him.

```
-	pvpBitmask = ATTACKABLE,
+	pvpBitmask = NONE,
```

**D2.** `npc_kweeta.lua` line 24 — live row `som_kweeta`, invulnerable = 1.

```
-	pvpBitmask = ATTACKABLE,
+	pvpBitmask = NONE,
```

### Do NOT touch (each verified, each has a reason)
- `foreman_nurfa.lua` — ours `NONE`, live blank. The *inverse* mismatch. Flipping it to ATTACKABLE
  would make a mid-quest striking-miners NPC killable: that creates a breakage to match live rather
  than removing one. Recorded, not fixed.
- `som_kenobi_sucker.lua` — ours `ATTACKABLE + ENEMY`, live invulnerable. The file's authored header
  documents it as the gaveAwayShard-branch mark, deliberately made fightable with
  `primaryAttacks = merge(brawlermaster,swordsmanmaster)`. A documented port decision.
- `obi_wan_ghost.lua`, `surveyor_jo.lua`, `serverobjects.lua` — FENCED. Never edit.
- Already correct: `diskret_stahn.lua`, `pei_yi.lua`, `som_kenobi_epo_qetora.lua`,
  `som_kenobi_menth_paul.lua`, `som_mustafarian_computer_technician.lua`.

---

## ROUND E — five appearance draft schematics point at the wrong weapon

Dir: `MMOCoreORB/bin/scripts/object/custom_content/draft_schematic/weapon/appearance/`

Each of these files is named for a SoM weapon and carries the correct SoM `customObjectName`, but its
`targetTemplate` still points at the base-game weapon from whichever file was copied to make it. The
"live" column below is `craftedObjectTemplate` read directly out of the shipped
`object/draft_schematic/weapon/appearance/*.tpf` in the server source.

**E1.** `weapon_appearance_lance_xandank.lua` line 30 — `customObjectName = "Xandank Lance"`.
Live: `object/weapon/melee/polearm/som_lance_xandank.iff`. That object IS registered in our tree.

```
-   targetTemplate = "object/weapon/melee/polearm/polearm_vibro_axe.iff",
+   targetTemplate = "object/weapon/melee/polearm/som_lance_xandank.iff",
```

**E2.** `weapon_appearance_pistol_disrupter.lua` line 30 — `customObjectName = "Disrupter Pistol"`.
Live: `object/weapon/ranged/pistol/som_disruptor_pistol.iff`. Registered in our tree.

```
-   targetTemplate = "object/weapon/ranged/pistol/pistol_de_10.iff",
+   targetTemplate = "object/weapon/ranged/pistol/som_disruptor_pistol.iff",
```

**E3.** `weapon_appearance_rifle_tenloss_disrupter.lua` line 31 — this one is wrong in the other
direction: a BASE-game schematic that was pointed at a SoM weapon. Live target is
`object/weapon/ranged/rifle/rifle_tenloss_dxr6_disruptor_loot.iff`, which is registered in our tree at
`object/weapon/ranged/rifle/rifle_tenloss_dxr6_disruptor_loot.lua:137`. It currently duplicates E5's
target.

```
-   targetTemplate = "object/weapon/ranged/rifle/som_rifle_mustafar_disruptor.iff",
+   targetTemplate = "object/weapon/ranged/rifle/rifle_tenloss_dxr6_disruptor_loot.iff",
```

**E4.** `weapon_appearance_heavy_republic_flamer.lua` line 30 — `customObjectName = "Heavy Republic
Flamer"`. Live target is `.../heavy/som_republic_flamer.iff`. **We cannot use live's exact path**:
the client ships only `shared_som_republic_flamer_generic.iff`, so only the `_generic` server object
is registrable (`TemplateManager.cpp:456` resolves objects through `clientTemplateFileName`).
`_generic` is the same appearance and is the closest resolvable object. This one-word deviation from
live is deliberate and will be recorded in the census.

```
-   targetTemplate = "object/weapon/ranged/heavy/heavy_rocket_launcher.iff",
+   targetTemplate = "object/weapon/ranged/heavy/som_republic_flamer_generic.iff",
```

**E5.** `weapon_appearance_heavy_lava_cannon.lua` line 30 — `customObjectName = "Lava Cannon"`.
Current target `object/weapon/ranged/rifle/rifle_som_lava_cannon.iff` is registered **nowhere** in the
tree, so this schematic currently resolves to nothing at all. Same `_generic` reasoning as E4.

```
-   targetTemplate = "object/weapon/ranged/rifle/rifle_som_lava_cannon.iff",
+   targetTemplate = "object/weapon/ranged/heavy/som_lava_cannon_generic.iff",
```

**E6.** `../heavy_lava_cannon.lua` line 29 (the MAIN schematic, one directory up, in
`draft_schematic/weapon/`). It carries the same dead `rifle_som_lava_cannon.iff`. Note the other 12
SoM main schematics carry no `targetTemplate` at all — the minimal `:new {}` inherit form — so this
stray line is the odd one out.

```
-   targetTemplate = "object/weapon/ranged/rifle/rifle_som_lava_cannon.iff",
+   targetTemplate = "object/weapon/ranged/heavy/som_lava_cannon_generic.iff",
```

### Do NOT touch
- `object/custom_content/weapon/ranged/heavy/som_lava_cannon.lua` and `som_republic_flamer.lua` —
  both are stale mis-named copies (they register `heavy_rocket_launcher.iff` and
  `2h_sword_kashyyk.iff` respectively). Neither is included by any `serverobjects.lua`, so both are
  inert. **Do not delete them and do not include them.** They are being reported to Aaron, not fixed.
- Every other appearance schematic, and all 13 main SoM schematics other than `heavy_lava_cannon.lua`.
- Do not add, delete, or rename any file. Do not edit any `serverobjects.lua`.

---

## Definition of done

Exactly 8 lines changed across exactly 8 files. Reply with the 8 diffs.
