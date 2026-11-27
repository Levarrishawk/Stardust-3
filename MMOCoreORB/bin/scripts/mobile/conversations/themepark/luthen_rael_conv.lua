local function addGalleryScreens(template)
	local function screen(id, text, options)
		template:addScreen(ConvoScreen:new {
			id = id, customDialogText = text,
			stopConversation = options and "false" or "true", options = options or {}
		})
	end

	local exhibits = {
		{"What did that navigation instrument measure?", "gallery_instrument"},
		{"How can you date the reliquary?", "gallery_reliquary"},
		{"Why is the funerary urn chipped?", "gallery_urn"},
		{"I'll take a look around. Thank you.", "gallery_goodbye"}
	}
	local browse = {"Show me something from the collection.", "gallery_exhibits"}
	local leave = {"I'll leave you to your work.", "gallery_goodbye"}

	screen("gallery_public", "Welcome to Galactic Antiquities and Objects of Interest. You can pick up the navigation instrument if you like. Everyone expects it to be heavier.", exhibits)
	screen("gallery_exhibits", "Of course. Which piece caught your eye?", exhibits)
	screen("gallery_instrument", "Sight along the rim. See the two little nicks? A pilot filed them there so she could find the same two stars in the dark. I've had three offers to polish them out.", {
		{"Would that lower its value?", "gallery_marks"}, browse, leave
	})
	screen("gallery_marks", "It would make it prettier. But those marks are the only record we have of where she flew. I rather like knowing that someone could still find the way home.", {browse, leave})
	screen("gallery_reliquary", "The hinge pin gave us a date. A Republic silversmith stamped it where no one would see it unless the lid came off. Fortunately for me, the lid came off on the way here.", {browse, leave})
	screen("gallery_urn", "The family kept a pinch of clay from the rim. A little of home to take with them. Look closely and you'll see the cloth marks in the clay. It was still soft when they wrapped it.", {browse, leave})
	screen("gallery_return", "You've a good eye for when the shop is quiet. Stay a while. There's a piece here I think you'd enjoy.", {browse, leave})
	screen("gallery_handoff", "Back so soon? I have the address we discussed, if you need it. Otherwise, the collection is yours to explore.", {
		{"Remind me where to meet your contact.", "gallery_directions"}, browse, leave
	})
	screen("gallery_directions", "Saw Gerrera, on Lok. I've marked the rendezvous for you. Give him my name once. Let him ask the next question.", {browse, leave})
	screen("gallery_veteran", "Come in. I saved a small thing for you to see. A packing slip, of all things. Recognize the handwriting at the bottom?", {
		{"Did the last shipment get through?", "gallery_receipt"},
		{"You kept the receipt?", "gallery_keepsake"}, browse, leave
	})
	screen("gallery_receipt", "Every crate. They even sent the empties back. Look at that signature. The first time that quartermaster wrote to me, his hand shook so badly I couldn't read his name.", {
		{"You kept the receipt?", "gallery_keepsake"}, browse, leave
	})
	screen("gallery_keepsake", "For years I've asked people to bring me things with a history. This one's mine. I thought you, of all people, ought to see it before it goes in the drawer.", {browse, leave})
	screen("gallery_goodbye", "Take your time. The best pieces tend to reward a second look.")
end

createMissionGiverConvoTemplate("luthen_rael_convotemplate", "luthen_rael_conv_handler", addGalleryScreens)
