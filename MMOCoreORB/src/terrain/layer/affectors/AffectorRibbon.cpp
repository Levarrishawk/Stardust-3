#include "AffectorRibbon.h"

void AffectorRibbon::createWaterSurfaces() {
	waterSurfaces.removeAll();
	if (points.size() < 2 || width <= 0)
		return;

	struct Segment {
		Vector3 top, bottom, direction, topNormal, bottomNormal;
	};
	ArrayList<Segment> segments;
	float halfWidth = width / 2.f;
	for (int i = 0; i < points.size() - 1; ++i) {
		Segment segment;
		segment.top = points.get(i);
		segment.bottom = points.get(i + 1);
		segment.direction = segment.bottom - segment.top;
		segment.direction.setZ(0);
		if (segment.direction.squaredLength() == 0)
			continue;
		segment.direction.normalize();
		segment.topNormal = segment.bottomNormal = Vector3(segment.direction.getY(), -segment.direction.getX(), 0);
		if (segments.size() == 0) {
			Segment first = segment;
			first.bottom = segment.top;
			first.top = first.bottom - first.direction * halfWidth;
			segments.add(first);
		}
		segments.add(segment);
	}
	if (segments.size() == 0)
		return;
	Segment last = segments.get(segments.size() - 1);
	last.top = last.bottom;
	last.bottom = last.top + last.direction * halfWidth;
	segments.add(last);
	for (int i = 1; i < segments.size(); ++i) {
		Vector3 normal = (segments.get(i).topNormal + segments.get(i - 1).bottomNormal) / 2.f;
		segments.get(i).topNormal = normal;
		segments.get(i - 1).bottomNormal = normal;
	}
	for (int i = 0; i < segments.size(); ++i) {
		const Segment& segment = segments.get(i);
		Vector3 a = segment.top + segment.topNormal * halfWidth;
		Vector3 b = segment.top - segment.topNormal * halfWidth;
		Vector3 c = segment.bottom - segment.bottomNormal * halfWidth;
		Vector3 d = segment.bottom + segment.bottomNormal * halfWidth;
		waterSurfaces.add(TerrainWaterSurface(a, b, c, waterType));
		waterSurfaces.add(TerrainWaterSurface(a, c, d, waterType));
	}
	if (capWidth <= 0)
		return;

	Vector3 up = points.get(0) - points.get(1);
	up.setZ(0);
	if (up.squaredLength() == 0)
		return;
	up.normalize();
	Vector3 right(up.getY(), -up.getX(), 0);
	Vector3 cap[8];
	cap[0] = points.get(0) - right * (capWidth / 2.f);
	up = up * capWidth;
	right = right * capWidth;
	cap[1] = cap[0] + up - right;
	cap[2] = cap[1] + up;
	cap[3] = cap[2] + right + up;
	cap[4] = cap[3] + right;
	cap[5] = cap[4] - up + right;
	cap[6] = cap[5] - up;
	cap[7] = cap[6] - right - up;
	for (int i = 1; i < 4; ++i)
		waterSurfaces.add(TerrainWaterSurface(cap[0], cap[i], cap[i + 1], waterType));
	waterSurfaces.add(TerrainWaterSurface(cap[4], cap[5], cap[6], waterType));
	waterSurfaces.add(TerrainWaterSurface(cap[4], cap[6], cap[7], waterType));
	waterSurfaces.add(TerrainWaterSurface(cap[4], cap[7], cap[0], waterType));
}
