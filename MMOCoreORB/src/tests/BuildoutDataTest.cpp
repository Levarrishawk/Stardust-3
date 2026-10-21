#include "gtest/gtest.h"
#include "templates/snapshot/BuildoutData.h"
#include "templates/snapshot/WorldSnapshotIff.h"
#include <cstring>
#include <string>
#include <vector>

namespace {

std::string word(uint32 value, bool bigEndian = false) {
	std::string bytes;
	for (int i = 0; i < 4; ++i)
		bytes += char(value >> (bigEndian ? 24 - i * 8 : i * 8));
	return bytes;
}
std::string real(float value) {
	uint32 bits;
	memcpy(&bits, &value, sizeof(bits));
	return word(bits);
}
std::string text(const char* value) { return std::string(value) + char(0); }
std::string chunk(const char* name, const std::string& data) { return std::string(name, 4) + word(data.size(), true) + data; }
std::string form(const char* name, const std::string& data) { return chunk("FORM", std::string(name, 4) + data); }

std::string table(const std::vector<const char*>& columns, const std::vector<const char*>& types, const std::vector<std::string>& rows) {
	std::string names = word(columns.size()), schema, values = word(rows.size());
	for (const char* name : columns)
		names += text(name);
	for (const char* type : types)
		schema += text(type);
	for (const auto& row : rows)
		values += row;
	return form("DTII", form("0001", chunk("COLS", names) + chunk("TYPE", schema) + chunk("ROWS", values)));
}
void read(DataTableIff& result, const std::string& bytes) {
	IffStream stream;
	stream.parseChunks((uint8*) bytes.data(), bytes.size(), "buildout fixture");
	result.readObject(&stream);
}
std::string areaRow(const char* name, float x1, float y1, float x2, float y2) {
	return text(name) + real(x1) + real(y1) + real(x2) + real(y2);
}
std::string areas(const std::vector<std::string>& rows) {
	return table({"area", "x1", "z1", "x2", "z2"}, {"s", "f", "f", "f", "f"}, rows);
}
std::string objectRow(uint32 templ, int cell = 0, int portal = 0, float x = 3, float height = 4, float y = 5) {
	return word(templ) + word(cell) + real(x) + real(height) + real(y)
		+ real(1) + real(0) + real(0) + real(0) + real(10) + word(portal);
}
std::string objects(bool explicitIDs, const std::vector<std::string>& rows) {
	std::vector<const char*> names = {"shared_template_crc", "cell_index", "px", "py", "pz", "qw", "qx", "qy", "qz", "radius", "portal_layout_crc"};
	std::vector<const char*> types = {"h", "i", "f", "f", "f", "f", "f", "f", "f", "f", "i"};
	if (explicitIDs) {
		names.insert(names.begin(), {"objid", "container"});
		types.insert(types.begin(), {"i", "i"});
	}
	return table(names, types, rows);
}
BuildoutArea area(int index = 1800) {
	BuildoutArea result;
	result.index = index;
	result.bounds.x1 = 100;
	result.bounds.y1 = 200;
	result.bounds.x2 = 500;
	result.bounds.y2 = 600;
	return result;
}

} // namespace

TEST(BuildoutDataTest, SceneOrderDeterminesAreaNamespace) {
	DataTableIff scenes;
	read(scenes, table({"sceneName", "adjust_map_coordinates"}, {"s", "b"}, {text("first") + word(0), text("mustafar") + word(0)}));
	EXPECT_EQ(1, BuildoutData::findSceneIndex(scenes, "mustafar"));
	EXPECT_EQ(-1, BuildoutData::findSceneIndex(scenes, "missing"));
	DataTableIff areaTable;
	read(areaTable, areas({areaRow("one", 0, 0, 100, 100), areaRow("two", 100, 0, 200, 100)}));
	BuildoutData data;
	data.readAreas(areaTable, 1);
	ASSERT_EQ(2, data.getAreas().size());
	EXPECT_EQ(100, data.getAreas().get(0).index);
	EXPECT_EQ(101, data.getAreas().get(1).index);
}

TEST(BuildoutDataTest, AreaFlagsClipFallbackAndCompositeCoordinates) {
	DataTableIff input;
	read(input, table({"area", "x1", "z1", "x2", "z2", "useClipRect", "envFlags", "envFlagsExclude", "compositeName", "compositeX1", "compositeZ1", "compositeX2", "compositeZ2", "useOrigin", "originX", "originZ"},
		{"s", "f", "f", "f", "f", "b", "i", "i", "s", "f", "f", "f", "f", "b", "f", "f"},
		{areaRow("area", 100, 200, 500, 600) + word(1) + word(255) + word(5) + text("composite") + real(0) + real(0) + real(1000) + real(2000) + word(1) + real(1234) + real(5678)}));
	BuildoutData data;
	data.readAreas(input, 0);
	const BuildoutArea& a = data.getAreas().get(0);
	EXPECT_TRUE(a.useClip);
	EXPECT_FLOAT_EQ(100, a.clip.x1);
	EXPECT_FLOAT_EQ(600, a.clip.y2);
	EXPECT_EQ(250, a.environmentFlags);
	EXPECT_TRUE(a.useOrigin);
	Vector3 relative = a.getRelativePosition(Vector3(600, 1200, 7));
	EXPECT_FLOAT_EQ(100, relative.getX());
	EXPECT_FLOAT_EQ(200, relative.getY());
	EXPECT_FLOAT_EQ(7, relative.getZ());
}

TEST(BuildoutDataTest, IsolatedAreasAndRepeatedNamesMatchReferenceTraversal) {
	DataTableIff input;
	read(input, areas({areaRow("instance", 0, 0, 100, 100), areaRow("instance", 200, 0, 300, 100), areaRow("other", 400, 0, 500, 100)}));
	BuildoutData data;
	data.readAreas(input, 0);
	EXPECT_TRUE(data.isTraversable(-50, -50, -20, -20));
	EXPECT_TRUE(data.isTraversable(10, 10, 90, 90));
	EXPECT_TRUE(data.isTraversable(10, 10, 250, 10));
	EXPECT_FALSE(data.isTraversable(10, 10, 450, 10));
	EXPECT_FALSE(data.isTraversable(-50, -50, 10, 10));
	EXPECT_FALSE(data.isTraversable(10, 10, -50, -50));
}

TEST(BuildoutDataTest, InternalAndInactiveEventAreasAreFiltered) {
	DataTableIff input;
	read(input, table({"area", "x1", "z1", "x2", "z2", "internal", "eventRequired"}, {"s", "f", "f", "f", "f", "b", "s"},
		{areaRow("internal", 0, 0, 100, 100) + word(1) + text(""), areaRow("event", 200, 0, 300, 100) + word(0) + text("fixture_event")}));
	BuildoutData data;
	data.readAreas(input, 0);
	EXPECT_EQ(nullptr, data.findArea(10, 10));
	EXPECT_NE(nullptr, data.findArea(10, 10, false));
	EXPECT_EQ(nullptr, data.findArea(250, 10, false));
}

TEST(BuildoutDataTest, ImplicitIdsAndBuildingCellContainment) {
	DataTableIff input;
	read(input, objects(false, {objectRow(123, 0, 99), objectRow(0x0c5401ee, 1), objectRow(456, 1)}));
	Vector<BuildoutObject> parsed;
	BuildoutArea a = area();
	BuildoutData::readObjects(input, a, parsed);
	ASSERT_EQ(3, parsed.size());
	int64 base = -1801LL * 30000;
	EXPECT_EQ((uint64) base, parsed.get(0).objectID);
	EXPECT_EQ((uint64) (base + 1), parsed.get(1).objectID);
	EXPECT_EQ((uint64) base, parsed.get(1).parentID);
	EXPECT_EQ((uint64) (base + 2000), parsed.get(2).objectID);
	EXPECT_EQ(parsed.get(1).objectID, parsed.get(2).parentID);
	EXPECT_FLOAT_EQ(103, parsed.get(0).position.getX());
	EXPECT_FLOAT_EQ(205, parsed.get(0).position.getZ());
	EXPECT_FLOAT_EQ(3, parsed.get(2).position.getX());
	EXPECT_FLOAT_EQ(4, parsed.get(2).position.getY());
}

TEST(BuildoutDataTest, ExplicitIdsKeep64BitsAndSortParentsBeforeChildren) {
	EXPECT_EQ(0xf8f6fffffffffff9ULL, BuildoutData::getObjectID(-7, 1800));
	EXPECT_EQ(42ULL, BuildoutData::getObjectID(42, 1800));
	DataTableIff input;
	read(input, objects(true, {word(-3) + word(-2) + objectRow(456, 1), word(-2) + word(-1) + objectRow(0x0c5401ee, 1), word(-1) + word(0) + objectRow(123, 0, 99)}));
	Vector<BuildoutObject> parsed;
	BuildoutData::readObjects(input, area(), parsed);
	ASSERT_EQ(3, parsed.size());
	EXPECT_EQ(BuildoutData::getObjectID(-1, 1800), parsed.get(0).objectID);
	EXPECT_EQ(parsed.get(0).objectID, parsed.get(1).parentID);
	EXPECT_EQ(parsed.get(1).objectID, parsed.get(2).parentID);
	WorldSnapshotNode node(parsed.get(2), 7);
	WorldSnapshotNode copied = node;
	EXPECT_TRUE(copied.isBuildout());
	EXPECT_EQ(parsed.get(2).objectID, copied.getObjectID());
	EXPECT_EQ(parsed.get(2).parentID, copied.getParentID());
}

TEST(BuildoutDataTest, ReusedTableGetsDistinctAreaIdsAndWorldOffsets) {
	DataTableIff input;
	read(input, objects(true, {word(-7) + word(0) + objectRow(123)}));
	BuildoutArea first = area(), second = area(1801);
	second.bounds.x1 = 1000;
	Vector<BuildoutObject> a, b;
	BuildoutData::readObjects(input, first, a);
	BuildoutData::readObjects(input, second, b);
	EXPECT_NE(a.get(0).objectID, b.get(0).objectID);
	EXPECT_FLOAT_EQ(103, a.get(0).position.getX());
	EXPECT_FLOAT_EQ(1003, b.get(0).position.getX());
}

TEST(BuildoutDataTest, RejectsDuplicateCycleOrUnparentedInterior) {
	for (const std::string& rows : {objects(true, {word(-1) + word(0) + objectRow(123), word(-1) + word(0) + objectRow(456)}),
		objects(true, {word(-1) + word(-2) + objectRow(123, 1), word(-2) + word(-1) + objectRow(456, 1)}),
		objects(true, {word(-1) + word(0) + objectRow(123, 1)})}) {
		DataTableIff input;
		read(input, rows);
		Vector<BuildoutObject> parsed;
		EXPECT_THROW(BuildoutData::readObjects(input, area(), parsed), Exception);
		EXPECT_EQ(0, parsed.size());
	}
}

TEST(BuildoutDataTest, MissingColumnsAndInvalidAreaDoNotReplaceLoadedAreas) {
	DataTableIff valid, invalid;
	read(valid, areas({areaRow("valid", 0, 0, 100, 100)}));
	read(invalid, areas({areaRow("invalid", 100, 0, 0, 100)}));
	BuildoutData data;
	data.readAreas(valid, 0);
	EXPECT_THROW(data.readAreas(invalid, 0), Exception);
	ASSERT_EQ(1, data.getAreas().size());
	EXPECT_EQ(String("valid"), data.getAreas().get(0).name);
	DataTableIff badSchema;
	read(badSchema, table({"objid"}, {"i"}, {word(-1)}));
	Vector<BuildoutObject> parsed;
	EXPECT_THROW(BuildoutData::readObjects(badSchema, area(), parsed), Exception);
}

TEST(BuildoutDataTest, OlderSnapshotIdsRetainUnsigned32BitMeaning) {
	std::string values = word(0xf1234567) + word(0) + word(0) + word(0) + real(1) + real(0) + real(0) + real(0)
		+ real(1) + real(2) + real(3) + real(10) + word(0);
	std::string bytes = form("WSNP", form("0001", form("NODS", form("NODE", form("0000", chunk("DATA", values)))) + chunk("OTNL", word(1) + text("object/fixture/shared_fixture.iff"))));
	IffStream stream;
	stream.parseChunks((uint8*) bytes.data(), bytes.size(), "legacy snapshot fixture");
	WorldSnapshotIff snapshot;
	snapshot.readObject(&stream);
	ASSERT_EQ(1, snapshot.getNodeCount());
	EXPECT_EQ(0xf1234567ULL, snapshot.getNode(0)->getObjectID());
	EXPECT_FALSE(snapshot.getNode(0)->isBuildout());
}
