# ROUND F1(b) — where the two Mustafar battlefields anchor

Status: **DECIDED, from measured data.** Written 2026-09-01.
This file is an instruction file for me. It records the anchors, the evidence
behind them, and one defect the study uncovered that blocks Chapter Three 01.

---

## THE DECISION

    VALLEY BATTLEFIELD   anchor (x =  600, y = -1600)   box 335 x 395 m
    VOLCANO ARENA        anchor (x = -292, y = -1680)   box 380 x 420 m

Both sit off-map in the empty southern band, are entered by teleport, and are
left by teleport. That is the same model `mustafar_instances.lua` already uses
for the six SOE dungeon pools, and the same model SOE itself uses on this planet.

Ground height at both anchors is **exactly -5.00 m**, measured, dead flat.

⚠ **The volcano anchor was CORRECTED on 2026-09-02, during round F2(b). It used to read
(-400, -1600).** The box size was right — live's volcano arena spans 379.97 m by 419.47 m once
the trigger-volume radii are counted — but this file assumed the anchor was the box **centre**,
and live's arena is not centred on its own controller. Anchoring the controller at (-400, -1600)
threw the footprint to x -698..-318, y -1730..-1310: 108 m west and 80 m north of the box this
study actually measured with its 81-sample fine grid.

Moving the anchor to **(-292, -1680)** lands the footprint inside the measured box instead:

    measured box     x -590.000 .. -210.000    y -1810.000 .. -1390.000
    true footprint   x -589.909 .. -209.941    y -1809.941 .. -1390.469

The east rim of HK's 95 m volume sits at x = -209.941 — six centimetres outside the nominal box.
That is not fudged away: the box was sampled on a 50 m grid and the whole southern band measures
-5.00 m flat across x -1400..1400, so six centimetres is inside the measurement's own granularity.

**The box is not amended; only the anchor moved.** All 126 boundary active areas in
`mustafar_boundaries.lua` were re-checked against the corrected footprint and the exit — clear,
nearest margins 736 m at the anchor and 218 m at the exit. Verifier: `C:\tmp\volc-bound-check.sh`,
validated first against this file's own independently-computed 736.3 m and 914.0 m before its
verdict on anything new was trusted.

---

## WHY OFF-MAP AND NOT IN THE WALKED WORLD

Both battlefields are instances in live: `instance_datatable.tab` gives them max
8 players, a 3600 s limit, a daily lockout and a required key. Core3 has no
instance system for outdoor areas, so the choice was where to translate them onto
the Mustafar ground zone.

A file-only placement study ranked the best *object-free* space in the walked
world and returned (0, 950) and (-500, 1300). **A boot probe measured those two
spots and they are mountainsides.** That is why this was measured and not
reasoned:

    INWORLD_A  (0, 950)      25 samples over 300 x 300 m   height spread  170.4 m
    INWORLD_B  (-500, 1300)  25 samples over 300 x 300 m   height spread  316.4 m

Free of objects, yes. Buildable, no. Neither could hold a flat battlefield.

The southern band is the opposite:

    y = -1400   15 samples across x -1400..1400   spread 0.00   all -5.00
    y = -1600   15 samples                        spread 0.00   all -5.00
    y = -1800   15 samples                        spread 0.00   all -5.00
    y = -2000   15 samples                        spread 0.00   all -5.00
    y = -2200   15 samples                        spread 0.00   all -5.00
    y = -1200   15 samples                        spread 6.05   (transition)
    y = -1000   15 samples                        spread 789.01 (mountains)

    VALLEY  fine grid, 81 samples over 400 x 400 m at 50 m   spread 0.000 m
    VOLCANO fine grid, 81 samples over 400 x 400 m at 50 m   spread 0.000 m

-5.00 is the base plane of the Mustafar terrain, and it is exactly the height SOE
placed its own off-map content at: `monster_lair`, `old_republic_facility`,
`uplink_cave` and `lair_of_the_crystal` are all at h = -5.00 in the snapshot.
Putting open-air battlefields on that plane is not a novel idea, it is the plane
SOE already builds off-map content on.

Flatness is a feature here, not a compromise. Live's volcano instance has 0.62 m
of relief across its whole buildout (LIVE-VOLCANO §6.1) — it is a flat arena. The
valley brings its own scenery: 22 tangibles are already registered for it and
live's stage 1 places 32 camp props.

## THE FREE BAND, FROM GROUND TRUTH

`snapshot/mustafar.ws` out of `stardust_03.tre` — the snapshot the server loads —
was parsed directly (5947 nodes, 354 templates). The parser was validated against
two node IDs the repo documents by hand and both matched exactly:

    12110161 ORF door       measured x=-775.93 h=89.14 y=6088.28   repo: identical
    12110143 sherkar door   measured x=-2077.07 h=87.16 y=4276.08  repo: identical

All off-map content on Mustafar, complete:

    y = -2745.18   9 copies   decrepit_droid_factory    x -6753.41 .. -1853.41
    y = -3745.18  12 copies   working_droid_factory     x -6753.41 ..   946.59
    y = -4746.16  12 copies   old_republic_facility     x -6748.81 ..   951.18
    y = -5746.90  12 copies   monster_lair              x -6744.16 ..   955.84
    x =  6748.99  12 copies   lair_of_the_crystal       y  -745.46 ..  6954.54
    x =  5947.36   9 copies   uplink_cave               y  1355.33 ..  6255.33

`monster_lair` had no coordinates anywhere in the repo and was the one thing that
could have collided with this band. It is at y = -5746.90 — 4100 m clear.

The boundary wall was parsed out of `mustafar_boundaries.lua`: 126 active areas,
x -6700..813, y -731..6640. Its southern edge reaches y = -987.0 (So10, y=-731,
r=256). The decrepit row's declared radius is 512, so it reaches y = -2233.2.

    FREE BAND   y -2233.2 .. -987.0    1246.2 m tall    empty at every x

Margins for the two boxes:

    VALLEY  (600,-1600)  box x 432.5..767.5  y -1797.5..-1402.5
            435.7 m to the band's south edge, 415.5 m to its north edge
            914.0 m to the nearest boundary-area edge
    VOLCANO (-292,-1680) box x -590.0..-210.0 y -1810.0..-1390.0
            423.2 m to the band's south edge, 403.0 m to its north edge
            736.3 m to the nearest boundary-area edge
            (anchor corrected 2026-09-02 -- see THE DECISION. The BOX is
             unchanged, so every margin on these three lines still holds;
             only the controller's position inside the box moved.)

    separation 1000 m vs combined half-diagonals 259 + 283 = 542
    -> the two boxes clear each other by 458 m

## HOW THE HEIGHTS WERE MEASURED

`bin/terrain/mustafar_height.tga` exists but the repo records no scale, origin or
orientation for it and nothing references it, so it cannot be projected. The only
height source is `getWorldFloor(x, y, zone)` on a running server.

A temporary probe screenplay was installed **into the WSL build tree only** —
never into the git tree — and the server was booted (READY in 40 s, 969 log
lines, 322 samples). The probe was then backed out: `screenplays.lua` restored
from a pristine copy and the probe renamed to `.retired`, not deleted.

Five reference points with independently recorded heights validate the sampling:

    REF_koseyet   (168.5, -205.7)   measured 128.163   recorded 127.989   +0.17 m
    REF_factory   (516, 1990)       measured  64.549   recorded  64       +0.55 m
    REF_orfexit   (-771.6, 6082.8)  measured  87.098   ORF door h 89.14   -2.04 m
                                    (the exit is stepped 7 m off the door)
    REF_scoutpost (550, -154)       measured 192.871   .qst LocationY 157
    REF_mensix    (-2471, 1620)     measured 100.684   travel point z 230

Two land inside a metre and a third is consistent once the 7 m offset is allowed
for. The last two disagree with their records; both records are nominal heights
(a waypoint height and a travel-point height), neither is a terrain measurement,
and waypoints do not use height. Nothing depends on those two.

Note honestly: the probe scheduled a second pass via `createEvent` to cross-check
that terrain resolves during `startManagers`. **It never fired** — 322 PASS1
samples, 0 PASS2. So the two-pass check did not do its job; what validates PASS1
is the reference-point agreement above, not the second pass.

Still unverified: what the -5.00 plane *looks like*. Height and flatness are
measured; the ground shader is not, and cannot be from the server side.

---

## DEFECT FOUND — Chapter Three 01 is unreachable

This was not what the study was looking for and it blocks the valley's entry
point, so it is recorded here rather than lost.

`story_arc_chapters.lua:650` puts the scout post at (550, -154). That is SOE's
own coordinate and three independent records agree on it:

    story_arc_chapters.lua:650                 x 550, y -154
    the .qst quoted at :642-643                LocationX 550 LocationZ -154
    LIVE-VALLEY.md:911 instance exit_one       541, 155, -160, mustafar

The boundary wall covers it. Measured, not inferred:

    Se1  centre (587, -196)  r 256   distance to scout  55.97 m   INSIDE
    Se2  centre (448, -404)  r 275   distance to scout 270.01 m   INSIDE

`mustafar_boundaries.lua:162-171` and `:173-182` place both; `:1568-1585`
`notifySpawnAreaSe` teleports any non-AI creature entering them to (197,121,-214).
It returns early only for `isAiAgent()`, so Scout Olon Lono stands there fine and
the player is thrown out before reaching him. `mustafar_boundaries:start()` is
unconditional on `isZoneEnabled("mustafar")` and `screenplays.lua:830` includes
it, so this is live.

`spawnDroidArmy()` at `story_arc_chapters.lua:2194-2204` spawns the marching army
at `scoutPost.x + 10 + index*3`, i.e. x 563..581, y -144 — also inside Se1.

The teleport target (197, -214) is itself clear of all five nearby areas, so the
player is bounced to a valid spot and can simply never approach the scout.

The wall is not SOE's. Its own header says "Boundaries for mustafar_mustafar_main
terrain Layer by Levarris". These active areas are spheres, so each one projects
its full radius *inward* as well as outward — the ring carries a 256 m apron over
legitimate playable ground everywhere it runs. The scout post is the one piece of
authored content that falls in that apron.

Not yet fixed. Options, none of them applied:
  (a) move the scout — abandons SOE's coordinate, which three records confirm
  (b) shrink Se1/Se2 — opens a hole in the map wall
  (c) move Se1/Se2 outward along the wall normal so the apron clears the scout
      while the ring stays continuous with Se3 and Ea24
(c) is the only one that keeps both SOE's coordinate and the wall's purpose, and
it needs the ring re-checked for continuity after the move.
