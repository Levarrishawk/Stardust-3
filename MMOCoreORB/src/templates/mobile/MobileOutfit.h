/*
 * MobileOutfit.h
 *
 *  Created on: 22/01/2012
 *      Author: victor
 */

#ifndef MOBILEOUTFIT_H_
#define MOBILEOUTFIT_H_

class OutfitTangibleObject : public Object {
	String objectTemplate;
	VectorMap<String, uint8> customizationVariables;
public:
	OutfitTangibleObject() {

	}

	OutfitTangibleObject(const OutfitTangibleObject& o) : Object() {
		objectTemplate = o.objectTemplate;
		customizationVariables = o.customizationVariables;
	}

	OutfitTangibleObject& operator=(const OutfitTangibleObject& o) {
		if (this == &o)
			return *this;

		objectTemplate = o.objectTemplate;
		customizationVariables = o.customizationVariables;

		return *this;
	}

	void readObject(LuaObject* luaObject) {
		objectTemplate = luaObject->getStringField("objectTemplate");

		LuaObject table = luaObject->getObjectField("customizationVariables");

		for (int i = 1; i <= table.getTableSize(); ++i) {
			LuaObject var = table.getObjectAt(i);

			String name = var.getStringAt(1);
			uint8 val = var.getIntAt(2);

			customizationVariables.put(name, val);

			var.pop();
		}

		table.pop();
	}

	String getObjectTemplate() {
		return objectTemplate;
	}

	VectorMap<String, uint8>* getCustomizationVariables() {
		return &customizationVariables;
	}
};

class MobileOutfit : public Object {
	Vector<OutfitTangibleObject> objects;
	VectorMap<String, int16> creatureCustomizationVariables;
public:
	MobileOutfit() {

	}

	MobileOutfit(const MobileOutfit& o) : Object() {
		objects = o.objects;
		creatureCustomizationVariables = o.creatureCustomizationVariables;
	}

	MobileOutfit& operator=(const MobileOutfit& o) {
		if (this == &o)
			return *this;

		objects = o.objects;
		creatureCustomizationVariables = o.creatureCustomizationVariables;

		return *this;
	}

	void readObject(LuaObject* luaObject) {
		LuaObject customizationTable = luaObject->getObjectField("creatureCustomizationVariables");

		if (customizationTable.isValidTable()) {
			for (int i = 1; i <= customizationTable.getTableSize(); ++i) {
				LuaObject var = customizationTable.getObjectAt(i);

				if (var.isValidTable() && var.getTableSize() >= 2) {
					String name = var.getStringAt(1);
					int16 val = var.getIntAt(2);

					creatureCustomizationVariables.put(name, val);
				}

				var.pop();
			}
		}

		customizationTable.pop();

		for (int i = 1; i <= luaObject->getTableSize(); ++i) {
			LuaObject obj = luaObject->getObjectAt(i);

			OutfitTangibleObject outfit;
			outfit.readObject(&obj);

			objects.add(outfit);

			obj.pop();
		}
	}

	Vector<OutfitTangibleObject>* getObjects() {
		return &objects;
	}

	VectorMap<String, int16>* getCreatureCustomizationVariables() {
		return &creatureCustomizationVariables;
	}

};

#endif /* MOBILEOUTFIT_H_ */
