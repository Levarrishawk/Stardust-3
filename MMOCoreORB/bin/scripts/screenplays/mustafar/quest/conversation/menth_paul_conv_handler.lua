--[[
	Menth Paul -- conversation handler for som_kenobi_cursed_shard_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_menth_paul.lua, which carries the note
	on how it was reconstructed from the shipped string table. This file only routes by quest
	stage and settles the price.

	All state lives in cursedShardScreenPlay's persistent screenplay data on the player's ghost;
	nothing is kept here.

	THE LEVEL GATE

	som_kenobi_cursed_shard_1.qst's [list] block says Level 75, and s_72 ("I wish you were more
	experienced... I could really use some help.") is the one string in the table that fits no
	other beat. So the gate is the .qst's number and the refusal is the shipped line -- neither is
	invented here.

	THE PRICE

	The .qst awards Bank Credits 0 and has no cost task: SOE's quest file does not model the sale
	at all, because on the retail client the shard changed hands in the conversation, not in the
	quest. The string table is where the prices live -- s_118 and s_161 both ask a thousand, s_121
	and s_185 drop to 500 -- so those two numbers come from SOE's own text.

	Four "you don't have the money on you" strings shipped (s_154, s_134, s_177, s_225), one per
	accept screen. That is SOE telling us the check exists, so it is implemented here: if the
	player cannot cover the price, the handler redirects from the accept screen to the matching
	no_money screen and the quest does not start. Redirecting out of runScreenHandlers is the
	engine's own idiom (see cities/cantinas/bartender_conv_handler.lua).

	The four "then take it for free" screens cost nothing -- he is desperate and gives up. A
	player who refuses to pay still ends up holding the shard, which is the point of the quest.

	Cash is spent before bank, matching how the rest of the codebase charges players.
--]]

menth_paul_conv_handler = conv_handler:new {}

menth_paul_conv_handler.screenPlayName = "cursedShardScreenPlay"

-- accept screen -> { price, screen to send instead when the player is short }
menth_paul_conv_handler.priced = {
	accept_1000  = { 1000, "no_money_1000" },
	accept_500   = {  500, "no_money_500" },
	accept_1000b = { 1000, "no_money_1000b" },
	accept_500b  = {  500, "no_money_500b" },
}

-- screens where he hands it over for nothing
menth_paul_conv_handler.free = {
	free_1000 = true,
	free_500 = true,
	free_1000b = true,
	free_500b = true,
}

function menth_paul_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = cursedShardScreenPlay:getStage(pPlayer)

	if (stage == 0) then
		if (CreatureObject(pPlayer):getLevel() < cursedShardScreenPlay.requiredLevel) then
			return convoTemplate:getScreen("too_low")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == cursedShardScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("finished")
	end

	-- the player is carrying the shard: s_136, and he refuses to take it back
	return convoTemplate:getScreen("in_progress")
end

function menth_paul_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local priced = self.priced[screenID]

	if (priced ~= nil) then
		local price = priced[1]

		if (not self:takeCredits(pPlayer, price)) then
			local convoTemplate = LuaConversationTemplate(pConvTemplate)

			return convoTemplate:getScreen(priced[2])
		end

		cursedShardScreenPlay:startQuest(pPlayer)
	elseif (self.free[screenID]) then
		cursedShardScreenPlay:startQuest(pPlayer)
	end

	return screen:cloneScreen()
end

-- true only if the whole price was taken; nothing is deducted on failure.
function menth_paul_conv_handler:takeCredits(pPlayer, price)
	if (pPlayer == nil or price <= 0) then
		return true
	end

	local cash = CreatureObject(pPlayer):getCashCredits()
	local bank = CreatureObject(pPlayer):getBankCredits()

	if (cash + bank < price) then
		return false
	end

	if (cash >= price) then
		CreatureObject(pPlayer):subtractCashCredits(price)
	else
		CreatureObject(pPlayer):subtractCashCredits(cash)
		CreatureObject(pPlayer):subtractBankCredits(price - cash)
	end

	return true
end
