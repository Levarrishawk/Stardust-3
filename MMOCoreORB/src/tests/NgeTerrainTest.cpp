#include "gtest/gtest.h"

#include "terrain/ProceduralTerrainAppearance.h"
#include "terrain/layer/boundaries/BoundaryPolygon.h"
#include "terrain/layer/boundaries/BoundaryPolyline.h"
#include "terrain/layer/affectors/AffectorRoad.h"
#include "terrain/layer/affectors/AffectorRibbon.h"
#include "terrain/layer/filters/FilterBitmap.h"
#include "templates/SharedObjectTemplate.h"

#include <cstring>
#include <string>

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

std::string text(const char* value) {
	return std::string(value) + char(0);
}

std::string chunk(const char* tag, const std::string& data) {
	return std::string(tag, 4) + word(data.size(), true) + data;
}

std::string form(const char* tag, const std::string& data) {
	return chunk("FORM", std::string(tag, 4) + data);
}

std::string info(bool enabled = true) {
	return form("IHDR", form("0001", chunk("DATA", word(enabled ? 1 : 0) + text("fixture"))));
}

std::string polygon(const char* version, int waterType = 0, float waterHeight = 8) {
	std::string data = word(4) + real(-10) + real(-10) + real(10) + real(-10)
		+ real(10) + real(10) + real(-10) + real(10);
	data += word(0) + real(0) + word(1) + real(waterHeight) + real(2);
	if (std::string(version) != "0005")
		data += word(waterType);
	data += text("water_fixture");
	return form("BPOL", form(version, info() + chunk("DATA", data)));
}

std::string layer(const char* version, const std::string& children, bool enabled = true) {
	std::string data = word(0) + word(0);
	if (std::string(version) == "0004")
		data += word(0x12345678); // unused field precedes the expanded flag
	data += word(1) + text("notes");
	return form("LAYR", form(version, info(enabled) + chunk("ADTA", data) + children));
}

std::string packedMap(int width = 64, int height = 64, int bits = 0, int minimum = 0, const std::string& bytes = std::string(1, char(0))) {
	return form("PIMP", form("0000", chunk("CNTL", word(width) + word(height) + word(bits) + word(minimum)) + chunk("DATA", bytes)));
}

std::string ribbon(float capWidth = 0, int waterType = 1, bool enabled = true) {
	std::string data = word(2) + real(0) + real(0) + real(10) + real(100) + real(0) + real(30)
		+ real(20) + real(2) + real(1) + real(capWidth) + word(1) + word(0) + real(0) + text("water_fixture") + word(waterType);
	return form("ARIB", form("0005", info(enabled) + form("DATA", chunk("DATA", data))));
}

std::string terrain(const char* version, const char* boundaryVersion, const char* layerVersion, const std::string& extraRules = "") {
	std::string header = text("fixture.trn") + real(1024) + real(32) + word(8)
		+ word(0) + real(0) + real(2) + text("") + real(60);
	if (std::string(version) == "0013") {
		header += text("") + text("");
		for (int i = 0; i < 4; ++i)
			header += real(0) + text("");
		header += word(0) + text("");
	}
	for (int i = 0; i < 4; ++i)
		header += real(0) + real(0) + real(0) + real(0) + word(0);
	if (std::string(version) == "0015")
		header += char(0); // NGE map, not a legacy-converted map

	std::string rules = polygon(boundaryVersion);
	rules += form("AHCN", form("0000", info() + chunk("DATA", word(0) + real(42))));
	rules += form("APAS", form("0000", info() + chunk("DATA", std::string(1, char(0)) + word(0))));
	rules += extraRules;
	std::string generator = form("SGRP", form("0006", "")) + form("FGRP", form("0008", ""))
		+ form("RGRP", form("0003", "")) + form("EGRP", form("0002", ""))
		+ form("MGRP", form("0000", "")) + form("MGRP", form("0000", ""))
		+ form("LYRS", layer(layerVersion, rules));
	std::string body = chunk("DATA", header) + form("TGEN", form("0000", generator)) + form("0000", "");
	if (std::string(version) == "0015")
		body += packedMap() + form("PFPM", packedMap() + form("0000", chunk("CNTL", real(0.01f))));
	return form("PTAT", form(version, body));
}

void parse(IffStream& stream, const std::string& bytes) {
	stream.parseChunks((uint8*)bytes.data(), bytes.size(), "in-memory terrain fixture");
}

std::string road(const char* version, bool fixed, int heights = 2) {
	std::string data = word(2) + real(0) + real(0) + real(100) + real(0);
	if (std::string(version) == "0006") {
		data += word(heights);
		for (int i = 0; i < heights; ++i)
			data += real(10 + i * 20);
	}
	data += real(20) + word(1) + word(0) + real(0) + word(0) + real(0);
	if (std::string(version) == "0006")
		data += word(fixed ? 1 : 0);
	return form("AROA", form(version, info() + form("DATA", form("HDTA", form("0001", "")) + chunk("DATA", data))));
}

} // namespace

TEST(NgeTerrainTest, OlderAndNewerTerrainKeepHeightWaterAndPassability) {
	const char* versions[] = {"0013", "0014", "0015"};
	for (const char* version : versions) {
		SCOPED_TRACE(version);
		bool nge = std::string(version) == "0015";
		IffStream stream;
		parse(stream, terrain(version, nge ? "0007" : "0005", nge ? "0004" : "0003"));
		ProceduralTerrainAppearance appearance;
		ASSERT_TRUE(appearance.load(&stream));
		EXPECT_FLOAT_EQ(42.f, appearance.getHeight(0, 0));
		EXPECT_FLOAT_EQ(0.f, appearance.getHeight(100, 100));
		float waterHeight = 0;
		EXPECT_TRUE(appearance.getWater(0, 0, waterHeight));
		EXPECT_FLOAT_EQ(8.f, waterHeight);
		EXPECT_FALSE(appearance.getWater(100, 100, waterHeight));
		EXPECT_FALSE(appearance.isPassable(0, 0));
		EXPECT_TRUE(appearance.isPassable(100, 100));
		EXPECT_EQ(!nge, appearance.isLegacyMap());
		EXPECT_EQ(0, stream.getRemainingSubChunksNumber());
	}
}

TEST(NgeTerrainTest, PolygonWaterTypePrecedesShaderName) {
	IffStream stream;
	parse(stream, polygon("0007", 1));
	BoundaryPolygon boundary;
	boundary.readObject(&stream);
	EXPECT_EQ(1, boundary.getWaterType());
	EXPECT_FLOAT_EQ(8.f, boundary.getLocalWaterTableHeight());
	EXPECT_TRUE(boundary.containsPoint(0, 0));
}

TEST(NgeTerrainTest, Polyline0001And0003HaveTheSameInfluence) {
	for (const char* version : {"0001", "0003"}) {
		IffStream stream;
		std::string data = word(2) + real(0) + real(0) + real(100) + real(0) + word(0) + real(0) + real(5);
		parse(stream, form("BPLN", form(version, info() + chunk("DATA", data))));
		BoundaryPolyline boundary;
		boundary.readObject(&stream);
		EXPECT_FLOAT_EQ(1.f, boundary.process(50, 0));
		EXPECT_FLOAT_EQ(0.f, boundary.process(50, 10));
	}
}

TEST(NgeTerrainTest, FixedRoadInterpolatesAndDoesNotAffectOutsideWidth) {
	IffStream stream;
	parse(stream, road("0006", true));
	AffectorRoad affector;
	affector.readObject(&stream);
	float height = 0;
	affector.process(50, 0, 1, height, nullptr);
	EXPECT_FLOAT_EQ(20.f, height);
	height = 7;
	affector.process(50, 11, 1, height, nullptr);
	EXPECT_FLOAT_EQ(7.f, height);
	height = 0;
	affector.process(50, 0, 0.5f, height, nullptr);
	EXPECT_FLOAT_EQ(10.f, height);
}

TEST(NgeTerrainTest, Road0005RemainsReadableAndHasNoFixedHeightEffect) {
	IffStream stream;
	parse(stream, road("0005", false));
	AffectorRoad affector;
	affector.readObject(&stream);
	float height = 7;
	affector.process(1000, 1000, 1, height, nullptr);
	EXPECT_FLOAT_EQ(7.f, height);
}

TEST(NgeTerrainTest, BitmapGainIsVersionedAndClamped) {
	TerrainGenerator generator(nullptr);
	IffStream groupStream;
	std::string family = form("MFAM", chunk("DATA", word(7) + text("fixture") + text("nonexistent-nge-fixture.tga")));
	parse(groupStream, form("MGRP", form("0000", family)));
	generator.getBitmapGroup()->readObject(&groupStream);
	TargaBitmap* bitmap = generator.getBitmapGroup()->getBitmap(7);
	ASSERT_NE(nullptr, bitmap);
	std::string image(18, char(0));
	image[2] = 3; // uncompressed grayscale
	image[12] = image[14] = 2;
	image[16] = 8;
	image += std::string(4, char(128));
	ObjectInputStream imageStream((char*)image.data(), image.size());
	bitmap->readObject(&imageStream);

	const char* versions[] = {"0000", "0001", "0001", "0001"};
	const float gains[] = {0, -0.25f, 1.f, -1.f};
	const float expected[] = {128.f / 255.f, 128.f / 255.f - 0.25f, 0.99999f, 0};
	FilterRectangle rect;
	rect.minX = rect.minY = 0;
	rect.maxX = rect.maxY = 1;
	for (int i = 0; i < 4; ++i) {
		IffStream stream;
		std::string params = word(7) + word(0) + real(0) + real(0) + real(1);
		if (i != 0)
			params += real(gains[i]);
		parse(stream, form("FBIT", form(versions[i], info() + form("DATA", chunk("PARM", params)))));
		FilterBitmap filter;
		filter.readObject(&stream);
		float height = 0;
		EXPECT_NEAR(expected[i], filter.process(0.5f, 0.5f, 1, height, &generator, &rect), 0.000001f);
	}
}

TEST(NgeTerrainTest, FixedRoadRejectsMismatchedHeightList) {
	IffStream stream;
	parse(stream, road("0006", true, 1));
	AffectorRoad affector;
	EXPECT_THROW(affector.readObject(&stream), Exception);
}

TEST(NgeTerrainTest, RibbonPreservesControlPointHeightsWithoutChangingTerrain) {
	std::string data = word(2) + real(0) + real(0) + real(10) + real(100) + real(0) + real(30)
		+ real(20) + real(2) + real(1) + real(0) + word(1) + word(0) + real(0) + text("lava_fixture") + word(1);
	IffStream stream;
	parse(stream, form("ARIB", form("0005", info() + form("DATA", chunk("DATA", data)))));
	AffectorRibbon affector;
	affector.readObject(&stream);
	ASSERT_EQ(2, affector.getControlPoints().size());
	EXPECT_FLOAT_EQ(30.f, affector.getControlPoints().get(1).getZ());
	EXPECT_EQ(1, affector.getWaterType());
	float height = 7;
	affector.process(50, 0, 1, height, nullptr);
	EXPECT_FLOAT_EQ(7.f, height);
}

TEST(NgeTerrainTest, UnknownTerrainVersionIsRejected) {
	IffStream stream;
	parse(stream, form("PTAT", form("9999", "")));
	ProceduralTerrainAppearance appearance;
	EXPECT_THROW(appearance.load(&stream), Exception);
}

TEST(NgeTerrainTest, ObjectTemplate0005And0010KeepNamedParameterAlignment) {
	for (const char* version : {"0005", "0010"}) {
		std::string params = chunk("PCNT", word(3));
		params += chunk("XXXX", text("unknownClientParameter") + word(0x12345678));
		params += chunk("XXXX", text("containerVolumeLimit") + char(1) + char(0x20) + word(42));
		params += chunk("XXXX", text("appearanceFilename") + char(1) + text("appearance/fixture.apt"));
		IffStream stream;
		parse(stream, form("SHOT", form(version, params)));
		SharedObjectTemplate object;
		object.readObject(&stream);
		EXPECT_EQ(42, object.getContainerVolumeLimit());
		EXPECT_EQ(String("appearance/fixture.apt"), object.getAppearanceFilename());
	}
}

TEST(NgeTerrainTest, RibbonQueriesIncludeSlopesCapsAndWaterType) {
	IffStream stream;
	parse(stream, terrain("0015", "0007", "0003", ribbon(10)));
	ProceduralTerrainAppearance appearance;
	ASSERT_TRUE(appearance.load(&stream));
	float height = -123;
	int type = -1;
	ASSERT_TRUE(appearance.getWaterSurface(50, 0, height, type));
	EXPECT_FLOAT_EQ(20.f, height);
	EXPECT_EQ(1, type);
	ASSERT_TRUE(appearance.getWater(-20, 0, height));
	EXPECT_FLOAT_EQ(10.f, height);
	ASSERT_TRUE(appearance.getWater(0, 0, height));
	EXPECT_FLOAT_EQ(10.f, height); // above the polygon's 8-metre table
	height = -123;
	EXPECT_FALSE(appearance.getWaterSurface(50, 11, height, type));
	EXPECT_FLOAT_EQ(-123.f, height);
	EXPECT_EQ(-1, type);
	Vector<TerrainWaterSurface> surfaces;
	appearance.getRibbonWaterInAABB(AABB(Vector3(40, -100, -2), Vector3(60, 100, 2)), surfaces);
	EXPECT_EQ(2, surfaces.size());
}

TEST(NgeTerrainTest, DisabledRibbonAndDisabledParentDoNotAddWater) {
	IffStream stream;
	std::string rules = ribbon(0, 1, false) + layer("0003", ribbon(), false);
	parse(stream, terrain("0015", "0007", "0003", rules));
	ProceduralTerrainAppearance appearance;
	ASSERT_TRUE(appearance.load(&stream));
	float height;
	EXPECT_FALSE(appearance.getWater(50, 0, height));
}

TEST(NgeTerrainTest, ReloadingOlderTerrainDropsNativeWaterAndFloraState) {
	ProceduralTerrainAppearance appearance;
	IffStream nge;
	parse(nge, terrain("0015", "0007", "0003", ribbon()));
	ASSERT_TRUE(appearance.load(&nge));
	float height;
	ASSERT_TRUE(appearance.getWater(50, 0, height));
	IffStream old;
	parse(old, terrain("0014", "0005", "0003"));
	ASSERT_TRUE(appearance.load(&old));
	EXPECT_FALSE(appearance.hasNgeTerrainData());
	EXPECT_FALSE(appearance.hasStaticFlora());
	EXPECT_FALSE(appearance.getWater(50, 0, height));
	ASSERT_TRUE(appearance.getWater(0, 0, height));
	EXPECT_FLOAT_EQ(8.f, height);
}

TEST(NgeTerrainTest, PackedMapReadsCrossByteFieldsAndSignedMinimum) {
	IffStream stream;
	std::string bytes;
	bytes += char(0x21);
	bytes += char(0x7e); // 5-bit values 1, 17, 31
	parse(stream, packedMap(3, 1, 5, -4, bytes));
	PackedTerrainMap map;
	map.readObject(&stream);
	EXPECT_EQ(-3, map.getValue(0, 0));
	EXPECT_EQ(13, map.getValue(1, 0));
	EXPECT_EQ(27, map.getValue(2, 0));
	EXPECT_THROW(map.getValue(3, 0), Exception);

	IffStream constant;
	parse(constant, packedMap(2, 3, 0, -320));
	map.readObject(&constant);
	EXPECT_EQ(-320, map.getValue(1, 2));
}

TEST(NgeTerrainTest, PackedMapRejectsBadLengthAndResolution) {
	IffStream stream;
	parse(stream, packedMap(3, 1, 5, 0)); // requires two data bytes
	PackedTerrainMap map;
	EXPECT_THROW(map.readObject(&stream), Exception);
	IffStream height;
	parse(height, packedMap(1, 1) + form("PFPM", packedMap(1, 1) + form("0000", chunk("CNTL", real(0)))));
	StaticFlora flora;
	EXPECT_THROW(flora.readObject(&height), Exception);
}

TEST(NgeTerrainTest, ParticleFloraDoesNotBecomeSolid) {
	IffStream maps;
	parse(maps, packedMap(1, 1, 0, 1) + form("PFPM", packedMap(1, 1, 0, -320) + form("0000", chunk("CNTL", real(1.f / 32.f)))));
	StaticFlora flora;
	flora.readObject(&maps);
	std::string family = word(1) + text("particles") + std::string(3, char(0)) + real(1) + word(0) + word(1)
		+ text("particle_fixture.prt") + real(1) + word(0) + real(0) + real(0) + word(0) + word(0) + real(1) + real(1);
	IffStream groupStream;
	parse(groupStream, form("FGRP", form("0008", chunk("FFAM", family))));
	FloraGroup group;
	group.readObject(&groupStream);
	flora.initialize(16, 7.25f, group);
	EXPECT_FALSE(flora.hasInstances());
}

TEST(NgeTerrainTest, FloraTransformsAndClearingUseWorldHorizontalAxes) {
	StaticFloraInstance instance;
	instance.position = Vector3(10, 20, 30);
	instance.yaw = (float) M_PI / 2.f;
	instance.scale = 2;
	Vector3 local = instance.toModelSpace(Vector3(14, 20, 36));
	EXPECT_NEAR(0.f, local.getX(), 0.000001f);
	EXPECT_NEAR(3.f, local.getY(), 0.000001f);
	EXPECT_NEAR(2.f, local.getZ(), 0.000001f);
	Vector3 nav = Vector3(local.getX(), local.getY(), -local.getZ()) * instance.getNavMeshTransform();
	EXPECT_NEAR(14.f, nav.getX(), 0.000001f);
	EXPECT_NEAR(36.f, nav.getY(), 0.000001f);
	EXPECT_NEAR(-20.f, nav.getZ(), 0.000001f);
	Vector<Sphere> clearing;
	clearing.add(Sphere(Vector3(12, 20, 1000), 3));
	EXPECT_TRUE(StaticFlora::isCleared(instance, clearing));
	clearing.removeAll();
	clearing.add(Sphere(Vector3(14, 20, 30), 3));
	EXPECT_FALSE(StaticFlora::isCleared(instance, clearing));
}

TEST(NgeTerrainTest, FloraPlacementMatchesNativeClientReference) {
	const uint32 keys[] = {647395, 647403, 647404};
	const float expected[][5] = {
		{-4551.47021484375f, 1928.6435546875f, 0.9679551721f, 0.5720871687f, 116.f / 255.f},
		{-4424.564453125f, 1927.743408203125f, 4.7165083885f, 0.0292328689f, 136.f / 255.f},
		{-4408.00634765625f, 1928.7200927734375f, 1.7365114689f, 0.0881742984f, 46.f / 255.f}
	};
	for (int i = 0; i < 3; ++i) {
		Vector3 position;
		float yaw, scale;
		StaticFlora::getPlacement(keys[i], 1024, 7.25f, position, yaw, scale);
		EXPECT_FLOAT_EQ(expected[i][0], position.getX());
		EXPECT_FLOAT_EQ(expected[i][1], position.getY());
		EXPECT_NEAR(expected[i][2], yaw, 0.000001f);
		EXPECT_NEAR(expected[i][3], scale, 0.000001f);
		EXPECT_FLOAT_EQ(expected[i][4], StaticFlora::getChildChoice(position.getX(), position.getY()));
	}
}

TEST(NgeTerrainTest, OlderWaterQueryKeepsFirstBoundaryPriority) {
	for (const char* version : {"0014", "0015"}) {
		bool nge = std::string(version) == "0015";
		IffStream stream;
		const char* boundaryVersion = nge ? "0007" : "0005";
		parse(stream, terrain(version, boundaryVersion, "0003", polygon(boundaryVersion, 0, 12)));
		ProceduralTerrainAppearance appearance;
		ASSERT_TRUE(appearance.load(&stream));
		float height;
		ASSERT_TRUE(appearance.getWater(0, 0, height));
		EXPECT_FLOAT_EQ(nge ? 12.f : 8.f, height);
	}
}
