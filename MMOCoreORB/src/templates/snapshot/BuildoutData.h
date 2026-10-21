#ifndef BUILDOUTDATA_H_
#define BUILDOUTDATA_H_

#include "templates/datatables/DataTableIff.h"
#include "engine/util/u3d/Quaternion.h"
#include "engine/util/u3d/Vector3.h"

struct BuildoutRectangle : public Object {
	float x1 = 0, y1 = 0, x2 = 0, y2 = 0;
	bool contains(float x, float y) const { return x >= x1 && x <= x2 && y >= y1 && y <= y2; }
	bool valid() const { return x2 > x1 && y2 > y1; }
};

struct BuildoutArea : public Object {
	int index = 0;
	String name;
	BuildoutRectangle bounds, clip, composite;
	bool useClip = false;
	int environmentFlags = 255;
	bool useOrigin = false;
	float originX = 0, originY = 0;
	String compositeName, requiredEvent;
	bool isolated = true, allowMap = true, internal = false, allowRadarTerrain = true;

	const BuildoutRectangle& getMapBounds() const { return compositeName.isEmpty() ? bounds : composite; }
	Vector3 getRelativePosition(const Vector3& world) const;
};

struct BuildoutObject : public Object {
	uint64 objectID = 0, parentID = 0;
	uint32 templateCRC = 0, portalLayoutCRC = 0;
	int cellIndex = 0;
	Vector3 position; // snapshot/appearance coordinates: X, height, horizontal Y
	Quaternion direction;
	float radius = 0;
};

class BuildoutData {
	Vector<BuildoutArea> areas;

public:
	void clear() { areas.removeAll(); }
	void readAreas(const DataTableIff& table, int sceneIndex);
	const Vector<BuildoutArea>& getAreas() const { return areas; }
	const BuildoutArea* findArea(float x, float y, bool ignoreInternal = true) const;
	bool isTraversable(float x0, float y0, float x1, float y1) const;
	static int findSceneIndex(const DataTableIff& table, const String& scene);
	static uint64 getObjectID(int id, int areaIndex);
	static void readObjects(const DataTableIff& table, const BuildoutArea& area, Vector<BuildoutObject>& objects);
};

#endif /* BUILDOUTDATA_H_ */
