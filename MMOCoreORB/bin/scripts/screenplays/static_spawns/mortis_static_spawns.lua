MortisStaticSpawnsScreenPlay = ScreenPlay:new
{
	numberOfActs = 1,
	screenplayName = "MortisStaticSpawnsScreenPlay",

	bankX = 0,
	bankY = 0,
	trainerRadius = 48,
	plateauHeight = 475,

	trainers = {
		"trainer_1hsword",
		"trainer_2hsword",
		"trainer_architect",
		"trainer_armorsmith",
		"trainer_artisan",
		"trainer_bioengineer",
		"trainer_bountyhunter",
		"trainer_brawler",
		"trainer_carbine",
		"trainer_chef",
		"trainer_combatmedic",
		"trainer_commando",
		"trainer_creaturehandler",
		"trainer_dancer",
		"trainer_doctor",
		"trainer_droidengineer",
		"trainer_entertainer",
		"trainer_imagedesigner",
		"trainer_marksman",
		"trainer_melee_defense",
		"trainer_medic",
		"trainer_merchant",
		"trainer_musician",
		"trainer_pistol",
		"trainer_polearm",
		"trainer_politician",
		"trainer_ranger",
		"trainer_ranged_defense",
		"trainer_rifleman",
		"trainer_scout",
		"trainer_shipwright",
		"trainer_smuggler",
		"trainer_squadleader",
		"trainer_tailor",
		"trainer_unarmed",
		"trainer_weaponsmith",
	},
}

registerScreenPlay("MortisStaticSpawnsScreenPlay", true)

function MortisStaticSpawnsScreenPlay:start()
	if (isZoneEnabled("mortis")) then
		self:spawnTrainers()
	end
end

function MortisStaticSpawnsScreenPlay:spawnTrainers()
	for i = 1, #self.trainers do
		local heading = (i - 1) * 360 / #self.trainers
		local angle = math.rad(heading)
		local x = self.bankX + self.trainerRadius * math.sin(angle)
		local y = self.bankY + self.trainerRadius * math.cos(angle)

		local pNpc = spawnMobile("mortis", self.trainers[i], 0, x, self.plateauHeight, y, heading, 0)
		if (pNpc ~= nil) then
			self:setMoodString(pNpc, "npc_imperial")
		else
			printLuaError("Mortis bank trainer failed to spawn: " .. self.trainers[i])
		end
	end
end
