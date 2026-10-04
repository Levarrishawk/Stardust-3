-- Approximately 14 BBY: a younger interpretation of the supplied 9 BBY reference.
beru_lars_outfit = {
	{
		creatureCustomizationVariables = {
			{"/private/index_age", 0},
			{"/shared_owner/index_color_skin", 12},
			{"/shared_owner/blend_fat", 0},
			{"/shared_owner/blend_skinny", 32},
			{"/shared_owner/blend_muscle", 16},
			{"/private/index_color_2", 1},
			{"/private/index_color_facial_hair", 21},
			{"/private/index_style_eyeshadow", 0},
			{"/private/index_style_freckles", 0},
			{"/shared_owner/blend_cheeks_0", 0},
			{"/shared_owner/blend_cheeks_1", 32},
			{"/shared_owner/blend_jaw_0", 24},
			{"/shared_owner/blend_jaw_1", 0},
			{"/shared_owner/blend_nosewidth_0", 32},
			{"/shared_owner/blend_nosewidth_1", 0}
		},

		{objectTemplate = "object/tangible/wearables/jacket/robe_s02.iff", customizationVariables = {{"/private/index_color_1", 20}} },
		{objectTemplate = "object/tangible/wearables/shirt/shirt_s11.iff", customizationVariables = {{"/private/index_color_1", 24}} },
		{objectTemplate = "object/tangible/wearables/pants/pants_s04.iff", customizationVariables = {{"/private/index_color_1", 92}} },
		{objectTemplate = "object/tangible/wearables/boots/boots_s05.iff", customizationVariables = {{"/private/index_color_1", 97}} },
		{objectTemplate = "object/tangible/hair/human/hair_human_female_s08.iff", customizationVariables = {{"/private/index_color_1", 18}} }
	}
}

addOutfitGroup("beru_lars_outfit", beru_lars_outfit)
