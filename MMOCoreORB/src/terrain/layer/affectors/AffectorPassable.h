/*
 * AffectorPAS.h
 *
 *  Created on: 31/01/2010
 *      Author: victor
 */

#ifndef AFFECTORPAS_H_
#define AFFECTORPAS_H_


#include "../ProceduralRule.h"

class AffectorPassable : public ProceduralRule<'APAS'>, public AffectorProceduralRule {
	float var1, var2;

public:
	AffectorPassable() : var1(0), var2(0) {
		affectorType = PASSABLE;
	}

	bool isEnabled() override {
		return informationHeader.isEnabled();
	}

	void process(float x, float y, float transformValue, float& baseValue, TerrainGenerator* terrainGenerator) override {
		if (transformValue > 0.f)
			baseValue = var1 != 0.f ? 1.f : 0.f;
	}

	void parseFromIffStream(engine::util::IffStream* iffStream) override {
		uint32 version = iffStream->getNextFormType();

		iffStream->openForm(version);

		switch (version) {
		case '0000':
			parseFromIffStream(iffStream, Version<'0000'>());
			break;
		default:
			System::out << "unknown AffectorPAS version 0x" << hex << version << endl;
			break;
		}

		iffStream->closeForm(version);
	}

	void parseFromIffStream(engine::util::IffStream* iffStream, Version<'0000'>) {
		informationHeader.readObject(iffStream);

		iffStream->openChunk('DATA');

		var1 = iffStream->getByte();
		var2 = iffStream->getInt();

		iffStream->closeChunk('DATA');
	}
};



#endif /* AFFECTORPAS_H_ */
