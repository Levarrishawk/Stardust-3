# Nal Hutta bestiary and world population

## Sources and scope

The population draws from [Nal Hutta](https://starwars.fandom.com/wiki/Nal_Hutta),
[Nal Hutta/Legends](https://starwars.fandom.com/wiki/Nal_Hutta/Legends),
[Creatures of Nal Hutta](https://starwars.fandom.com/wiki/Category:Creatures_of_Nal_Hutta),
and [Evocii](https://starwars.fandom.com/wiki/Evocii).
These sources establish the species and setting, not SWG statistics or appearances.
The scripts use existing repository appearances and combat profiles as approximations.
No client assets, persistent fields, C++, IDL, or Engine3 changes are required.

## Wildlife

| Mobile registration | Appearance stand-in | Base level | Role |
| --- | --- | ---: | --- |
| `chemilizard` (existing) | Bolotaur | 27 | Polluted-swamp reptile |
| `dragonsnake` (existing) | Vog eel, scale 4 | 215 | Dangerous swamp predator |
| `xuuva` (existing spelling; lore: Xuvva) | Mynock | 100 | Flying predator |
| `hutta_anooba` | Langlatch | 14 | Pack predator; langlatch combat profile |
| `hutta_akk_dog` | Voritor lizard | 22 | Reptilian pack predator; voritor statistics with melee attacks |
| `hutta_whirlbat` | Gackle bat | 10 | Flying wildlife; gackle bat combat profile |
| `hutta_navora_frog` | Chuba | 5 | Small, non-aggressive amphibian |
| `hutta_slime_pod` | Gorg, scale 0.75 | 6 | Non-aggressive swamp forage; approximate body only |
| `hutta_marsh_spider` | Hermit spider | 7 | Generic swamp spider; hermit spider combat profile |
| `hutta_bog_rodent` | Stintaril | 8 | Generic diseased swamp rodent; diseased vrelt combat profile |

Marsh spider and bog rodent are descriptive encounter names, not claims of named
lore species. All new wildlife is untamable; harvest and loot profiles follow its
source mobile. Slime pods do not float with this appearance or server AI. Fire-krakens
and Sha'rellian toops are source-listed bestiary candidates left unimplemented because
no convincing, verified mobile stand-in was identified for their body plans.

Each new species has a building-free dynamic group. Anoobas, akk dogs, whirlbats,
and navora frogs also have destructible lairs using existing warren, bramble, or leaf
lair objects. Lairs have a total spawn limit of 12; dynamic wildlife groups use 9.
World difficulty ranges of 3–7 follow existing encounter conventions and are separate
from the mobiles' base combat levels.

## Denizens

| Mobile | Existing profile/appearance | Behavior |
| --- | --- | --- |
| `hutta_pirate` | Marooned pirate; mixed Bith, human, Nikto, Rodian, Trandoshan | Aggressive pirate patrol member |
| `hutta_pirate_captain` | Marooned pirate captain | Aggressive pirate leader |
| `hutta_spice_smuggler` | Smuggler; dressed human criminal slicer | Attackable smuggler |
| `hutta_cartel_enforcer` | Jabba enforcer | Cartel muscle; retains Jabba faction behavior |
| `hutta_weequay_ruffian` | Weequay thug | Attackable gang member |
| `hutta_evocii_refugee` | Farmer; dressed human commoner/farmer | Peaceful, non-attackable refugee |

Dynamic NPC groups comprise pirate patrols, guarded spice smugglers, cartel patrols
with existing Gamorrean guards, Weequay gangs, and Evocii refugees. NPC groups use
`mobType = "npc"` and building-free dynamic lairs. Combat groups use a total spawn
limit of 9 and difficulty 3–7. Refugees use limit 6 and difficulty 2–4.

Evocii are a deliberate server setting extension: small returning refugee groups,
not an assertion that their ancient rebel tribes survived on Nal Hutta into the
Galactic Civil War. Human models approximate their humanoid build but cannot reproduce
their distinctive noses. Their peaceful groups are separate from criminals.
Existing weapon, skill, loot, and faction profiles are reused without new faction
definitions or reward systems.

## Registration and regions

`mobile/hutta/serverobjects.lua` loads new mobiles. The creature dynamic, creature
lair, and NPC dynamic loaders register the associated lairs. The spawn loader now
includes `spawn/hutta_world.lua`; it also registers the three pre-existing Hutta
dynamic wildlife lairs through the creature dynamic loader.

`managers/planet/hutta_regions.lua` enables the existing world region with
`{"hutta_world"}` and its existing 2048 spawn cap. Bilbousa's city exclusions remain
intact. Existing Hutta world encounters, including high-level Force-user encounters,
remain in the group with their previous settings. The commented-out `global_hard`
group is not enabled. New entries dilute the relative frequency of existing encounters.

## Verification on Debian and in the client

Deploy the changed Lua files together and restart the server so loaders and regions
are reread. No generated interface refresh or clean rebuild is required by these Lua
changes. If building as part of deployment, use the normal Debian `make -j$(nproc)`.

1. Run `luac -p` over the changed/new Lua files on Debian, then start under GDB and
   check for missing mobile, lair, appearance, weapon, loot, or spawn-group errors.
2. Visit Hutta outside Bilbousa and verify dynamic wildlife and each NPC group appears.
3. Confirm city exclusions, terrain placement, water behavior, collision, and pathing.
   Coordinate-free world spawning uses the existing engine placement system; actual
   Hutta terrain suitability still requires client testing.
4. Fight pirates and cartel patrols, check faction behavior and ordinary loot, and
   confirm Evocii refugees remain non-attackable.
5. Destroy the new lairs and observe their spawn waves and cleanup. Revisit areas
   after respawns/restart and check for duplicated or stranded encounters.
6. Review encounter density and the existing level-215 dragonsnake/level-100 Xuvva
   alongside the lower-level additions; their original combat statistics were preserved.
