# travel.tab — the shuttle/starport fare table with Kashyyyk

`travel.tab` is Stardust's own `datatables/travel/travel.iff` (the copy that ships in `stardust_03.tre`, 16 planets, unpacked with
`tools/quest_tables/tab_to_iff.py unpack`) plus one row and one column for `kashyyyk`. The Kashyyyk fares are SOE's
(`mtg_patch_023.tre` carries a `travel.iff` whose only Kashyyyk route is Corellia ↔ Kashyyyk at 4500 credits; every other
planet is 0, meaning no route) and the same-planet fare of 100 that every row in the table uses.

Why it exists: `PlanetManagerImplementation::loadTravelFares` reads `datatables/travel/travel.iff`, and a planet absent from
the table gets a fare of 0, which `PurchaseTicketCommand` rejects as "Invalid travel route specified." The compiled table is
not committed (compiled tables stay out of the repo): pack it with `tab_to_iff.py pack travel.tab travel.iff` and place it at
`bin/datatables/travel/travel.iff` on the server (loose files are found before the TREs), or into a Stardust TRE.
