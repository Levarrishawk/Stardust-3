# Chandrila bestiary and world population

## Sources and scope

The population combines [Chandrila](https://starwars.fandom.com/wiki/Chandrila)
and [Chandrila/Legends](https://starwars.fandom.com/wiki/Chandrila/Legends), as requested.
Sources establish names and ecological roles, not SWG appearances or combat statistics.
The mobile appearances below are approximations using existing server templates and
client models. No new client assets are required.

## Land wildlife

| Mobile | Species | Source mobile | Level | Approximation |
| --- | --- | --- | ---: | --- |
| `chandrila_squall` | Squall | `squall` | 6 | Existing squall model and profile |
| `chandrila_fecklen` | Fecklen | `mott` | 8 | Squat, peaceful herd animal |
| `chandrila_cairnmog` | Cairnmog | `bolma` | 19 | Large, horned reptilian grazer |
| `chandrila_ghorla` | Ghorla | `bol` | 29 | Four-legged riding-animal appearance; no new mount system |
| `chandrila_blackback` | Blackback | `peko_peko` | 14 | Bird-of-prey profile |
| `chandrila_bulabird` | Bulabird | `whisper_bird_female` | 15 | Walking bird; model does not reproduce a star-tipped beak |
| `chandrila_preepnob` | Preepnob | `lantern_bird` | 21 | Small bird proxy, scale 0.5; tree-canopy whistling is documented, bird anatomy is an implementation assumption |
| `chandrila_silverwing` | Unidentified avian | `lantern_bird` | 21 | Visual proxy for the Legends silver-winged bird; silver coloring is not guaranteed |

Source combat, XP, HAM, resistance, harvest and loot profiles are retained. New
mobile registrations provide custom names and separate social groups. Herbivore
diet flags are corrected locally to match the selected nonpredatory roles; blackbacks
retain the peko-peko carnivore profile. The custom wildlife is untamable, avoiding
source-species pet names and devices. The original source mobiles are unchanged.

Each species has a building-free dynamic group (spawn limit 9) and a destructible
lair (spawn limit 12). Existing warren, garbage, rocks and leaf lair objects are used.
The world group contains all sixteen encounters, with squalls and fecklen weighted
most heavily. Difficulty ranges are the source mobile's base level plus or minus two.
The eight destroy missions use the same lairs and ranges, with a minimum-level
ceiling of 27 so high-level groups can still receive missions.

These are ordinary terminal destroy missions. No hunting-permit mechanic or
wildlife-protection enforcement is implemented. Source lore describes restrictions
on hunting, but adding such enforcement would be a separate gameplay feature.

## Deferred fauna

- Marmal-fish, skor-fin, pearlshell and starleg are sea creatures, documented but
  not placed in land spawn groups or destroy missions. Aquatic models and placement
  support need verification before implementation.
- The Legends list also includes generic crustaceans, deferred with the aquatic fauna.
- Priprak is listed on the canon page, but a reliable body description and suitable
  existing model were not established. It is documented without inventing anatomy.

## Wiring and verification

`chandrila_regions.lua` now uses `chandrila_world`, replacing its active
`corellia_world` reference. The previously unregistered Chandrila group has been
replaced and registered. Hanna's existing no-spawn and no-build regions and the
world spawn limit of 2048 remain in place. No static city NPCs are changed.

Mobile, dynamic-lair, creature-lair, world-group and destroy-mission registrations
are included through the existing `serverobjects.lua` files. No C++, IDL, database,
network, Engine3 or client-asset changes are required.

On Debian, deploy the scripts and restart the server. Check startup logs for Lua
or template errors, travel outside Hanna, inspect all eight species and their lairs,
and verify terrain placement and the intended relative population. Test general
destroy missions at low and high/group levels, including accepting, spawning,
destroying, reward payment, aborting and repeated requests. Also verify scout hunt
missions can select the new world population.

The client may lack `lair_n` strings for the new Chandrila lair keys, as with the
other custom-world lairs. Mobile custom names are supplied server-side; destroy
mission/lair labels require in-client verification and may need corresponding
client localization entries. Client files have not been modified.
