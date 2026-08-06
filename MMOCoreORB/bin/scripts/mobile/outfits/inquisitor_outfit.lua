inquisitor_outfit = {
  {
    creatureCustomizationVariables = {
   --   {"/private/index_style_beard", 5},
     -- {"/private/index_color_facial_hair", 21}
    },

    {objectTemplate = "object/tangible/wearables/bodysuit/bodysuit_tie_fighter.iff", customizationVariables = {{"/private/index_color_1", 1}} },
    {objectTemplate = "object/tangible/wearables/vest/vest_s11.iff", customizationVariables = {{"/private/index_color_1", 90}} },        
    {objectTemplate = "object/tangible/wearables/armor/ris/armor_ris_helmet.iff", customizationVariables = {{"/private/index_color_1", 158}, {"/private/index_color_2", 158}} },
    {objectTemplate = "object/tangible/wearables/gloves/gloves_s02.iff", customizationVariables = {{"/private/index_color_1", 158}} },
    {objectTemplate = "object/tangible/wearables/belt/belt_s01.iff", customizationVariables = {{"/private/index_color_1",158}} },
    {objectTemplate = "object/tangible/wearables/boots/boots_s14.iff", customizationVariables = {{"/private/index_color_1", 31}} }     
  }
}

addOutfitGroup("inquisitor_outfit", inquisitor_outfit)