bail_organa_outfit = {
	{
		creatureCustomizationVariables = {
			{"/shared_owner/index_color_skin", 12},
			{"/shared_owner/blend_fat", 0},
			{"/shared_owner/blend_skinny", 96},
			{"/private/index_color_2", 1},
			{"/private/index_style_beard", 0},
			{"/private/index_color_facial_hair", 10}
		},

		{objectTemplate = "object/tangible/wearables/robe/robe_s01.iff", customizationVariables = {{"/private/index_color_1", 243}, {"/private/index_color_2", 3}} },
		{objectTemplate = "object/tangible/wearables/pants/pants_s12.iff", customizationVariables = {} },
		{objectTemplate = "object/tangible/wearables/shoes/shoes_s01.iff", customizationVariables = {} },
		{objectTemplate = "object/tangible/hair/human/hair_human_male_s07.iff", customizationVariables = {{"/private/index_color_1", 10}} }
	}
}

addOutfitGroup("bail_organa_outfit", bail_organa_outfit)
