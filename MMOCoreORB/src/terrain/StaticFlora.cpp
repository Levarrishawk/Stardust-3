#include "StaticFlora.h"
#include "FloraGroup.h"
#include "templates/manager/TemplateManager.h"
#include "templates/appearance/AppearanceTemplate.h"

#include <cmath>
#include <cstring>

namespace {

class FloraRandom {
	int seed;
	int current = 0;
	int table[322];
	void advance() {
		int k = seed / 127773;
		seed = 16807 * (seed - k * 127773) - 2836 * k;
		if (seed < 0)
			seed += 2147483647;
	}
public:
	FloraRandom(uint32 key) : seed(-(int) key) { }
	float next() {
		if (current == 0) {
			seed = seed < 0 ? -seed : 1;
			for (int i = 329; i >= 0; --i) {
				advance();
				if (i < 322)
					table[i] = seed;
			}
			current = table[0];
		}
		advance();
		int index = (int) ((float) current / 6669205.f);
		current = table[index];
		table[index] = seed;
		return (float) current / (float) 2147483647;
	}
};

uint32 hashCoordinate(uint32 value) {
	value += value << 12;
	value ^= value >> 22;
	value += value << 4;
	value ^= value >> 9;
	value += value << 10;
	value ^= value >> 2;
	value += value << 7;
	value ^= value >> 12;
	return value;
}

} // namespace

Vector3 StaticFloraInstance::toModelSpace(const Vector3& world) const {
	float x = world.getX() - position.getX();
	float y = world.getY() - position.getY();
	float c = cos(yaw);
	float s = sin(yaw);
	return Vector3((c * x - s * y) / scale, (world.getZ() - position.getZ()) / scale, (s * x + c * y) / scale);
}

Matrix4 StaticFloraInstance::getNavMeshTransform() const {
	Matrix4 transform;
	float c = cos(yaw) * scale;
	float s = sin(yaw) * scale;
	transform[0][0] = c;
	transform[0][2] = s;
	transform[1][1] = scale;
	transform[2][0] = -s;
	transform[2][2] = c;
	transform.setTranslation(position.getX(), position.getZ(), -position.getY());
	return transform;
}

void StaticFlora::clear() {
	families.clear();
	heights.clear();
	instances.removeAll();
	maximumRadius = 0;
	resolution = 1;
}

void StaticFlora::readObject(IffStream* stream) {
	clear();
	families.readObject(stream);
	if (stream->openForm('PFPM') == nullptr)
		throw Exception("Missing static flora height map in " + stream->getFileName());
	heights.readObject(stream);
	if (stream->openForm('0000') == nullptr)
		throw Exception("Unsupported static flora height resolution in " + stream->getFileName());
	Chunk* control = stream->openChunk('CNTL');
	if (control == nullptr || control->getChunkSize() != 4)
		throw Exception("Invalid static flora resolution data in " + stream->getFileName());
	resolution = stream->getFloat();
	stream->closeChunk('CNTL');
	stream->closeForm('0000');
	stream->closeForm('PFPM');
	if (!std::isfinite(resolution) || resolution <= 0 || families.getWidth() != heights.getWidth() || families.getHeight() != heights.getHeight())
		throw Exception("Invalid static flora height map in " + stream->getFileName());
}

void StaticFlora::getPlacement(uint32 key, int mapWidth, float border, Vector3& position, float& yaw, float& scaleChoice) {
	FloraRandom random(key);
	float x = random.next();
	float y = random.next();
	position.setX(((int) (key % mapWidth) - mapWidth / 2) * 16.f + x * (16.f - 2.f * border) + border);
	position.setY(((int) (key / mapWidth) - mapWidth / 2) * 16.f + y * (16.f - 2.f * border) + border);
	position.setZ(0);
	yaw = random.next() * (float) (2.f * M_PI);
	scaleChoice = random.next();
}

float StaticFlora::getChildChoice(float x, float y) {
	x = floor(x);
	y = floor(y);
	uint32 ix, iy;
	memcpy(&ix, &x, sizeof(ix));
	memcpy(&iy, &y, sizeof(iy));
	uint32 hash = hashCoordinate(hashCoordinate(ix) ^ hashCoordinate(iy ^ 0xa5a5a5a5U));
	uint32 bits = 0x3f800000U | ((hash + (hash >> 9)) & 0x007fffffU);
	float value;
	memcpy(&value, &bits, sizeof(value));
	// FloraGroup::Info stores the choice in an unsigned byte before selecting a child.
	return (uint8) ((value - 1.f) * 255.f) / 255.f;
}

void StaticFlora::initialize(float mapSize, float border, const FloraGroup& group) {
	instances.removeAll();
	maximumRadius = 0;
	if (!std::isfinite(mapSize) || mapSize <= 0 || mapSize / 16.f != families.getWidth() || families.getWidth() != families.getHeight() || !std::isfinite(border) || border < 0 || border > 8)
		throw Exception("Invalid native terrain static flora grid");
	VectorMap<String, const AppearanceTemplate*> appearances;
	for (int y = 0; y < families.getHeight(); ++y) {
		for (int x = 0; x < families.getWidth(); ++x) {
			int familyID = families.getValue(x, y);
			if (familyID == 0)
				continue;
			const FloraFamily* family = group.getFamily(familyID);
			if (family == nullptr)
				throw Exception("Missing static flora family " + String::valueOf(familyID));
			uint32 key = y * families.getWidth() + x;
			StaticFloraInstance instance;
			float scaleChoice;
			getPlacement(key, families.getWidth(), border, instance.position, instance.yaw, scaleChoice);
			const FloraData* child = family->chooseChild(getChildChoice(instance.position.getX(), instance.position.getY()));
			if (child == nullptr)
				throw Exception("Empty static flora family " + String::valueOf(familyID));
			// ParticleEffectAppearance::collide returns false outside editor picking.
			if (child->name.endsWith(".prt"))
				continue;
			String file = child->name.beginsWith("appearance/") ? child->name : "appearance/" + child->name;
			if (!appearances.contains(file)) {
				const AppearanceTemplate* appearance = TemplateManager::instance()->getAppearanceTemplate(file);
				if (appearance == nullptr)
					throw Exception("Missing static flora collision appearance " + file);
				// A detail template can load its bounds while its referenced mesh is missing.
				static const Matrix4 identity;
				Vector<Reference<MeshData*>> meshes = appearance->getTransformedMeshData(identity);
				int triangleCount = 0;
				for (int i = 0; i < meshes.size(); ++i) {
					if (meshes.get(i) != nullptr)
						triangleCount += meshes.get(i)->getTriangles()->size();
				}
				if (triangleCount == 0)
					throw Exception("Missing static flora collision geometry in " + file);
				appearances.put(file, appearance);
			}
			instance.appearance = appearances.get(file);
			if (child->var6 && (!std::isfinite(child->var7) || !std::isfinite(child->var8) || child->var7 <= 0 || child->var8 < child->var7))
				throw Exception("Invalid static flora scale range in " + file);
			instance.scale = child->var6 ? child->var7 + scaleChoice * (child->var8 - child->var7) : 1.f;
			if (!std::isfinite(instance.scale) || instance.scale <= 0)
				throw Exception("Invalid static flora scale in " + file);
			instance.position.setZ(heights.getValue(x, y) * resolution);
			const BaseBoundingVolume* volume = instance.appearance->getBoundingVolume();
			if (volume == nullptr)
				throw Exception("Missing static flora collision bounds in " + file);
			const Sphere& sphere = volume->getBoundingSphere();
			instance.radius = (sphere.getCenter().length() + sphere.getRadius()) * instance.scale;
			if (!std::isfinite(instance.radius) || instance.radius < 0)
				throw Exception("Invalid static flora collision bounds in " + file);
			maximumRadius = Math::max(maximumRadius, instance.radius);
			instances.put(key, instance);
		}
	}
}

void StaticFlora::getInstances(const AABB& bounds, Vector<StaticFloraInstance>& result) const {
	if (instances.size() == 0)
		return;
	int width = families.getWidth();
	int minX = Math::clamp(0, (int) floor((bounds.getXMin() - maximumRadius) / 16.f) + width / 2, width - 1);
	int maxX = Math::clamp(0, (int) floor((bounds.getXMax() + maximumRadius) / 16.f) + width / 2, width - 1);
	int minY = Math::clamp(0, (int) floor((bounds.getZMin() - maximumRadius) / 16.f) + width / 2, width - 1);
	int maxY = Math::clamp(0, (int) floor((bounds.getZMax() + maximumRadius) / 16.f) + width / 2, width - 1);
	for (int y = minY; y <= maxY; ++y) {
		for (int x = minX; x <= maxX; ++x) {
			uint32 key = y * width + x;
			if (!instances.contains(key))
				continue;
			const StaticFloraInstance& instance = instances.get(key);
			if (instance.position.getX() + instance.radius < bounds.getXMin() || instance.position.getX() - instance.radius > bounds.getXMax() ||
				instance.position.getY() + instance.radius < bounds.getZMin() || instance.position.getY() - instance.radius > bounds.getZMax())
				continue;
			result.add(instance);
		}
	}
}

bool StaticFlora::isCleared(const StaticFloraInstance& instance, const Vector<Sphere>& clearAreas) {
	for (int i = 0; i < clearAreas.size(); ++i) {
		const Sphere& area = clearAreas.get(i);
		float x = instance.position.getX() - area.getCenter().getX();
		float y = instance.position.getY() - area.getCenter().getY();
		if (x * x + y * y < area.getRadius() * area.getRadius())
			return true;
	}
	return false;
}
