-- Boshaz Zssik -- the Zssik clan's recruiter on Kashyyyk, and the door into the whole Trandoshan arc.
-- The repo mobile is named ep3_boshaz; the client conversation file is
-- ep3_trandoshan_boshaz_zssik_01. Both spellings are kept as they ship.
--
-- Giver for escort/ep3_trando_boshaz_zssik_01 (KashyyykSlaverScreenplay.lua, registered line 624).
-- Before this file nothing in the repo gave that quest out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_trandoshan_boshaz_zssik_01.stf (80 entries). Nothing is authored.
--
-- The arc matches the screenplay field for field: s_733 "I have a slave ship that needs to be
-- protected on its way to the Avatar Space Platform" is escortShips = {"trn_slaver_barge_tier4"};
-- s_737 "meet my ship in orbit above Kashyyyk. Escort it until it reaches the Avatar zone of
-- control" is questZone space_kashyyyk with escortPoints boshaz_escort_1..5; and s_623/s_627 -- "When
-- I reported your position to the Wookiee resistance I was sure that you would be quickly destroyed"
-- -- is the screenplay's own attackShips, which are wke_resist_tier3/4/5. The escort being a set-up
-- is the client's plot point, not an accident of the wave table.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order.
--
-- FLAGGED INTERPRETATION -- ONE REUSED OPTION KEY. s_657 ("I will take the job. What do I need to do?")
-- is used on both s_655 and s_701, because s_701 ("A patsy knows nothing...") is a shipped answer
-- with no shipped follow-up of its own and it lands the player at the same point in the pitch.
-- The key is shipped text; using it twice is the interpretation.
--
-- GROUND LEG NOT ENFORCED. After the escort, the whole Zssik pitch ends in a GROUND task: rescue
-- Chawroo from the Blackscale patrol northwest of here and get him to set up the meeting. There is
-- no Kashyyyk ground screenplay, no Kashyyyk ground spawn areas and no Chawroo mobile in this repo,
-- so that leg cannot be checked. The handler advances it one step per hail behind a single named
-- switch (BOSHAZ_GROUND_LEG_AUTO). The dialogue is client fact; that progression is not.
--
-- UNUSED SHIPPED KEYS: s_597 only (empty string in the client file).

ep3_boshaz_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_boshaz_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3BoshazConvoHandler",
	screens = {}
}

ep3_boshaz_greeting = ConvoScreen:new {
	id = "ep3_boshaz_greeting",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_725", --Greetings, offworlder. You have the look of someone who is in search of something. Whatever it is you seek, you should look elsewhere. I am not interested in holding the hand of a fledgling who has no business on this dangerous world.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_727", "ep3_boshaz_teeth"}, --I think you have me mistaken for someone else.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_greeting);

ep3_boshaz_teeth = ConvoScreen:new {
	id = "ep3_boshaz_teeth",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_729", --Oh, so the fledgling thinks it has teeth. How interesting. I am not certain that you are worth my time but I am looking for someone who can perform some small...tasks for me. Perhaps you would wish to fill that role?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_731", "ep3_boshaz_task"}, --Keep talking scaly.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_741", "ep3_boshaz_no_thanks"}, --No thanks. I am not interested.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_teeth);

ep3_boshaz_task = ConvoScreen:new {
	id = "ep3_boshaz_task",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_733", --It is a simple task. So simple that I think even a young whelp such as yourself should be able to perform it. You see, I have a slave ship that needs to be protected on its way to the Avatar Space Platform. If you believe that you have the skills, perhaps you would be so kind to make sure it reaches its destination in one piece.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_735", "ep3_boshaz_escort_accept"}, --For me, that isn't even a challenge.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_739", "ep3_boshaz_no_thanks"}, --No, I don't think I want to do that right now.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_task);

-- The grant happens in the handler on this screen id.
ep3_boshaz_escort_accept = ConvoScreen:new {
	id = "ep3_boshaz_escort_accept",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_737", --Brave words. Very well...meet my ship in orbit above Kashyyyk. Escort it until it reaches the Avatar zone of control. When and if you finish, report back to me and perhaps I will have some more work for you to do.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_escort_accept);

ep3_boshaz_no_thanks = ConvoScreen:new {
	id = "ep3_boshaz_no_thanks",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_743", --Of course, fledgling. I would not want you to put yourself in any danger. Perhaps you will find work dancing in one of the local cantinas.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_no_thanks);

-- Escort running.
ep3_boshaz_busy = ConvoScreen:new {
	id = "ep3_boshaz_busy",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_723", --You are a busy little fledgling. I have no time for someone who already has work to be done. I do have a job that is in need of a good star pilot. Finish up with what you are tasked with and then...perhaps...I will talk with you.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_busy);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_713 "is the fledgling nothing more then a
	braggart" is written for a player who took the escort and lost it. SpaceEscortScreenplay leaves
	no distinguishable failure record the conversation can read, so this handler cannot separate
	"lost the shuttle" from "walked away": it shows this arc to anyone who once accepted and no
	longer has the quest active or complete. The text is client fact; that trigger is not.
]]
ep3_boshaz_escort_failed = ConvoScreen:new {
	id = "ep3_boshaz_escort_failed",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_713", --Ah, is the fledgling nothing more then a braggart or did you simply have a bad day?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_715", "ep3_boshaz_escort_retry"}, --I just had an off day. I can do your task.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_719", "ep3_boshaz_escort_quit"}, --I cannot accomplish what you asked of me.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_escort_failed);

-- Re-grant happens in the handler on this screen id.
ep3_boshaz_escort_retry = ConvoScreen:new {
	id = "ep3_boshaz_escort_retry",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_717", --Really? Well it is time to put your money where your mouth is. I have another ship that is on its way to the Avatar. Maybe you can get this one through. Or maybe you are just wasting my time and the lives of my pilots. Well...what are you waiting for? Get going.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_escort_retry);

ep3_boshaz_escort_quit = ConvoScreen:new {
	id = "ep3_boshaz_escort_quit",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_721", --Not surprising. I never thought that you would.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_escort_quit);

-- Escort survived. He admits he tipped off the resistance, then makes the real pitch.
ep3_boshaz_setup = ConvoScreen:new {
	id = "ep3_boshaz_setup",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_623", --I am surprised. I honestly did not believe that you had even an inkling of skill in you. When I reported your position to the Wookiee resistance I was sure that you would be quickly destroyed. You have proven to be quite a little scrapper.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_625", "ep3_boshaz_offer"}, --You told the Wookiee resistance about the escort?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_setup);

ep3_boshaz_offer = ConvoScreen:new {
	id = "ep3_boshaz_offer",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_627", --Of course I did. I couldn't very well test your prowess if you were not attacked. Allow me to compensate you for any damage that the attack might have caused to your vessel. My clan has no need for anyone who cannot handle themselves under fire. If you are interested I have a job for you to do.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_629", "ep3_boshaz_trust"}, --So why should I trust you after you set me up?
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_709", "ep3_boshaz_refuse"}, --No thanks. I don't work for people who set me up.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_offer);

ep3_boshaz_refuse = ConvoScreen:new {
	id = "ep3_boshaz_refuse",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_711", --Suit yourself. If you happen to change your mind, you know where to find me.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_refuse);

-- Came back after turning the Zssik down.
ep3_boshaz_return = ConvoScreen:new {
	id = "ep3_boshaz_return",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_617", --So, my young fledgling has returned. Have you changed your mind about working for the Zssik?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_619", "ep3_boshaz_deal"}, --Tell me more about what I need to do.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_621", "ep3_boshaz_refuse"}, --Not yet, maybe later.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_return);

ep3_boshaz_trust = ConvoScreen:new {
	id = "ep3_boshaz_trust",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_631", --It is true that I set you up. But you must realize it was simply a test to see if you had the right stuff. My clan has great need of a skilled warrior who is not in any way connected to us. I think that you will fit the bill quite nicely. Besides, we are not a poor clan and we always handsomely reward those who help us.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_633", "ep3_boshaz_deal"}, --Alright. What is the deal?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_trust);

ep3_boshaz_deal = ConvoScreen:new {
	id = "ep3_boshaz_deal",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_635", --I am a member of the Zssik clan. Perhaps you have heard of my clan? Or perhaps you haven't? It matters very little either way. All you really need to know is that we are tired of having to be subservient to those Blackscale weaklings. It is time for us to take our rightful place as rulers of the Avatar.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_637", "ep3_boshaz_weaklings"}, --Blackscale weaklings?
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_703", "ep3_boshaz_rulers"}, --Rulers of the Avatar?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_deal);

ep3_boshaz_rulers = ConvoScreen:new {
	id = "ep3_boshaz_rulers",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_705", --The Blackscale are its current master. They are the dominant clan on Kashyyyk which gives them virtual control over all aspects of the slave trade. Needless to say this has allowed them to take credits that should belong to us and keep them for themselves.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_707", "ep3_boshaz_avatar"}, --What is the Avatar Space Platform?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_rulers);

ep3_boshaz_weaklings = ConvoScreen:new {
	id = "ep3_boshaz_weaklings",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_639", --The Blackscales are currently the dominant clan here on Kashyyyk. To be the dominate clan means that you are the first and last word on all operations here on Kashyyyk. They alone deal with the Empire directly, leaving the rest of us dealing with them in order to make any credits. They can take the prime choice of Wookiee captives for themselves, and have absolute control of the Avatar Space Platform.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_641", "ep3_boshaz_avatar"}, --What is the Avatar Space Platform?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_weaklings);

ep3_boshaz_avatar = ConvoScreen:new {
	id = "ep3_boshaz_avatar",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_643", --That is the heart of the operation here on Kashyyyk. All Wookiee who are captured here on the planet will be eventually brought there. There they are retrained and domesticated before being sold to the Empire. Since no other clan is allowed on the Avatar, the Blackscale are able to dictate terms of payment to every other clan working on Kashyyyk. Their time as rulers of the Trandoshans has come to an end.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_645", "ep3_boshaz_dislike"}, --I take it you do not like the Blackscale.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_108", "ep3_boshaz_avatar_name"}, --Why is it called the Avatar?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_avatar);

ep3_boshaz_avatar_name = ConvoScreen:new {
	id = "ep3_boshaz_avatar_name",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_109", --Because it is the Dosh destiny to rule over the weak. What better name to give the symbol of Trandoshan power over these primitives? Simply put, the space station is the Avatar of Dosh on Kashyyyk. And it sickens me that the Blackscale weaklings have control over something so powerful.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_110", "ep3_boshaz_dislike"}, --I take it that you do not like the Blackscale.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_avatar_name);

ep3_boshaz_dislike = ConvoScreen:new {
	id = "ep3_boshaz_dislike",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_647", --The Blackscale are a bunch of cowards and weaklings. They have become corrupt, and even worse brazen about their corruption. We have heard that the Empire would not be upset if the Blackscale were removed from power. We Zssik have waited and fought a very long time to get into the position to dispose of the Blackscale.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_649", "ep3_boshaz_role"}, --And what is my role in all of this?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_dislike);

ep3_boshaz_role = ConvoScreen:new {
	id = "ep3_boshaz_role",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_651", --You, my young friend, will be the instrument of their ultimate downfall. We do not fear the Blackscale but an open confrontation with them would result in a weakening of both sides. Lesser clans might get some ideas...dangerous ideas. You are an outsider and no one will be able to connect you with us should things go badly.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_653", "ep3_boshaz_expendable"}, --In other words, I am expendable.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_699", "ep3_boshaz_patsy"}, --Sounds like you are looking for a patsy.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_role);

ep3_boshaz_patsy = ConvoScreen:new {
	id = "ep3_boshaz_patsy",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_701", --A patsy knows nothing. But a good agent must know what they are doing in order to be effective. We are not worried that you will talk if captured. The Blackscale do not take prisoners. If you fail they will probably eat you...for your sake I hope you are dead before they begin.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_657", "ep3_boshaz_ally"}, --I will take the job. What do I need to do?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_patsy);

ep3_boshaz_expendable = ConvoScreen:new {
	id = "ep3_boshaz_expendable",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_655", --Oh yes. You are quite expendable. But the Zssik would rather want you to survive and accomplish the tasks we need done. A dead agent is a useless tool.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_657", "ep3_boshaz_ally"}, --I will take the job. What do I need to do?
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_695", "ep3_boshaz_too_dangerous"}, --Thanks but no thanks. This sounds too dangerous.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_expendable);

ep3_boshaz_too_dangerous = ConvoScreen:new {
	id = "ep3_boshaz_too_dangerous",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_697", --Very well. But remember this before you leave...if you tell anyone about what has been said here you will find out why the wrath of the Zssik is legendary even amongst other Trandoshans.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_too_dangerous);

ep3_boshaz_ally = ConvoScreen:new {
	id = "ep3_boshaz_ally",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_659", --In order for us to take our rightful place as chief clan on Kashyyyk, the Blackscales must fall. We will disrupt their operations, kill their leaders, and embarrass them in the eyes of the Empire. But first...first we need an ally. An ally that can and is quite willing to cause all sorts of trouble for the Blackscale. We need to enlist the aid of the Wookiee resistance.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_661", "ep3_boshaz_unwitting"}, --The Wookiee resistance will never work for you.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_ally);

ep3_boshaz_unwitting = ConvoScreen:new {
	id = "ep3_boshaz_unwitting",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_663", --Of that I have no doubt. But...perhaps, they will work for you and in doing so, unwittingly work for us.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_665", "ep3_boshaz_codes"}, --How am I supposed to get the resistance to work for me?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_unwitting);

-- The access codes named here are what Mosolium Zssik later sends the player to steal.
ep3_boshaz_codes = ConvoScreen:new {
	id = "ep3_boshaz_codes",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_667", --By giving them what they want most...access codes to the Avatar Space Platform. You see the Wookiees all consider that to be the most evil place and the focal point of Trandoshan power on the planet. The resistance will do anything to be able to stage an attack on the platform. But they have no way to penetrate its defenses...you will supply them with that way.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_669", "ep3_boshaz_lifedebt"}, --How am I supposed to do that?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_codes);

ep3_boshaz_lifedebt = ConvoScreen:new {
	id = "ep3_boshaz_lifedebt",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_671", --All in good time, my young friend. First you must establish contact with the resistance. Fortunately, the means to this end have simply fallen into our laps. Have you ever heard of a life debt?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_673", "ep3_boshaz_chawroo"}, --Yes, I have.
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_689", "ep3_boshaz_lifedebt_explain"}, --No, I haven't.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_lifedebt);

ep3_boshaz_lifedebt_explain = ConvoScreen:new {
	id = "ep3_boshaz_lifedebt_explain",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_691", --A life debt is part of the Wookiees foolish sense of honor. If a Wookiee is saved from death by another being they basically believe that their life belongs to that other person. It is so strong and complete that I have seen Wookiees walk of their own free will into a slave shuttle after giving a life debt to a slaver who saved their life. Do you understand now?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_693", "ep3_boshaz_chawroo"}, --Yes. I understand.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_lifedebt_explain);

ep3_boshaz_chawroo = ConvoScreen:new {
	id = "ep3_boshaz_chawroo",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_675", --Good...good. A short time ago one of the Blackscale slaver patrols was attacked by a group of Wookiee freedom fighters under the command of a Wookiee named Chawroo. The Blackscales have been turning this world upside down trying to find him...but you see we found him first. He is in hiding not far from here with his mate.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_677", "ep3_boshaz_plan"}, --What are we going to do with him?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_chawroo);

ep3_boshaz_plan = ConvoScreen:new {
	id = "ep3_boshaz_plan",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_679", --It is so simple. We are going to tell the Blackscale where he is. The Blackscale will send a patrol out to put Chawroo and his mate to a slow, painful death. But just in the nick of time you will arrive and rescue those poor Wookiees from certain doom. Naturally, the Wookiee's screwed up sense of honor will force him into a life debt to you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_681", "ep3_boshaz_vouch"}, --And then what do I do with him?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_plan);

ep3_boshaz_vouch = ConvoScreen:new {
	id = "ep3_boshaz_vouch",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_683", --Oh, all we want him to do for now is to vouch for you and set up a meeting between you and the resistance leadership. Once a meeting has been set up he can leave word about the when and where with Orooroo.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_685", "ep3_boshaz_orooroo"}, --Who is Orooroo?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_vouch);

ep3_boshaz_orooroo = ConvoScreen:new {
	id = "ep3_boshaz_orooroo",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_687", --Oh, I am quite certain that Chawroo will know who Orooroo is. For now all you really should focus on is to rescue Chawroo from the Blackscale. Remember, kill all the Blackscale attackers and then get Chawroo to set up a meeting for you. Come back to me when you are finished.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_155", "ep3_boshaz_where"}, --Alright, where can I find Chawroo?
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_orooroo);

-- The GROUND leg is accepted on this screen id.
ep3_boshaz_where = ConvoScreen:new {
	id = "ep3_boshaz_where",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_157", --Chawroo is hiding to the northwest of here. He has found a hiding place along a path, near where the bolotaur's like to sun themselves, across from a waterfall in that area. You shouldn't have any trouble finding it if you are half as good as I think you are. Now get moving. The Blackscale will not wait long to strike.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_where);

ep3_boshaz_ground_active = ConvoScreen:new {
	id = "ep3_boshaz_ground_active",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_611", --So, did you managed to rescue Chawroo and get him to set up a meeting between you and the resistance.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_613", "ep3_boshaz_hurry"}, --Not yet. But I am working on it.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_ground_active);

ep3_boshaz_hurry = ConvoScreen:new {
	id = "ep3_boshaz_hurry",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_615", --You had better hurry. If the Blackscale spend to much time with him, I am afraid that Chawroo will be in no condition to set up anything.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_hurry);

ep3_boshaz_ground_done = ConvoScreen:new {
	id = "ep3_boshaz_ground_done",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_601", --How did your meeting with Chawroo go? I trust you managed to gain his...trust.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_603", "ep3_boshaz_gory"}, --Chawroo is setting up the meeting.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_ground_done);

ep3_boshaz_gory = ConvoScreen:new {
	id = "ep3_boshaz_gory",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_605", --Good. I would have been hoping that was the case. So, just between you and me...did those Blackscale curs suffer before you eliminated them?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_boshaz_zssik_01:s_607", "ep3_boshaz_payoff"}, --They have been dealt with if that is what you mean.
	}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_gory);

ep3_boshaz_payoff = ConvoScreen:new {
	id = "ep3_boshaz_payoff",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_609", --Ah...and I was hoping for some gory details. You take all the fun out of things. Oh well, as long as you have accomplished the goals set out before you. And as promised here is payment for the completion of your first task for us. For your next task you need to go talk to Dakar. He is expecting you. Good bye, fledgling.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_payoff);

-- Every hail after that.
ep3_boshaz_dakar = ConvoScreen:new {
	id = "ep3_boshaz_dakar",
	leftDialog = "@conversation/ep3_trandoshan_boshaz_zssik_01:s_599", --I have already told you everything that I can about the situation. You need to speak with Dakar now.
	stopConversation = "true",
	options = {}
}
ep3_boshaz_convotemplate:addScreen(ep3_boshaz_dakar);

addConversationTemplate("ep3_boshaz_convotemplate", ep3_boshaz_convotemplate);
