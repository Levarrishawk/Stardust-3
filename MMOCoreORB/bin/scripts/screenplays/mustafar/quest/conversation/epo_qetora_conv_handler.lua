--[[
	Epo Qetora -- conversation handler for som_kenobi_historian_1,
	som_kenobi_historian_smuggler and som_kenobi_historian_2.

	The tree is in mobile/conversations/mustafar/som_kenobi_epo_qetora.lua, which
	carries the note on how it was reconstructed and on the four things the live
	tree corrected. This file only routes by quest stage, picks the quest variant,
	plays the gestures and fires the grant and reward hooks. All state lives in
	historianScreenPlay's persistent screenplay data on the player's ghost;
	nothing is kept here.

	WHICH VARIANT

	som_kenobi_historian_1 and som_kenobi_historian_smuggler are the same quest
	with one step swapped: _1 makes the player kill facility droids until a
	decryption key drops, the smuggler one has him crack the encryption himself on
	a 20-45 second timer.

	Live picks between them on ONE line:

	    som_kenobi_epo_qetora_condition_isSmuggler(player, npc)
	        return hasSkill(player, "class_smuggler_phase1_novice");

	It asks for the profession, not for the box that teaches slicing. This handler
	had it as combat_smuggler_slicing_01, which was inferred from the smuggler
	.qst's "with your skills, you will be able to crack it" message box -- what a
	.qst describes is not what the conversation tests. See CORRECTING THE TWO
	QUEST VARIANTS in the tree.

	The split is a condition inside live branches 55 and 62: the "Excellent!"
	pitch (s_164 / s_195) is the isSmuggler arm, the "Good!" pitch (s_170 / s_204)
	is the default. So the tree declares the DEFAULT screen as the option's
	destination and this handler redirects to the smuggler twin, which is the
	engine's own idiom (see cities/cantinas/bartender_conv_handler.lua).

	WHERE THE HOOKS FIRE

	Live fires each action one screen later than this file used to:

	    56 s_166 -> s_168  giveQuestSmuggler   58 s_172 -> s_174  giveQuest
	    63 s_199 -> s_202  giveQuestSmuggler   65 s_206 -> s_208  giveQuest
	    24 s_79  -> s_80   giveQuest2          29 s_98  -> s_100  giveQuest2
	    37 s_214 -> s_216  rewardAssault + finishQuest1   (and 39 / 41)
	    45 s_222 -> s_224  rewardAssault + finishQuest1   (and 47 / 49)
	     5 s_266 -> s_268  reward2 + rewardRifle          (and 7 / 9)
	    13 s_282 -> s_284  reward2 + rewardRifle          (and 15 / 17)

	So the grant is on the DIRECTIONS reply, not on the pitch, and the item is
	created on the closing screen, not on "Here we go". A player who reads the
	pitch and walks away has taken nothing.

	Live also has an intermediate `reward` = sendSignal("successDone") on the
	armor pick itself. historianScreenPlay does not model that .qst task step
	separately -- finishQuest1 does the whole close -- so there is no hook for it.

	NO LEVEL GATE

	Both .qst [list] blocks display Level 75, as cursed_shard_1's does -- but that
	number is a client-side display value in all three, and Menth Paul's real gate
	turns out to be 61, read off his own server-side conversation. Epo's live
	conversation defines seven conditions -- onQuest, isSmuggler, haveDisk,
	finishedQuestAll, finishedQuest1, onQuest2, rewardQuest2 -- and not one of
	them is a level test. There is no gate, and this is now read rather than
	inferred from his having no refusal line.

	THE ANIMATIONS

	64 screens carry gestures; two carry none. The six "Here we go" weapon screens
	take their npc:nod on the reward screen instead, and q2_reassure / q2_grant_curt
	are player-only beats. screenAnimations is keyed by DESTINATION screen, which
	is safe here because no screen has two inbound edges that disagree.

	%TU

	Twenty of the strings name the player. setDialogTextTU fills the token on the
	cloned screen; tokenScreens below is the list.

	WHAT IS NOT HERE

	The four rebuff screens, both decline screens and the brush-off end the
	conversation on their own and change no state -- the player can hail him again.
	Nothing in either .qst models an abandon, and Epo has no line for taking a
	quest back.
--]]

epo_qetora_conv_handler = conv_handler:new {}

epo_qetora_conv_handler.screenPlayName = "historianScreenPlay"

-- pitch screen -> the twin a smuggler is sent to instead; see WHICH VARIANT
epo_qetora_conv_handler.smugglerRedirect = {
	pitch_keen = "pitch_keen_smuggler",
	pitch_wry = "pitch_wry_smuggler",
}

-- every screen that hands out quest one, and which variant it hands out. These
-- are the DIRECTIONS screens, which is where live grants; see WHERE THE HOOKS FIRE.
epo_qetora_conv_handler.grantScreens = {
	directions_keen = "standard",
	directions_wry = "standard",
	directions_keen_smuggler = "smuggler",
	directions_wry_smuggler = "smuggler",
}

-- the two screens where he sets the player after the tablet pieces. The polite
-- chain ends one screen sooner than the curt one.
epo_qetora_conv_handler.grantsQuest2 = {
	q2_grant_polite = true,
	q2_curt_end = true,
}

-- closing screens, and the armor type the player asked for one screen earlier
epo_qetora_conv_handler.armorPick = {
	armor_warm_assault_end = "assault",
	armor_warm_battle_end = "battle",
	armor_warm_recon_end = "recon",
	armor_curt_assault_end = "assault",
	armor_curt_battle_end = "battle",
	armor_curt_recon_end = "recon",
}

-- closing screens, and the weapon he is handing over
epo_qetora_conv_handler.weaponPick = {
	weapon_warm_rifle_end = "rifle",
	weapon_warm_carbine_end = "carbine",
	weapon_warm_pistol_end = "pistol",
	weapon_curt_rifle_end = "rifle",
	weapon_curt_carbine_end = "carbine",
	weapon_curt_pistol_end = "pistol",
}

-- every screen whose leftDialog carries %TU; see %TU
epo_qetora_conv_handler.tokenScreens = {
	all_done = true,
	q2_offer = true,
	q2_brushoff = true,
	q2_snub = true,
	q1_turnin = true,
	q2_curt_end = true,
	q2_turnin = true,
	q2_thanks_curt = true,
	armor_warm_assault_end = true,
	armor_warm_battle_end = true,
	armor_warm_recon_end = true,
	armor_curt_assault_end = true,
	armor_curt_battle_end = true,
	armor_curt_recon_end = true,
	weapon_warm_rifle_end = true,
	weapon_warm_carbine_end = true,
	weapon_warm_pistol_end = true,
	weapon_curt_rifle_end = true,
	weapon_curt_carbine_end = true,
	weapon_curt_pistol_end = true,
}

epo_qetora_conv_handler.screenAnimations = {
	greeting                 = { { "npc", "greet" }, { "player", "greet" } },
	rebuff_busy              = { { "player", "dismiss" }, { "npc", "goodbye" } },
	rebuff_nofighter         = { { "player", "shake_head_no" }, { "npc", "apologize" } },
	rebuff_rude              = { { "player", "dismiss" }, { "npc", "taken_aback" } },
	intro_polite             = { { "player", "shrug_shoulders" }, { "npc", "bow5" } },
	intro_wry                = { { "player", "pose_proudly" }, { "npc", "thumbs_up" } },
	hook_keen                = { { "player", "yawn" }, { "npc", "nod_head_multiple" } },
	hook_bored               = { { "player", "yawn" }, { "npc", "apologize" } },
	decline_intro            = { { "player", "check_wrist_device" }, { "npc", "goodbye" } },
	pitch_keen               = { { "player", "rub_chin_thoughtful" }, { "npc", "clap_rousing" } },
	directions_keen          = { { "player", "nod" }, { "npc", "goodbye" } },
	pitch_keen_smuggler      = { { "player", "rub_chin_thoughtful" }, { "npc", "clap_rousing" } },
	directions_keen_smuggler = { { "player", "nod" }, { "npc", "goodbye" } },
	pitch_wry                = { { "player", "rub_chin_thoughtful" }, { "npc", "clap_rousing" } },
	directions_wry           = { { "player", "pose_proudly" }, { "npc", "goodbye" } },
	pitch_wry_smuggler       = { { "player", "rub_chin_thoughtful" }, { "npc", "clap_rousing" } },
	directions_wry_smuggler  = { { "player", "nod" }, { "npc", "goodbye" } },
	q1_progress              = { { "npc", "bow5" } },
	q1_progress_end          = { { "npc", "bow5" }, { "player", "goodbye" } },
	q1_turnin                = { { "npc", "offer_affection" }, { "player", "greet" } },
	q1_thanks_warm           = { { "player", "shrug_shoulders" }, { "npc", "rub_chin_thoughtful" } },
	q1_thanks_curt           = { { "player", "shrug_shoulders" }, { "npc", "rub_chin_thoughtful" } },
	reward_armor_warm        = { { "player", "refuse_offer_affection" }, { "npc", "nod_head_multiple" } },
	armor_warm_assault       = { { "npc", "nod" } },
	armor_warm_assault_end   = { { "player", "thumb_up" }, { "npc", "bow5" } },
	armor_warm_battle        = { { "npc", "nod" } },
	armor_warm_battle_end    = { { "player", "thumb_up" }, { "npc", "bow5" } },
	armor_warm_recon         = { { "npc", "nod" } },
	armor_warm_recon_end     = { { "player", "thumb_up" }, { "npc", "bow5" } },
	reward_armor_curt        = { { "npc", "nod_head_multiple" } },
	armor_curt_assault       = { { "npc", "nod" } },
	armor_curt_assault_end   = { { "player", "nod" }, { "npc", "bow5" } },
	armor_curt_battle        = { { "npc", "nod" } },
	armor_curt_battle_end    = { { "player", "nod" }, { "npc", "bow5" } },
	armor_curt_recon         = { { "npc", "nod" } },
	armor_curt_recon_end     = { { "player", "nod" }, { "npc", "bow5" } },
	q2_offer                 = { { "npc", "bow5" }, { "player", "greet" } },
	q2_brushoff              = { { "player", "shake_head_no" }, { "npc", "sigh_deeply" } },
	q2_snub                  = { { "player", "dismiss" }, { "npc", "laugh" } },
	q2_tablet_polite         = { { "npc", "explain" } },
	q2_figures_polite        = { { "npc", "nod" } },
	q2_decline_polite        = { { "player", "shake_head_no" }, { "npc", "sigh_deeply" } },
	q2_reassure              = { { "player", "nod" } },
	q2_grant_polite          = { { "player", "nod" }, { "npc", "bow5" } },
	q2_tablet_curt           = { { "npc", "explain" } },
	q2_figures_curt          = { { "npc", "nod" } },
	q2_decline_curt          = { { "player", "shake_head_no" }, { "npc", "sigh_deeply" } },
	q2_grant_curt            = { { "player", "point_to_self" } },
	q2_curt_end              = { { "player", "nod" }, { "npc", "bow5" } },
	q2_progress              = { { "npc", "bow5" } },
	q2_progress_end          = { { "npc", "bow5" }, { "player", "goodbye" } },
	q2_turnin                = { { "npc", "bow5" }, { "player", "greet" } },
	q2_thanks_warm           = { { "npc", "nod" } },
	q2_thanks_curt           = { { "player", "shrug_shoulders" }, { "npc", "shake_head_no" } },
	reward_weapon_warm       = { { "player", "thumb_up" }, { "npc", "nod" } },
	weapon_warm_rifle_end    = { { "npc", "bow5" }, { "player", "nod_head_once" } },
	weapon_warm_carbine_end  = { { "npc", "bow5" }, { "player", "nod_head_once" } },
	weapon_warm_pistol_end   = { { "npc", "bow5" }, { "player", "nod_head_once" } },
	reward_weapon_curt       = { { "player", "tap_foot" }, { "npc", "shake_head_no" } },
	weapon_curt_rifle_end    = { { "npc", "bow5" }, { "player", "nod_head_once" } },
	weapon_curt_carbine_end  = { { "npc", "bow5" }, { "player", "nod_head_once" } },
	weapon_curt_pistol_end   = { { "npc", "bow5" }, { "player", "nod_head_once" } },
	all_done                 = { { "npc", "bow5" }, { "player", "greet" } },
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
	local redirect = self.smugglerRedirect[screenID]

	-- Resolve the smuggler swap first: the gestures, the token and the hooks below
	-- all belong to the screen the player actually ends up seeing.
	if (redirect ~= nil and self:isSmuggler(pPlayer)) then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)
		local pSmugglerScreen = convoTemplate:getScreen(redirect)

		if (pSmugglerScreen ~= nil) then
			screen = LuaConversationScreen(pSmugglerScreen)
			screenID = redirect
		end
	end

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer
			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	local variant = self.grantScreens[screenID]

	if (variant ~= nil) then
		historianScreenPlay:startQuest1(pPlayer, variant == "smuggler")
	elseif (self.grantsQuest2[screenID]) then
		historianScreenPlay:startQuest2(pPlayer)
	elseif (self.armorPick[screenID] ~= nil) then
		historianScreenPlay:finishQuest1(pPlayer, self.armorPick[screenID])
	elseif (self.weaponPick[screenID] ~= nil) then
		historianScreenPlay:finishQuest2(pPlayer, self.weaponPick[screenID])
	end

	local clonedConversation = screen:cloneScreen()

	if (self.tokenScreens[screenID]) then
		clonedConversation:setDialogTextTU(CreatureObject(pPlayer):getFirstName())
	end

	return clonedConversation
end

-- Novice Smuggler. Live's condition is this one call and nothing else.
function epo_qetora_conv_handler:isSmuggler(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("class_smuggler_phase1_novice")
end
