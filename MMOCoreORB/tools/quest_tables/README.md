# quest_tables — compile the NGE-style quest journal tables from a local source (R16)

The server's task journal (`PlayerObject:activateJournalQuest`, `getQuestTasks`) reads `datatables/questtask/quest/<name>.iff`;
the retail client reads the same plus `datatables/questlist/quest/<name>.iff`. Stardust's TREs ship the CRC table and the
strings for ~1,600 ground quests but the two table files for only 27, so new quests (Mustafar's 76, the Meatlump chain's 13)
need their tables delivered: server side as loose files under `MMOCoreORB/bin/datatables/` (a loose file shadows the TRE,
`DataArchiveStore.cpp:20-46`; `questTasksCache` is never invalidated, so a changed table needs a full restart), client side
through a `searchPath_00_N=<dir>` overlay in `swgemu_live.cfg` (priorities 49-59 are free).

Ruling (ruling 2026-09-04): the compiled tables are SOE data and do not live in the repo. This directory holds the
compiler (`tab_to_iff.py`, round-trips all 2,077 shipped datatables byte-identically) and `build_quest_tables.py`, which
builds and verifies the tables from your local source. The built files are git-ignored by their location.
