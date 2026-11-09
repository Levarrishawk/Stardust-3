-- Standalone patrol objectives from the DSRC training chain. The quest grants
-- and ground-quest signals belong to the eventual Stardust onboarding flow.
local ordMantell = require("screenplays.space.ord_mantell.ord_mantell_missions")

local function registerTrainingPatrol(questName)
	local className = "patrol_" .. questName
	local mission = ordMantell.missions["patrol:" .. questName][1]
	local pointName = string.match(mission.navPoints, ":(.+)$")
	local point = ordMantell.navPoints[pointName]

	_G[className] = SpacePatrolScreenplay:new {
		className = className,
		questName = questName,
		questType = "patrol",
		questZone = ordMantell.questZone,
		patrolPoints = {
			{patrolPointName = pointName, patrolNumber = 1, x = point.x, z = point.z, y = point.y, radius = mission.navRadius},
		},
	}

	registerScreenPlay(className, true)
end

registerTrainingPatrol("npe_training_1")
registerTrainingPatrol("npe_training_1b")
registerTrainingPatrol("npe_training_2b")
registerTrainingPatrol("npe_training_3a")
