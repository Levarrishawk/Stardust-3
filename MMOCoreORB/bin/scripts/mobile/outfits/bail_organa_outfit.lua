bail_organa_outfit = {
	{
		creatureCustomizationVariables = {
			{"/shared_owner/index_color_skin", 12},
			{"/private/index_style_beard", 0},
			{"/private/index_color_facial_hair", 14}
		},

		{objectTemplate = "object/tangible/wearables/robe/robe_s12.iff", customizationVariables = {{"/private/index_color_1", 243}, {"/private/index_color_2", 3}} },
		{objectTemplate = "object/tangible/wearables/pants/pants_s12.iff", customizationVariables = {} },
		{objectTemplate = "object/tangible/wearables/shoes/shoes_s01.iff", customizationVariables = {} },
		{objectTemplate = "object/tangible/hair/human/hair_human_male_s07.iff", customizationVariables = {{"/private/index_color_1", 14}} }
	}
}

addOutfitGroup("bail_organa_outfit", bail_organa_outfit)
