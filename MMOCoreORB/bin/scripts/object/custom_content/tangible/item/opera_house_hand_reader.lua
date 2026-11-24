local reader = SharedTangibleObjectTemplate:new {
	clientTemplateFileName = "object/tangible/item/shared_opera_house_hand_reader.iff",
}
ObjectTemplates:addClientTemplate(reader, reader.clientTemplateFileName)
ObjectTemplates:addTemplate(reader:new {}, "object/tangible/item/opera_house_hand_reader.iff")
