--[[
	MOVED -- this handler is now keslev_conv_handler.lua in this same folder.

	The NPC is Surveyor Keslev. There is no "Jo" in his name: all seven shipped quest
	journals -- som_exploration_{berken,burning,crystal,mining,smoking,tulrus,volcano}.stf
	-- say "Surveyor Keslev has asked you to...". The middle name came from the wiki, and
	the surname was misspelt on top of it. Live's own spawn table row names the mobile
	som_surveyor_keslev.

	The file is kept rather than removed because this repo does not delete files. It is no
	longer in screenplays.lua and defines nothing, so it loads as a no-op. Nothing should
	reference jo_kelsev or jo_kelsev_conv_handler; if a grep finds one, it is stale.
--]]
