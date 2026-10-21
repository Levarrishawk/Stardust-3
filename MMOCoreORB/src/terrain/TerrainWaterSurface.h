#ifndef TERRAINWATERSURFACE_H_
#define TERRAINWATERSURFACE_H_

#include "TemplateVariable.h"
#include "engine/util/u3d/AABB.h"

// Terrain coordinates: X/Y are horizontal, Z is height.
struct TerrainWaterSurface : public Object {
	Vector3 points[3];
	int waterType = 0;

	TerrainWaterSurface() { }

	TerrainWaterSurface(const Vector3& a, const Vector3& b, const Vector3& c, int type) : waterType(type) {
		points[0] = a;
		points[1] = b;
		points[2] = c;
	}

	bool getHeight(float x, float y, float& height) const {
		float ax = points[1].getX() - points[0].getX();
		float ay = points[1].getY() - points[0].getY();
		float bx = points[2].getX() - points[0].getX();
		float by = points[2].getY() - points[0].getY();
		float determinant = ax * by - ay * bx;
		if (fabs(determinant) < 0.000001f)
			return false;
		float dx = x - points[0].getX();
		float dy = y - points[0].getY();
		float u = (dx * by - dy * bx) / determinant;
		float v = (ax * dy - ay * dx) / determinant;
		if (u < -0.000001f || v < -0.000001f || u + v > 1.000001f)
			return false;
		height = points[0].getZ() + u * (points[1].getZ() - points[0].getZ()) + v * (points[2].getZ() - points[0].getZ());
		return true;
	}

	bool overlaps(const AABB& bounds) const {
		float minX = Math::min(points[0].getX(), Math::min(points[1].getX(), points[2].getX()));
		float maxX = Math::max(points[0].getX(), Math::max(points[1].getX(), points[2].getX()));
		float minY = Math::min(points[0].getY(), Math::min(points[1].getY(), points[2].getY()));
		float maxY = Math::max(points[0].getY(), Math::max(points[1].getY(), points[2].getY()));
		// Navmesh bounds use X/height/Y.
		return maxX >= bounds.getXMin() && minX <= bounds.getXMax() && maxY >= bounds.getZMin() && minY <= bounds.getZMax();
	}
};

#endif /* TERRAINWATERSURFACE_H_ */
