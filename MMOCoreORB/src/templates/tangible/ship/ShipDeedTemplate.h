/*
 * ShipDeedTemplate.h
 *
 *  Created on: Jan. 1, 2023
 *  Author: H
 */

#ifndef SHIPDEEDTEMPLATE_H_
#define SHIPDEEDTEMPLATE_H_

#include "templates/tangible/DeedTemplate.h"

class ShipDeedTemplate : public DeedTemplate {
	String shipControlDevice;
	int shipType;
	float chassisMaxHealth;
	float chassisMaxMass;
	String certificationRequired;
	Vector<String> skillsRequired;

public:
	ShipDeedTemplate() {
		shipControlDevice = "";
		shipType = 0;
		chassisMaxHealth = 0;
		chassisMaxMass = 0;

		setLoggingName("ShipDeedTemplate");
	}

	~ShipDeedTemplate() {
	}

	void readObject(LuaObject* templateData) {
		DeedTemplate::readObject(templateData);

		shipControlDevice = templateData->getStringField("shipControlDevice");
		shipType = templateData->getIntField("shipType");
		chassisMaxHealth = templateData->getFloatField("chassisMaxHealth");
		chassisMaxMass = templateData->getFloatField("chassisMaxMass");
		certificationRequired = templateData->getStringField("certificationRequired");

		auto skillTable = templateData->getObjectField("skillRequired");
		if (skillTable.isValidTable()) {
			for (int i = 1; i <= skillTable.getTableSize(); ++i)
				skillsRequired.add(skillTable.getStringAt(i));
		}
		skillTable.pop();
	}

	inline const String& getShipControlDeviceTemplate() {
		return shipControlDevice;
	}

	inline int getShipType() {
		return shipType;
	}

	bool isShipDeedTemplate() {
		return true;
	}

	inline float getChassisMaxHealth() const {
		return chassisMaxHealth;
	}

	inline float getChassisMaxMass() const {
		return chassisMaxMass;
	}

	inline const String& getCertificationRequired() const {
		return certificationRequired;
	}

	inline const Vector<String>& getSkillsRequired() const {
		return skillsRequired;
	}
};

#endif /* SHIPDEEDTEMPLATE_H_ */
