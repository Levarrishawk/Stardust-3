--[[
	Epo Qetora -- conversation handler for som_kenobi_historian_1,
	som_kenobi_historian_smuggler and som_kenobi_historian_2.

	The tree is in mobile/conversations/mustafar/som_kenobi_epo_qetora.lua, which
	carries the note on how it was reconstructed from the shipped string table.
	This file only routes by quest stage, picks the quest variant, and fires the
	grant and reward hooks. All state lives in historianScreenPlay's persistent
	screenplay data on the player's ghost; nothing is kept here.

	WHICH VARIANT

	som_kenobi_historian_1 and som_kenobi_historian_smuggler are the same quest
	with one step swapped: _1 makes the player kill facility droids until a
	decryption key drops, the smuggler one has him crack the encryption himself on
	a 20-45 second timer. The smuggler .qst's own message box says "with your
	skills, you will be able to crack it given a little time", so the thing that
	picks between them is slicing skill, and nothing else in either file is
	different.

	The string table already carries both: each of the two intros ends in an
	"Excellent!" pitch (s_164, s_195) and an otherwise identical "Good!" pitch
	(s_170, s_204). Two identical pitches per intro only exist because there were
	two quests to grant. The "Good!" pair is bound to the *_slice screens here.

	combat_smuggler_slicing_01 is the gate -- the first box that actually teaches
	slicing, and the same single check geoLabMenuComponents.lua:109 uses to decide
	whether a player can slice a panel. corellianCorvette.lua:1156 scores the whole
	tree because it wants a difficulty number; here it is a yes or no.

	Redirecting out of runScreenHandlers is the engine's own idiom (see
	cities/cantinas/bartender_conv_handler.lua), so the player is sent to the
	*_slice screen and the smuggler quest is granted in the same step.

	NO LEVEL GATE

	Both .qst [list] blocks say Level 75, as cursed_shard_1's does. The difference
	is that Menth Paul's table shipped a refusal line for an under-levelled player
	(s_72) and Epo's does not: there is no string in som_kenobi_epo_qetora.stf that
	turns anyone away for being inexperienced. A gate here would need a line this
	arc never shipped, so there is none.

	WHAT IS NOT HERE

	The four rebuff screens, both decline screens and the brush-off end the
	conversation on their own and change no state -- the player can hail him again.
	Nothing in either .qst models an abandon, and Epo has no line for taking a
	quest back.
--]]

epo_qetora_conv_handler = conv_handler:new {}

epo_qetora_conv_handler.screenPlayName = "historianScreenPlay"

-- pitch screen -> the twin the smuggler variant is bound to; see WHICH VARIANT
epo_qetora_conv_handler.sliceRedirect = {
	pitch_keen = "pitch_keen_slice",
	pitch_wry = "pitch_wry_slice",
}

-- every screen that hands out quest one, and which variant it hands out
epo_qetora_conv_handler.pitchScreens = {
	pitch_keen = "standard",
	pitch_wry = "standard",
	pitch_keen_slice = "smuggler",
	pitch_wry_slice = "smuggler",
}

-- the two screens where he sets the player after the tablet pieces
epo_qetora_conv_handler.grantsQuest2 = {
	q2_grant_polite = true,
	q2_grant_curt = true,
}

-- reward screens, and the armor type the player just asked for
epo_qetora_conv_handler.armorPick = {
	armor_warm_assault = "assault",
	armor_warm_battle = "battle",
	armor_warm_recon = "recon",
	armor_curt_assault = "assault",
	armor_curt_battle = "battle",
	armor_curt_recon = "recon",
}

-- reward screens, and the weapon he is handing over
epo_qetora_conv_handler.weaponPick = {
	weapon_warm_rifle = "rifle",
	weapon_warm_carbine = "carbine",
	weapon_warm_pistol = "pistol",
	weapon_curt_rifle = "rifle",
	weapon_curt_carbine = "carbine",
	weapon_curt_pistol = "pistol",
}

function epo_qetora_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = historianScreenPlay:getStage(pPlayer)

	if (stage == historianScreenPlay.STAGE_Q1) then
		return convoTemplate:getScreen("q1_progress")
	elseif (stage == historianScreenPlay.STAGE_Q1_TURNIN) then
		return convoTemplate:getScreen("q1_turnin")
	elseif (stage == historianScreenPlay.STAGE_Q1_DONE) then
		-- s_216, the line that closes quest one: "I've got another lead I need
		-- help with." He opens with the second offer from here on.
		return convoTemplate:getScreen("q2_offer")
	elseif (stage == historianScreenPlay.STAGE_Q2) then
		return convoTemplate:getScreen("q2_progress")
	elseif (stage == historianScreenPlay.STAGE_Q2_TURNIN) then
		return convoTemplate:getScreen("q2_turnin")
	elseif (stage == historianScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("all_done")
	end

	return convoTemplate:getScreen("greeting")
end

function epo_qetora_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local redirect = self.sliceRedirect[screenID]

	if (redirect ~= nil and self:canSlice(pPlayer)) then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)
		local pSliceScreen = convoTemplate:getScreen(redirect)

		if (pSliceScreen ~= nil) then
			historianScreenPlay:startQuest1(pPlayer, true)

			return pSliceScreen
		end
	end

	local variant = self.pitchScreens[screenID]

	if (variant ~= nil) then
		historianScreenPlay:startQuest1(pPlayer, variant == "smuggler")
	elseif (self.grantsQuest2[screenID]) then
		historianScreenPlay:startQuest2(pPlayer)
	elseif (self.armorPick[screenID] ~= nil) then
		historianScreenPlay:finishQuest1(pPlayer, self.armorPick[screenID])
	elseif (self.weaponPick[screenID] ~= nil) then
		historianScreenPlay:finishQuest2(pPlayer, self.weaponPick[screenID])
	end

	return screen:cloneScreen()
end

-- Slicing I. The .qst variant only asks whether the player can crack encryption
-- at all, so this is a yes or no rather than corellianCorvette's skill score.
function epo_qetora_conv_handler:canSlice(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("combat_smuggler_slicing_01")
end
