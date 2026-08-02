isb_outfit = {
  {
    creatureCustomizationVariables = {
   --   {"/private/index_style_beard", 5},
     -- {"/private/index_color_facial_hair", 21}
    },

    {objectTemplate = "object/tangible/wearables/jacket/jacket_s03.iff", customizationVariables = {{"/private/index_color_1", 42}} },
    {objectTemplate = "object/tangible/wearables/pants/pants_s15.iff", customizationVariables = {{"/private/index_color_1", 41}} },
    {objectTemplate = "object/tangible/wearables/hat/hat_imp_s01.iff", customizationVariables = {{"/private/index_color_1", 42}} },
    {objectTemplate = "object/tangible/wearables/boots/boots_s14.iff", customizationVariables = {{"/private/index_color_1", 41}} }   
  }
}

addOutfitGroup("isb_outfit", isb_outfit)