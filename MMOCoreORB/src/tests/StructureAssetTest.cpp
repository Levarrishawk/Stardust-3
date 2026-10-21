#include "gtest/gtest.h"
#include "templates/building/SharedBuildingObjectTemplate.h"
#include "templates/appearance/PortalLayout.h"
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
std::string parameter(const char* name, const std::string& data) { return chunk("XXXX", text(name) + data); }
std::string stringValue(const char* value) { return char(1) + text(value); }
std::string floatValue(float value) { return std::string("\x01\x20", 2) + real(value); }
std::string parameters(const char* version, const std::vector<std::string>& values) {
	std::string data = chunk("PCNT", word(values.size()));
	for (const auto& value : values)
		data += value;
	return form(version, data);
}
void read(IffTemplate& result, const std::string& bytes) {
	IffStream stream;
	stream.parseChunks((uint8*) bytes.data(), bytes.size(), "structure reader fixture");
	result.readObject(&stream);
	EXPECT_EQ(0, stream.getRemainingSubChunksNumber());
}
std::string cell(bool missingFloor, bool modern = true) {
	std::string data = word(0) + char(0) + text("room") + text("") + char(missingFloor ? 1 : 0);
	if (missingFloor)
		data += text("appearance/collision/core3_missing_structure_test.flr");
	return form("CELL", form(modern ? "0005" : "0004", chunk("DATA", data) + (modern ? form("NULL", "") : "")));
}

} // namespace

TEST(StructureAssetTest, NestedBuildingVersionsPreserveInheritedParameters) {
	for (bool modern : {false, true}) {
		SharedBuildingObjectTemplate object;
		// Apply a base first, then skip the repeated DERV reference in each class layer.
		read(object, form("SHOT", parameters(modern ? "0010" : "0008", {
			parameter("appearanceFilename", stringValue("appearance/base.apt")),
			parameter("snapToTerrain", std::string("\x01\x00", 2)),
			parameter("clearFloraRadius", floatValue(12))
		})));
		object.addDerivedFile("object/building/base/shared_structure_reader_test.iff");
		std::string derv = form("DERV", chunk("XXXX", text("object/building/base/shared_structure_reader_test.iff")));
		std::vector<std::string> tangible = {parameter("targetable", std::string("\x01\x00", 2))};
		if (modern)
			tangible.push_back(parameter("clientVisabilityFlag", std::string("\x00\x20", 2)));
		std::string shot = form("SHOT", derv + parameters(modern ? "0010" : "0008", {
			parameter("appearanceFilename", std::string(1, char(0))),
			parameter("portalLayoutFilename", stringValue("appearance/structure_reader_test.pob")),
			parameter("clientDataFile", stringValue("clientdata/structure_reader_test.cdf")),
			parameter("clearFloraRadius", floatValue(38)),
			parameter("snapToTerrain", std::string(1, char(0)))
		}));
		std::string stot = form("STOT", derv + parameters(modern ? "0010" : "0007", tangible) + shot);
		read(object, form("SBOT", derv + parameters("0001", {
			parameter("terrainModificationFileName", std::string(1, char(0))),
			parameter("interiorLayoutFileName", std::string(1, char(0)))
		}) + stot));
		EXPECT_EQ(String("appearance/base.apt"), object.getAppearanceFilename());
		EXPECT_EQ(String("appearance/structure_reader_test.pob"), object.getPortalLayoutFilename());
		EXPECT_EQ(String("clientdata/structure_reader_test.cdf"), object.getClientDataFile());
		EXPECT_FLOAT_EQ(38, object.getClearFloraRadius());
		EXPECT_FALSE(object.getSnapToTerrain());
		EXPECT_FALSE(object.getTargetable());
	}
}

TEST(StructureAssetTest, CanonicalAndLegacyPaletteNamesRemainReadable) {
	SharedObjectTemplate object;
	read(object, form("SHOT", parameters("0010", {parameter("tintPalette", stringValue("palette/canonical.pal"))})));
	EXPECT_EQ(String("palette/canonical.pal"), object.getTintPallete());
	read(object, form("SHOT", parameters("0008", {parameter("tintPallete", stringValue("palette/legacy.pal"))})));
	EXPECT_EQ(String("palette/legacy.pal"), object.getTintPallete());
	read(object, form("SHOT", parameters("0010", {parameter("tintPalette", std::string(1, char(0)))})));
	EXPECT_EQ(String("palette/legacy.pal"), object.getTintPallete());
}

TEST(StructureAssetTest, ExplicitEmptyDependencyClearsInheritedFilename) {
	SharedObjectTemplate object;
	read(object, form("SHOT", parameters("0008", {parameter("portalLayoutFilename", stringValue("appearance/base.pob"))})));
	read(object, form("SHOT", parameters("0010", {parameter("portalLayoutFilename", stringValue(""))})));
	EXPECT_TRUE(object.getPortalLayoutFilename().isEmpty());
}

TEST(StructureAssetTest, UnknownNamedParameterDoesNotShiftFollowingValues) {
	SharedObjectTemplate object;
	read(object, form("SHOT", parameters("0010", {
		parameter("futureClientOnlyField", std::string(17, char(42))),
		parameter("portalLayoutFilename", stringValue("appearance/after_unknown.pob")),
		parameter("clearFloraRadius", floatValue(38))
	})));
	EXPECT_EQ(String("appearance/after_unknown.pob"), object.getPortalLayoutFilename());
	EXPECT_FLOAT_EQ(38, object.getClearFloraRadius());
}

TEST(StructureAssetTest, MissingCellFloorDoesNotDereferenceNull) {
	for (bool modern : {false, true}) {
		CellProperty property(3);
		read(property, cell(true, modern));
		EXPECT_EQ(nullptr, property.getFloorMesh());
		EXPECT_EQ(String("room"), property.getName());
		EXPECT_EQ(3, property.getCellID());
	}
}

TEST(StructureAssetTest, FloorGraphSearchSkipsCellsWithoutFloorMeshes) {
	std::string graph = form("PGRF", form("0001", chunk("META", word(0))
		+ chunk("PNOD", word(0)) + chunk("PEDG", word(0))
		+ chunk("ECNT", word(0)) + chunk("ESTR", word(0))));
	PortalLayout layout;
	read(layout, form("PRTO", form("0004", chunk("DATA", word(0) + word(2))
		+ form("PRTS", "") + form("CELS", cell(false) + cell(false)) + graph)));
	EXPECT_EQ(1, layout.getCellTotalNumber());
	EXPECT_EQ(-1, layout.getFloorMeshID(7, -1));
}
