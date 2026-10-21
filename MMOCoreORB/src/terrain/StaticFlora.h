#ifndef STATICFLORA_H_
#define STATICFLORA_H_

#include "PackedTerrainMap.h"
#include "engine/util/u3d/AABB.h"
#include "engine/util/u3d/Sphere.h"
#include "engine/util/u3d/Matrix4.h"

class FloraGroup;
class AppearanceTemplate;

struct StaticFloraInstance : public Object {
	Vector3 position;
	float yaw = 0;
	float scale = 1;
	const AppearanceTemplate* appearance = nullptr; // owned by TemplateManager
	float radius = 0;

	Vector3 toModelSpace(const Vector3& world) const;
	Matrix4 getNavMeshTransform() const;
};

class StaticFlora {
	PackedTerrainMap families;
	PackedTerrainMap heights;
	float resolution = 1;
	VectorMap<uint32, StaticFloraInstance> instances;
	float maximumRadius = 0;

public:
	void clear();
	void readObject(IffStream* stream);
	void initialize(float mapSize, float border, const FloraGroup& group);
	void getInstances(const AABB& worldBounds, Vector<StaticFloraInstance>& result) const;
	static bool isCleared(const StaticFloraInstance& instance, const Vector<Sphere>& clearAreas);
	bool hasInstances() const { return instances.size() != 0; }
	int getInstanceCount() const { return instances.size(); }

	// Matches sharedRandom/RandomGenerator and sharedTerrain/CoordinateHash.
	static void getPlacement(uint32 key, int mapWidth, float border, Vector3& position, float& yaw, float& scaleChoice);
	static float getChildChoice(float x, float y);
};

#endif /* STATICFLORA_H_ */
