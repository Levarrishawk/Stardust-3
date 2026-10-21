#ifndef AFFECTORRIBBON_H_
#define AFFECTORRIBBON_H_

#include "../ProceduralRule.h"
#include "AffectorProceduralRule.h"
#include "../../TerrainWaterSurface.h"

class AffectorRibbon : public ProceduralRule<'ARIB'>, public AffectorProceduralRule {
	Vector<Vector3> points;
	float width = 0;
	float waterShaderSize = 0;
	float velocity = 0;
	float capWidth = 0;
	int terrainShaderFamily = 0;
	int featheringType = 0;
	float featheringAmount = 0;
	String waterShader;
	int waterType = 0;
	Vector<TerrainWaterSurface> waterSurfaces;
	void createWaterSurfaces();

public:
	void parseFromIffStream(engine::util::IffStream* iffStream) override {
		uint32 version = iffStream->getNextFormType();
		if (version != '0005')
			throw Exception("Unsupported ARIB version " + String::hexvalueOf((int64) version) + " in " + iffStream->getFileName());

		iffStream->openForm(version);
		points.removeAll();
		informationHeader.readObject(iffStream);
		iffStream->openForm('DATA');
		iffStream->openChunk('DATA');
		int count = iffStream->getInt();
		if (count < 0 || count > iffStream->getDataSize() / 12)
			throw Exception("Invalid ARIB control point count in " + iffStream->getFileName());
		for (int i = 0; i < count; ++i) {
			float x = iffStream->getFloat();
			float y = iffStream->getFloat();
			float height = iffStream->getFloat();
			points.add(Vector3(x, y, height));
		}
		width = iffStream->getFloat();
		waterShaderSize = iffStream->getFloat();
		velocity = iffStream->getFloat();
		capWidth = iffStream->getFloat();
		terrainShaderFamily = iffStream->getInt();
		featheringType = iffStream->getInt();
		featheringAmount = Math::clamp(0.f, iffStream->getFloat(), 1.f);
		iffStream->getString(waterShader);
		waterType = iffStream->getInt();
		iffStream->closeChunk('DATA');
		iffStream->closeForm('DATA');
		iffStream->closeForm(version);
		createWaterSurfaces();
	}

	// Ribbons render water and terrain shaders; they do not change terrain height.
	bool isEnabled() override {
		return informationHeader.isEnabled();
	}

	const Vector<Vector3>& getControlPoints() const {
		return points;
	}

	int getWaterType() const {
		return waterType;
	}

	const Vector<TerrainWaterSurface>& getWaterSurfaces() const {
		return waterSurfaces;
	}
};

#endif /* AFFECTORRIBBON_H_ */
