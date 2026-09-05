-- Chief Kerritamba -- ep3_forest_kerritamba_epic_1, ep3_forest_kerritamba_epic_2, ep3_forest_kerritamba_epic_3, ep3_forest_kerritamba_epic_4, ep3_forest_kerritamba_epic_5, ep3_forest_kerritamba_epic_6, ep3_forest_kerritamba_epic_7, ep3_forest_kerritamba_assassin, ep3_forest_on_hold, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_kerritamba_convo = ConvoTemplate:new {
	initialScreen = "s_837",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_kerritamba_conv_handler",
	screens = {}
}

ep3_forest_kerritamba_convo_s_690 = ConvoScreen:new {
	id = "s_690",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_690", -- Rrworrr!
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_690)

ep3_forest_kerritamba_convo_s_149 = ConvoScreen:new {
	id = "s_149",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_149", -- You are no longer welcome here, leave this place immediately!
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_149)

ep3_forest_kerritamba_convo_s_603 = ConvoScreen:new {
	id = "s_603",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_603", -- [Chief Kerritamba hums an ancient tune. He seems to be meditating.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_603)

ep3_forest_kerritamba_convo_s_605 = ConvoScreen:new {
	id = "s_605",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_605", -- [Chief Kerritamba nods.] I expect you have returned with the Mysess Blossom and the Mystical Bag of Dust, c...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_607", "s_609"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_605)

ep3_forest_kerritamba_convo_s_615 = ConvoScreen:new {
	id = "s_615",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_615", -- My patience wears thin... You have not yet brought me the items I require. Return only when you have them.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_615)

ep3_forest_kerritamba_convo_s_617 = ConvoScreen:new {
	id = "s_617",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_617", -- [Chief Kerritamba frowns.] I am displeased with your actions in the Arena. You did not show mercy, a trait ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_619", "s_629"},
		{"@conversation/ep3_forest_kerritamba:s_627", "s_625"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_617)

ep3_forest_kerritamba_convo_s_639 = ConvoScreen:new {
	id = "s_639",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_639", -- I see you have returned... and safely. I heard the news regarding Wirartu and his challenge. And the fact t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_641", "s_643"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_639)

ep3_forest_kerritamba_convo_s_645 = ConvoScreen:new {
	id = "s_645",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_645", -- You must speak with Wirartu at the Arena, my friend. Your reputation and honor have been challenged.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_645)

ep3_forest_kerritamba_convo_s_647 = ConvoScreen:new {
	id = "s_647",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_647", -- I have... some unfortunate news, my friend. [Chief Kerritamba begins, sadly.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_649", "s_651"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_647)

ep3_forest_kerritamba_convo_s_673 = ConvoScreen:new {
	id = "s_673",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_673", -- Please tell me you were successful in your journey.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_675", "s_677"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_673)

ep3_forest_kerritamba_convo_s_683 = ConvoScreen:new {
	id = "s_683",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_683", -- Cyrans and his Queen are still roaming the Dead Forest. I need to know why you are here.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_685", "s_687"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_683)

ep3_forest_kerritamba_convo_s_689 = ConvoScreen:new {
	id = "s_689",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_689", -- Let us continue... [Chief Kerritamba nods.] Now that their defenses have weakened, we must strike at the co...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_691", "s_693"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_689)

ep3_forest_kerritamba_convo_s_715 = ConvoScreen:new {
	id = "s_715",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_715", -- I see you have returned safely. What news do you have from the Dead Forest?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_717", "s_719"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_715)

ep3_forest_kerritamba_convo_s_725 = ConvoScreen:new {
	id = "s_725",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_725", -- The Sayormi still stalk the forests in large numbers. You have not completed your duty. Am I correct?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_727", "s_729"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_725)

ep3_forest_kerritamba_convo_s_731 = ConvoScreen:new {
	id = "s_731",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_731", -- The Great Tree has been healed, but... another threat looms on our horizon.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_733", "s_735"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_731)

ep3_forest_kerritamba_convo_s_749 = ConvoScreen:new {
	id = "s_749",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_749", -- My friend.. [Chief Kerritamba smiles kindly.] You cured the Great Tree. Now, we can finally focus our effor...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_751", "s_753"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_749)

ep3_forest_kerritamba_convo_s_755 = ConvoScreen:new {
	id = "s_755",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_755", -- I grow more and more concerned. Has the Great Tree been cured, my friend?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_757", "s_763"},
		{"@conversation/ep3_forest_kerritamba:s_761", "s_763"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_755)

ep3_forest_kerritamba_convo_s_765 = ConvoScreen:new {
	id = "s_765",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_765", -- Finally... [Chief Kerritamba opens his hands. You can see a mystical vial.] The cure. We must apply it to t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_767", "s_773"},
		{"@conversation/ep3_forest_kerritamba:s_771", "s_773"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_765)

ep3_forest_kerritamba_convo_s_787 = ConvoScreen:new {
	id = "s_787",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_787", -- [Chief Kerritamba seems deep in thought.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_789", "s_791"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_787)

ep3_forest_kerritamba_convo_s_797 = ConvoScreen:new {
	id = "s_797",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_797", -- I'm glad to see you have returned safely. Were you able to collect the items I requested?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_799", "s_801"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_797)

ep3_forest_kerritamba_convo_s_803 = ConvoScreen:new {
	id = "s_803",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_803", -- We may have a cure in mind, my friend. [Chief Kerritamba nods his head low in reverence.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_805", "s_807"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_803)

ep3_forest_kerritamba_convo_s_821 = ConvoScreen:new {
	id = "s_821",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_821", -- What have you found, my friend? I hope you bring good news.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_823", "s_825"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_821)

ep3_forest_kerritamba_convo_s_831 = ConvoScreen:new {
	id = "s_831",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_831", -- Welcome, my friend. [Chief Kerritamba nods in reverence.] I sense that you are empty handed. Do you have th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_833", "s_835"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_831)

ep3_forest_kerritamba_convo_s_837 = ConvoScreen:new {
	id = "s_837",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_837", -- [Chief Kerritamba nods.] Welcome to our humble village, friend. I assume you have met some of our gentle pe...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_839", "s_841"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_837)

ep3_forest_kerritamba_convo_s_609 = ConvoScreen:new {
	id = "s_609",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_609", -- Good. You have now been forgiven by the people. Embrace kindness and mercy, friend. I will be watching to s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_611", "s_613"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_609)

ep3_forest_kerritamba_convo_s_613 = ConvoScreen:new {
	id = "s_613",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_613", -- Now go.. I must meditate.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_613)

ep3_forest_kerritamba_convo_s_621 = ConvoScreen:new {
	id = "s_621",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_621", -- [Chief Kerritamba inhales deeply and sterns his jaw.] My tolerance for unspeakable evil grows thin.  If you...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_623", "s_625"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_621)

ep3_forest_kerritamba_convo_s_629 = ConvoScreen:new {
	id = "s_629",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_629", -- Perhaps. [Chief Kerritamba looks you over.] It is the desire to kill when one begs for your mercy that has ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_631", "s_633"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_629)

ep3_forest_kerritamba_convo_s_625 = ConvoScreen:new {
	id = "s_625",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_625", -- [Chief Kerritamba growls.] Get.. out. And never return. You have been banished from village Kerritamba. Now...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_625)

ep3_forest_kerritamba_convo_s_633 = ConvoScreen:new {
	id = "s_633",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_633", -- [Chief Kerritamba only nods.] I require a rare Mysess Blossom and a Bag of Dust from the Sayormi witches. G...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_635", "s_637"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_633)

ep3_forest_kerritamba_convo_s_637 = ConvoScreen:new {
	id = "s_637",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_637", -- [Chief Kerritamba nods.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_637)

ep3_forest_kerritamba_convo_s_643 = ConvoScreen:new {
	id = "s_643",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_643", -- Please enjoy the kindness our village has to offer. The people will recognize you as hero and treat you acc...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_643)

ep3_forest_kerritamba_convo_s_651 = ConvoScreen:new {
	id = "s_651",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_651", -- No, no. It is entirely my fault that this has come up. I shouldn't have asked for your help...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_653", "s_655"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_651)

ep3_forest_kerritamba_convo_s_655 = ConvoScreen:new {
	id = "s_655",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_655", -- [Chief Kerritamba sighs.] It is the honor of the Arena Champion to perform tasks for his people and his Chi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_657", "s_659"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_655)

ep3_forest_kerritamba_convo_s_659 = ConvoScreen:new {
	id = "s_659",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_659", -- I know. It is I who has placed you in this dire situation. I can only deeply apologize for my ignorance. Bu...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_661", "s_671"},
		{"@conversation/ep3_forest_kerritamba:s_669", "s_667"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_659)

ep3_forest_kerritamba_convo_s_663 = ConvoScreen:new {
	id = "s_663",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_663", -- It is all I can expect. However, it is not beyond your ability to bring along allies. Perhaps, it is best t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_665", "s_667"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_663)

ep3_forest_kerritamba_convo_s_671 = ConvoScreen:new {
	id = "s_671",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_671", -- I understand. It is a hard decision.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_671)

ep3_forest_kerritamba_convo_s_667 = ConvoScreen:new {
	id = "s_667",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_667", -- May the spirits choose your fate.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_667)

ep3_forest_kerritamba_convo_s_677 = ConvoScreen:new {
	id = "s_677",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_677", -- Then our forests can rest once more... [Chief Kerritamba nods his head in reverence.] You are an unbelievab...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_679", "s_681"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_677)

ep3_forest_kerritamba_convo_s_681 = ConvoScreen:new {
	id = "s_681",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_681", -- Now, I too can finally rest. [Chief Kerritamba bows his head.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_681)

ep3_forest_kerritamba_convo_s_687 = ConvoScreen:new {
	id = "s_687",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_687", -- Continue your task. I hope good fortune finds you and aids you.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_687)

ep3_forest_kerritamba_convo_s_693 = ConvoScreen:new {
	id = "s_693",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_693", -- Cyrans the Unfeeling. [Chief Kerritamba's eyes flicker with memories of the past.] He is our most pronounce...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_695", "s_697"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_693)

ep3_forest_kerritamba_convo_s_697 = ConvoScreen:new {
	id = "s_697",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_697", -- [Chief Kerritamba sterns his jaw.] At the time, I was a young warrior. And I had not yet proven myself to t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_699", "s_701"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_697)

ep3_forest_kerritamba_convo_s_701 = ConvoScreen:new {
	id = "s_701",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_701", -- Since then, our people have thrived. We came back from the ashes that Cyrans the Unfeeling had thrown behin...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_703", "s_705"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_701)

ep3_forest_kerritamba_convo_s_705 = ConvoScreen:new {
	id = "s_705",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_705", -- You are correct. [Chief Kerritamba points east.] They live in the Dead Forest where the rest of his minions...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_707", "s_713"},
		{"@conversation/ep3_forest_kerritamba:s_711", "s_713"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_705)

ep3_forest_kerritamba_convo_s_709 = ConvoScreen:new {
	id = "s_709",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_709", -- You make me proud. May safety be with you.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_709)

ep3_forest_kerritamba_convo_s_713 = ConvoScreen:new {
	id = "s_713",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_713", -- May that time be soon and not too late.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_713)

ep3_forest_kerritamba_convo_s_719 = ConvoScreen:new {
	id = "s_719",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_719", -- Mmm... [Chief Kerritamba nods.] Good. There is one last thing you must do for us, however. Your path has be...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_721", "s_723"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_719)

ep3_forest_kerritamba_convo_s_723 = ConvoScreen:new {
	id = "s_723",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_723", -- [Chief Kerritamba nods and begins to hum an ancient tune.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_723)

ep3_forest_kerritamba_convo_s_729 = ConvoScreen:new {
	id = "s_729",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_729", -- Good. Hurry, my friend. The end times draw near.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_729)

ep3_forest_kerritamba_convo_s_735 = ConvoScreen:new {
	id = "s_735",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_735", -- The Sayormi. Dedicated to the mortal ties of death and decay, the Sayormi try desperately to destroy our lu...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_737", "s_739"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_735)

ep3_forest_kerritamba_convo_s_739 = ConvoScreen:new {
	id = "s_739",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_739", -- The curing of the Great Tree has stirred the Sayormi. Where they once slept, they now roam, destroying our ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_741", "s_747"},
		{"@conversation/ep3_forest_kerritamba:s_745", "s_747"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_739)

ep3_forest_kerritamba_convo_s_743 = ConvoScreen:new {
	id = "s_743",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_743", -- You are an honorable friend. Please go forth and be careful. The Sayormi are devious foes.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_743)

ep3_forest_kerritamba_convo_s_747 = ConvoScreen:new {
	id = "s_747",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_747", -- I understand. [Chief Kerritamba lowers his head, saddened by the decision.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_747)

ep3_forest_kerritamba_convo_s_753 = ConvoScreen:new {
	id = "s_753",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_753", -- You did more than just help. You saved our forest! You're a hero in our eyes now. Please take this, a gift ...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_753)

ep3_forest_kerritamba_convo_s_759 = ConvoScreen:new {
	id = "s_759",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_759", -- We need to hurry. My people grow anxious to hear the news. Cure the Great Tree and come back a hero.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_759)

ep3_forest_kerritamba_convo_s_763 = ConvoScreen:new {
	id = "s_763",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_763", -- [Chief Kerritamba rolls his eyes.] This isn't a subject to be regarded lightly! Don't lose this one.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_763)

ep3_forest_kerritamba_convo_s_769 = ConvoScreen:new {
	id = "s_769",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_769", -- Be quick about it. We guard the Great Tree well. Therefore, it should be an easy journey.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_769)

ep3_forest_kerritamba_convo_s_773 = ConvoScreen:new {
	id = "s_773",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_773", -- The Great Tree provided us with great shelter and lifted our hopes and spirits during our darkest hour. Fro...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_775", "s_777"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_773)

ep3_forest_kerritamba_convo_s_777 = ConvoScreen:new {
	id = "s_777",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_777", -- Indeed. It is a vigil in our lives and serves as a beacon of the victory we shared in that time.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_779", "s_781"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_777)

ep3_forest_kerritamba_convo_s_781 = ConvoScreen:new {
	id = "s_781",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_781", -- Yes, yes of course! Please, give this to the Great Tree. Let us hope it works.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_783", "s_785"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_781)

ep3_forest_kerritamba_convo_s_785 = ConvoScreen:new {
	id = "s_785",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_785", -- It should be an easy journey. We guard the Great Tree well.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_785)

ep3_forest_kerritamba_convo_s_791 = ConvoScreen:new {
	id = "s_791",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_791", -- Ah, perfect. Now... let us hope it works. I will mix the ingredients and prepare it for you momentarily. If...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_793", "s_795"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_791)

ep3_forest_kerritamba_convo_s_795 = ConvoScreen:new {
	id = "s_795",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_795", -- I will explain to you the history of our Great Tree in due time, my friend. Come back after I have mixed th...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_795)

ep3_forest_kerritamba_convo_s_801 = ConvoScreen:new {
	id = "s_801",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_801", -- Good. Please return when you have the items in hand for me. [Chief Kerritamba nods in reverence.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_801)

ep3_forest_kerritamba_convo_s_807 = ConvoScreen:new {
	id = "s_807",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_807", -- It seems that with the hightened activity within the Myyydril Caverns, certain chemical reactions have set ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_809", "s_811"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_807)

ep3_forest_kerritamba_convo_s_811 = ConvoScreen:new {
	id = "s_811",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_811", -- I cannot go into the details, only tell you what I need from the surrounding forest. You must find an Osera...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_813", "s_819"},
		{"@conversation/ep3_forest_kerritamba:s_817", "s_819"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_811)

ep3_forest_kerritamba_convo_s_815 = ConvoScreen:new {
	id = "s_815",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_815", -- My people and I thank you. I only hope you return quickly so that we may cure our beloved forest in due time.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_815)

ep3_forest_kerritamba_convo_s_819 = ConvoScreen:new {
	id = "s_819",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_819", -- I understand.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_819)

ep3_forest_kerritamba_convo_s_825 = ConvoScreen:new {
	id = "s_825",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_825", -- Good, good. [Chief Kerritamba takes the samples.] It is time to test my theories. Please return after I hav...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_827", "s_829"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_825)

ep3_forest_kerritamba_convo_s_829 = ConvoScreen:new {
	id = "s_829",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_829", -- I hope so too. Come back in a few moments.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_829)

ep3_forest_kerritamba_convo_s_835 = ConvoScreen:new {
	id = "s_835",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_835", -- [Chief Kerritamba nods.] Please go forth and acquire these items for me.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_835)

ep3_forest_kerritamba_convo_s_841 = ConvoScreen:new {
	id = "s_841",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_841", -- Yes, I know. Unfortunately, we are a skeptical, untrusting people. I wish it were different. [Chief Kerrita...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_843", "s_845"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_841)

ep3_forest_kerritamba_convo_s_845 = ConvoScreen:new {
	id = "s_845",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_845", -- Our forest... [Chief Kerritamba closes his eyes.] It's dying. Can you feel it? I can. We all can. It pains ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_847", "s_849"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_845)

ep3_forest_kerritamba_convo_s_849 = ConvoScreen:new {
	id = "s_849",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_849", -- We have our suspicions, but no real answers. Some suspect that the Myyydril have caused this. The mystics b...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_851", "s_869"},
		{"@conversation/ep3_forest_kerritamba:s_867", "s_857"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_849)

ep3_forest_kerritamba_convo_s_853 = ConvoScreen:new {
	id = "s_853",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_853", -- Perhaps. But we must try and find the source of the problem. The Myyydril people have gone through enough. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_855", "s_857"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_853)

ep3_forest_kerritamba_convo_s_869 = ConvoScreen:new {
	id = "s_869",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_869", -- It is a painful event to remember. [The chief begins sadly.] It was long ago. They came to us from the dept...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_871", "s_873"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_869)

ep3_forest_kerritamba_convo_s_857 = ConvoScreen:new {
	id = "s_857",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_857", -- I need samples. There are unspeakable creatures living in the Myyydril Caverns, living amongst radiated cry...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_859", "s_865"},
		{"@conversation/ep3_forest_kerritamba:s_863", "s_865"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_857)

ep3_forest_kerritamba_convo_s_861 = ConvoScreen:new {
	id = "s_861",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_861", -- You make an old soul very happy, my friend. The Myyydril Caverns is to the north across the river. You can ...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_861)

ep3_forest_kerritamba_convo_s_865 = ConvoScreen:new {
	id = "s_865",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_865", -- [Chief Kerritamba nods.] I understand, my friend. Please enjoy the rest our village has to offer.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_865)

ep3_forest_kerritamba_convo_s_873 = ConvoScreen:new {
	id = "s_873",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_873", -- No. However, it was the consensus of the people of Kerritamba to oust them for Hosdra's horrible deed. We c...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_875", "s_877"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_873)

ep3_forest_kerritamba_convo_s_877 = ConvoScreen:new {
	id = "s_877",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_877", -- Indeed. [Chief Kerritamba lowers his head.] We must find the root of the problem, the cause of our beloved ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_879", "s_881"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_877)

ep3_forest_kerritamba_convo_s_881 = ConvoScreen:new {
	id = "s_881",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_881", -- Perhaps. But we must try and find the source of the problem. The Myyydril people have gone through enough. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_883", "s_885"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_881)

ep3_forest_kerritamba_convo_s_885 = ConvoScreen:new {
	id = "s_885",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_885", -- I need samples. There are unspeakable creatures living in the Myyydril Caverns, living amongst radiated cry...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba:s_887", "s_893"},
		{"@conversation/ep3_forest_kerritamba:s_891", "s_893"},
	}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_885)

ep3_forest_kerritamba_convo_s_889 = ConvoScreen:new {
	id = "s_889",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_889", -- You make an old soul very happy, my friend. The Myyydril Caverns is to the north across the river. You can ...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_889)

ep3_forest_kerritamba_convo_s_893 = ConvoScreen:new {
	id = "s_893",
	leftDialog = "@conversation/ep3_forest_kerritamba:s_893", -- [Chief Kerritamba nods.] I understand, my friend. Please enjoy the rest our village has to offer.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_convo:addScreen(ep3_forest_kerritamba_convo_s_893)

addConversationTemplate("ep3_forest_kerritamba_convo", ep3_forest_kerritamba_convo)
