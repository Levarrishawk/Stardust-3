#include "BuildoutData.h"
#include "templates/datatables/DataTableRow.h"
#include <cmath>

namespace {

class BuildoutColumns {
	const DataTableIff& table;
public:
	BuildoutColumns(const DataTableIff& value) : table(value) { }
	int column(const char* name, bool required = true) const {
		int index = table.getColumnIndexByName(name);
		if (index < 0 && required)
			throw Exception(String("Missing buildout column ") + name);
		return index;
	}
	int integer(const DataTableRow* row, int index, int fallback = 0) const {
		if (index < 0)
			return fallback;
		const DataTableCell* cell = row->getCell(index);
		if (cell->getType() == 'h') {
			uint32 value;
			cell->getValue(value);
			return (int) value;
		}
		if (cell->getType() == 'b') {
			bool value;
			cell->getValue(value);
			return value ? 1 : 0;
		}
		int value;
		cell->getValue(value);
		return value;
	}
	float real(const DataTableRow* row, int index, float fallback = 0) const {
		if (index < 0)
			return fallback;
		float value;
		row->getValue(index, value);
		if (!std::isfinite(value))
			throw Exception("Non-finite buildout coordinate or radius");
		return value;
	}
	String string(const DataTableRow* row, int index) const {
		String value;
		if (index >= 0)
			row->getValue(index, value);
		return value;
	}
};

} // namespace

Vector3 BuildoutArea::getRelativePosition(const Vector3& world) const {
	const BuildoutRectangle& rect = getMapBounds();
	return Vector3(world.getX() - (rect.x1 + rect.x2) * 0.5f, world.getY() - (rect.y1 + rect.y2) * 0.5f, world.getZ());
}

int BuildoutData::findSceneIndex(const DataTableIff& table, const String& scene) {
	BuildoutColumns columns(table);
	int name = columns.column("sceneName");
	for (int i = 0; i < table.getTotalRows(); ++i) {
		if (columns.string(table.getRow(i), name) == scene)
			return i;
	}
	return -1;
}

void BuildoutData::readAreas(const DataTableIff& table, int sceneIndex) {
	if (sceneIndex < 0 || (int64) sceneIndex * 100 + table.getTotalRows() > 65535)
		throw Exception("Buildout area index exceeds the client's 16-bit ID namespace");
	BuildoutColumns c(table);
	int name = c.column("area"), x1 = c.column("x1"), y1 = c.column("z1"), x2 = c.column("x2"), y2 = c.column("z2");
	int useClip = c.column("useClipRect", false);
	int cx1 = c.column("clipRectX1", false), cy1 = c.column("clipRectZ1", false), cx2 = c.column("clipRectX2", false), cy2 = c.column("clipRectZ2", false);
	int flags = c.column("envFlags", false), exclude = c.column("envFlagsExclude", false);
	int composite = c.column("compositeName", false);
	int mx1 = c.column("compositeX1", false), my1 = c.column("compositeZ1", false), mx2 = c.column("compositeX2", false), my2 = c.column("compositeZ2", false);
	int isolated = c.column("isolated", false), map = c.column("allowMap", false), internal = c.column("internal", false), radar = c.column("allowRadarTerrain", false);
	int event = c.column("eventRequired", false), origin = c.column("useOrigin", false), ox = c.column("originX", false), oy = c.column("originZ", false);
	Vector<BuildoutArea> parsed;
	for (int i = 0; i < table.getTotalRows(); ++i) {
		const DataTableRow* row = table.getRow(i);
		BuildoutArea area;
		area.index = sceneIndex * 100 + i;
		area.name = c.string(row, name);
		if (area.name.contains("/") || area.name.contains("\\") || area.name.contains(".."))
			throw Exception("Invalid buildout area name " + area.name);
		area.bounds.x1 = c.real(row, x1); area.bounds.y1 = c.real(row, y1);
		area.bounds.x2 = c.real(row, x2); area.bounds.y2 = c.real(row, y2);
		if (!area.bounds.valid())
			throw Exception("Invalid buildout rectangle for " + area.name);
		area.useClip = c.integer(row, useClip) != 0;
		area.clip.x1 = c.real(row, cx1); area.clip.y1 = c.real(row, cy1);
		area.clip.x2 = c.real(row, cx2); area.clip.y2 = c.real(row, cy2);
		if (area.useClip && !area.clip.valid())
			area.clip = area.bounds;
		area.environmentFlags = c.integer(row, flags, 255) & ~c.integer(row, exclude);
		area.compositeName = c.string(row, composite);
		area.composite.x1 = c.real(row, mx1); area.composite.y1 = c.real(row, my1);
		area.composite.x2 = c.real(row, mx2); area.composite.y2 = c.real(row, my2);
		if (!area.compositeName.isEmpty() && !area.composite.valid())
			throw Exception("Invalid composite buildout rectangle for " + area.name);
		area.useOrigin = c.integer(row, origin) != 0;
		area.originX = c.real(row, ox); area.originY = c.real(row, oy);
		area.isolated = c.integer(row, isolated, 1) != 0;
		area.allowMap = c.integer(row, map, 1) != 0;
		area.internal = c.integer(row, internal) != 0;
		area.allowRadarTerrain = c.integer(row, radar, 1) != 0;
		area.requiredEvent = c.string(row, event);
		parsed.add(area);
	}
	areas = parsed;
}

const BuildoutArea* BuildoutData::findArea(float x, float y, bool ignoreInternal) const {
	for (int i = 0; i < areas.size(); ++i) {
		const BuildoutArea& area = areas.get(i);
		if ((ignoreInternal && area.internal) || !area.requiredEvent.isEmpty())
			continue;
		if (area.bounds.contains(x, y))
			return &area;
	}
	return nullptr;
}

bool BuildoutData::isTraversable(float x0, float y0, float x1, float y1) const {
	const BuildoutArea* first = findArea(x0, y0);
	const BuildoutArea* second = findArea(x1, y1);
	if (first == second)
		return true;
	if (first == nullptr)
		return !second->isolated;
	if (second == nullptr)
		return !first->isolated;
	return first->name == second->name || (!first->isolated && !second->isolated);
}

uint64 BuildoutData::getObjectID(int id, int areaIndex) {
	if (areaIndex < 0 || areaIndex >= 65535)
		throw Exception("Invalid buildout area index");
	uint64 result = (uint64) (int64) id;
	if (id < 0)
		result ^= ((uint64) areaIndex + 1) << 48;
	return result;
}

void BuildoutData::readObjects(const DataTableIff& table, const BuildoutArea& area, Vector<BuildoutObject>& objects) {
	if (area.index < 0 || area.index >= 65535)
		throw Exception("Invalid buildout area index");
	BuildoutColumns c(table);
	int id = c.column("objid", false), container = c.column("container", false);
	if ((id < 0) != (container < 0))
		throw Exception("Buildout objid and container columns must occur together");
	int templ = c.column("shared_template_crc"), cell = c.column("cell_index"), portal = c.column("portal_layout_crc"), radius = c.column("radius");
	int px = c.column("px"), py = c.column("py"), pz = c.column("pz");
	int qw = c.column("qw"), qx = c.column("qx"), qy = c.column("qy"), qz = c.column("qz");
	int64 base = -((int64) area.index + 1) * 30000;
	int64 buildingID = base, objectID = base + 2000;
	uint64 currentBuilding = 0, currentCell = 0;
	Vector<BuildoutObject> parsed;
	VectorMap<uint64, int> indices;
	for (int i = 0; i < table.getTotalRows(); ++i) {
		const DataTableRow* row = table.getRow(i);
		BuildoutObject object;
		object.templateCRC = (uint32) c.integer(row, templ);
		object.cellIndex = c.integer(row, cell);
		object.portalLayoutCRC = (uint32) c.integer(row, portal);
		object.radius = c.real(row, radius);
		if (object.cellIndex < 0 || object.radius < 0)
			throw Exception("Invalid buildout cell index or radius");
		if (id >= 0) {
			object.objectID = getObjectID(c.integer(row, id), area.index);
			object.parentID = getObjectID(c.integer(row, container), area.index);
		} else {
			if (object.portalLayoutCRC != 0) {
				object.objectID = currentBuilding = (uint64) buildingID++;
			} else if (object.templateCRC == 0x0c5401ee) { // source's shared cell template CRC
				if (currentBuilding == 0)
					throw Exception("Buildout cell has no preceding building");
				object.objectID = currentCell = (uint64) buildingID++;
				object.parentID = currentBuilding;
			} else {
				object.objectID = (uint64) objectID++;
				if (object.cellIndex > 0) {
					if (currentCell == 0)
						throw Exception("Buildout interior object has no preceding cell");
					object.parentID = currentCell;
				}
			}
			if (buildingID >= base + 2000 || objectID > base + 30000)
				throw Exception("Buildout's implicit object IDs exceed the reserved range");
		}
		if (object.objectID == 0 || object.objectID == object.parentID || indices.contains(object.objectID))
			throw Exception("Zero, duplicate or self-parenting buildout object ID");
		if (object.cellIndex > 0 && object.parentID == 0)
			throw Exception("Buildout interior object has no container");
		if (object.portalLayoutCRC != 0 && (object.cellIndex != 0 || object.parentID != 0))
			throw Exception("Buildout portal building must be a world object");
		float x = c.real(row, px), y = c.real(row, py), z = c.real(row, pz);
		// WorldSnapshot::load uses the area's minimum, including on useOrigin rows.
		if (object.cellIndex == 0) {
			x += area.bounds.x1;
			z += area.bounds.y1;
		}
		if (!std::isfinite(x) || !std::isfinite(z))
			throw Exception("Buildout world coordinate overflow");
		object.position.set(x, y, z);
		float w = c.real(row, qw), a = c.real(row, qx), b = c.real(row, qy), d = c.real(row, qz);
		if (w == 0 && a == 0 && b == 0 && d == 0)
			throw Exception("Invalid zero buildout quaternion");
		object.direction.set(w, a, b, d);
		indices.put(object.objectID, parsed.size());
		parsed.add(object);
	}
	Vector<BuildoutObject> ordered;
	VectorMap<uint64, bool> ready;
	while (ordered.size() < parsed.size()) {
		int before = ordered.size();
		for (int i = 0; i < parsed.size(); ++i) {
			const BuildoutObject& object = parsed.get(i);
			if (ready.contains(object.objectID))
				continue;
			if (object.parentID != 0 && indices.contains(object.parentID) && !ready.contains(object.parentID))
				continue;
			ordered.add(object);
			ready.put(object.objectID, true);
		}
		if (before == ordered.size())
			throw Exception("Cycle in buildout object containers");
	}
	objects = ordered;
}
