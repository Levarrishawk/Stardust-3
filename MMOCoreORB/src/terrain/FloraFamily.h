/*
 * FloraFamily.h
 *
 *  Created on: 01/02/2010
 *      Author: victor
 */

#ifndef FLORAFAMILY_H_
#define FLORAFAMILY_H_

#include "TemplateVariable.h"

class FloraData {
public:
	String name; // + 8 4byte vars
	float var1;
	uint32 var2;
	float var3;
	float var4;
	uint32 var5;
	int var6;
	float var7;
	float var8;
};

class FloraFamily : public TemplateVariable<'FFAM'> {
	int familyId;
	String familyName;
	byte red, green, blue;
	float weight;
	uint32 isAquatic;

	Vector<FloraData*> data;


public:
	int getFamilyID() const { return familyId; }
	const FloraData* chooseChild(float choice) const {
		if (data.size() == 0)
			return nullptr;
		float weightSum = 0;
		for (int i = 0; i < data.size(); ++i)
			weightSum += data.get(i)->var1;
		float value = choice * weightSum;
		for (int i = 0; i < data.size(); ++i) {
			if (value <= data.get(i)->var1)
				return data.get(i);
			value -= data.get(i)->var1;
		}
		return data.get(0);
	}

	~FloraFamily() {
		while (data.size() > 0)
			delete data.remove(0);
	}

	void readObject(IffStream* iffStream) {
		readObject(iffStream, '0008');
	}

	void readObject(IffStream* iffStream, uint32 version) {
		iffStream->openChunk('FFAM');

		familyId = iffStream->getInt();
		iffStream->getString(familyName);

		red = iffStream->getByte();
		green = iffStream->getByte();
		blue = iffStream->getByte();
		weight = iffStream->getFloat();
		isAquatic = iffStream->getUnsignedInt();

		int var8 = iffStream->getInt();// counter

		for (int i = 0; i < var8; ++i) {
			FloraData* floraData = new FloraData();

			iffStream->getString(floraData->name);
			floraData->var1 = iffStream->getFloat();
			floraData->var2 = iffStream->getUnsignedInt();
			floraData->var3 = iffStream->getFloat();
			floraData->var4 = iffStream->getFloat();
			floraData->var5 = version >= '0007' ? iffStream->getUnsignedInt() : 0;
			floraData->var6 = version >= '0008' ? iffStream->getInt() : 0;
			floraData->var7 = version >= '0008' ? iffStream->getFloat() : 1.f;
			floraData->var8 = version >= '0008' ? iffStream->getFloat() : 1.f;

			data.add(floraData);
		}

		iffStream->closeChunk('FFAM');
	}
};


#endif /* FLORAFAMILY_H_ */
