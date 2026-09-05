--[[
	Collection badge bridge — OURS (the java has no Core3 badge_map).

	NGE player_collection.java:29 returns immediately for bookName == badge_book
	(the native collection slot IS the badge). Core3 badges live in
	datatables/badge/badge_map.iff (BadgeList.cpp loadData) and are exported to
	Lua as uppercase globals equal to the badge index (DirectorManager.cpp
	badge-key walk). Completing a badge_book slot whose name matches a badge
	key awards that badge via PlayerObject:awardBadge. The other direction:
	BADGEAWARDED is not used (player_collection.java has no awardBadge observer);
	a LOGGEDIN observer registered once syncs already-earned badges into the
	matching badge_book slots so exploration badges show in the browser.

	Runtime lookup: CollectionBadges.badgeIdForSlot(slotName) -> _G[SLOT:upper()].
]]

CollectionBadges = CollectionBadges or {}

CollectionBadges.LOGIN_PLAY = "CollectionBadgeBridge"
CollectionBadges.LOGIN_KEY = "onLoggedIn"

function CollectionBadges.badgeIdForSlot(slotName)
	if slotName == nil or slotName == "" then
		return nil
	end

	local id = _G[string.upper(slotName)]
	if type(id) == "number" then
		return id
	end

	return nil
end

CollectionBadgeBridge = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionBadgeBridge",
}

registerScreenPlay("CollectionBadgeBridge", true)

function CollectionBadgeBridge:start()
	if PlayerTriggers == nil or PlayerTriggers.playerLoggedIn == nil then
		return
	end

	if CollectionBadgeBridge.loginWrapped == true then
		return
	end

	CollectionBadgeBridge.loginWrapped = true
	local previous = PlayerTriggers.playerLoggedIn

	function PlayerTriggers:playerLoggedIn(pPlayer)
		previous(self, pPlayer)
		CollectionBadgeBridge:ensureLoginObserver(pPlayer)
	end
end

-- PlayerObjectImplementation.cpp notifies LOGGEDIN after PlayerTriggers, so
-- registering here (persist=1) fires the same login and every login after.
function CollectionBadgeBridge:ensureLoginObserver(pPlayer)
	if pPlayer == nil then
		return
	end

	if hasObserver(LOGGEDIN, CollectionBadges.LOGIN_PLAY, CollectionBadges.LOGIN_KEY, pPlayer) then
		return
	end

	createObserver(LOGGEDIN, CollectionBadges.LOGIN_PLAY, CollectionBadges.LOGIN_KEY, pPlayer, 1)
end

function CollectionBadgeBridge:onLoggedIn(pPlayer, pPlayer2, arg2)
	CollectionManager.syncBadgesOnLogin(pPlayer)
	return 0
end
