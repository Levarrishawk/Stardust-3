/*
 * WearablesDeltaVector.h
 *
 *  Created on: 09/04/2012
 *      Author: victor
 */

#ifndef WEARABLESDELTAVECTOR_H_
#define WEARABLESDELTAVECTOR_H_

#include "engine/engine.h"

#include "engine/util/json_utils.h"

#include "server/zone/objects/scene/variables/DeltaVector.h"
#include "server/zone/objects/tangible/TangibleObject.h"
#include "server/zone/objects/tangible/wearables/ArmorObject.h"
#include "templates/tangible/ArmorObjectTemplate.h"

class WearablesDeltaVector : public DeltaVector<ManagedReference<TangibleObject*> > {
private:
	// note: duplicate of CombatManager::hitlocations.
	enum HitLocation : int {
		HIT_BODY = 0,
		HIT_HEAD = 1,
		HIT_RARM = 2,
		HIT_LARM = 3,
		HIT_RLEG = 4,
		HIT_LLEG = 5,
		HIT_NUM = 6,
	};

protected:
	VectorMap<uint8, Vector<ManagedReference<ArmorObject*> > > protectionArmorMap;

public:
	struct AppearanceSelection {
		uint64 sourceID;
		Vector<uint64> targets;
		uint32 crc;
		String customization;
		Vector<String> slots;
	};

protected:
	// Runtime-only records; ArrayList avoids Vector's virtual element serialization.
	ArrayList<AppearanceSelection> appearances;

public:
	WearablesDeltaVector() : DeltaVector<ManagedReference<TangibleObject*> >() {
		protectionArmorMap.setAllowOverwriteInsertPlan();

		//addSerializableVariable("protectionArmorMap", &protectionArmorMap);
	}

	bool readObjectMember(ObjectInputStream* stream, const String& name) {
		if (name == "protectionArmorMap") {
			TypeInfo<VectorMap<uint8, Vector<ManagedReference<ArmorObject*> > >>::parseFromBinaryStream(&protectionArmorMap, stream);

			return true;
		}

		return DeltaVector<ManagedReference<TangibleObject*> >::readObjectMember(stream, name);
	}

	int writeObjectMembers(ObjectOutputStream* stream) {
		static String _name = "protectionArmorMap";
		int _offset;
		uint32 _totalSize;

		_name.toBinaryStream(stream);
		_offset = stream->getOffset();
		stream->writeInt(0);
		TypeInfo<VectorMap<uint8, Vector<ManagedReference<ArmorObject*> > >>::toBinaryStream(&protectionArmorMap, stream);
		_totalSize = (uint32) (stream->getOffset() - (_offset + 4));
		stream->writeInt(_offset, _totalSize);

		return 1 + DeltaVector<ManagedReference<TangibleObject*> >::writeObjectMembers(stream);
	}

	friend void to_json(nlohmann::json& j, const WearablesDeltaVector& vec) {
		j["protectionArmorMap"] = vec.protectionArmorMap;

		const DeltaVector<ManagedReference<TangibleObject*> >& dv = vec;

		to_json(j, dv);
	}


	bool toBinaryStream(ObjectOutputStream* stream) override {
		int _currentOffset = stream->getOffset();
		stream->writeShort(0);
		int _varCount = writeObjectMembers(stream);
		stream->writeShort(_currentOffset, _varCount);

		return true;
	}

	bool parseFromBinaryStream(ObjectInputStream* stream) override {
		uint16 _varCount = stream->readShort();

		for (int i = 0; i < _varCount; ++i) {
			String _name;
			_name.parseFromBinaryStream(stream);

			uint32 _varSize = stream->readInt();

			int _currentOffset = stream->getOffset();

			if(readObjectMember(stream, _name)) {
			}

			stream->setOffset(_currentOffset + _varSize);
		}

		return true;
	}

	void insertItemToMessage(ManagedReference<TangibleObject*>* item, BaseMessage* msg) const override {
		TangibleObject* object = item->get();
		for (int i = 0; i < appearances.size(); ++i) {
			const AppearanceSelection& appearance = appearances.get(i);
			if (appearance.targets.size() != 0 && appearance.targets.get(0) == object->getObjectID()) {
				msg->insertAscii(appearance.customization);
				msg->insertInt(4);
				msg->insertLong(object->getObjectID());
				msg->insertInt(appearance.crc);
				return;
			}
		}
		String customization;
		object->getCustomizationString(customization);
		msg->insertAscii(customization);
		msg->insertInt(object->getContainmentType());
		msg->insertLong(object->getObjectID());
		msg->insertInt(object->getClientObjectCRC());
	}

	bool isSuppressed(uint64 targetID) const {
		for (int i = 0; i < appearances.size(); ++i) {
			const Vector<uint64>& targets = appearances.get(i).targets;
			if (targets.contains(targetID))
				return targets.get(0) != targetID;
		}
		return false;
	}

	void insertToMessage(BaseMessage* message) const override {
		ReadLocker locker(getLock());
		int count = 0;
		for (int i = 0; i < size(); ++i) {
			if (!isSuppressed(get(i)->getObjectID()))
				++count;
		}
		message->insertInt(count);
		message->insertInt(updateCounter);
		for (int i = 0; i < size(); ++i) {
			if (!isSuppressed(get(i)->getObjectID()))
				insertItemToMessage(&get(i), message);
		}
	}

	ArrayList<AppearanceSelection> getAppearances() const {
		ReadLocker locker(getLock());
		return appearances;
	}

	uint64 getAppearanceSourceID() const {
		ReadLocker locker(getLock());
		return appearances.size() == 0 ? 0 : appearances.get(0).sourceID;
	}

	bool isAppearanceEquipped(uint64 sourceID) const {
		ReadLocker locker(getLock());
		for (int i = 0; i < appearances.size(); ++i) {
			if (appearances.get(i).sourceID == sourceID)
				return true;
		}
		return false;
	}

	bool isAppearanceTarget(uint64 targetID) const {
		ReadLocker locker(getLock());
		for (int i = 0; i < appearances.size(); ++i) {
			if (appearances.get(i).targets.contains(targetID))
				return true;
		}
		return false;
	}

	String getAppearanceSlotConflict(uint64 sourceID, const Vector<String>& slots) const {
		ReadLocker locker(getLock());
		for (int i = 0; i < appearances.size(); ++i) {
			const AppearanceSelection& appearance = appearances.get(i);
			if (appearance.sourceID == sourceID)
				continue;
			for (int j = 0; j < slots.size(); ++j) {
				if (appearance.slots.contains(slots.get(j)))
					return slots.get(j);
			}
		}
		return "";
	}

	void addAppearance(const AppearanceSelection& appearance) {
		Locker locker(getLock());
		appearances.add(appearance);
	}

	void clearAppearance(uint64 sourceID = 0) {
		Locker locker(getLock());
		if (sourceID == 0) {
			appearances.removeAll();
			return;
		}
		for (int i = appearances.size() - 1; i >= 0; --i) {
			if (appearances.get(i).sourceID == sourceID)
				appearances.remove(i);
		}
	}

	void refreshAppearance(DeltaMessage* message) {
		Locker locker(getLock());
		if (message == nullptr)
			return;
		int count = 0;
		for (int i = 0; i < size(); ++i) {
			if (!isSuppressed(get(i)->getObjectID()))
				++count;
		}
		// Reset the projected client list; gameplay equipment and armor stay intact.
		message->startList(count + 1, getNewUpdateCounter(count + 1));
		message->insertByte(4);
		int index = 0;
		for (int i = 0; i < size(); ++i) {
			if (isSuppressed(get(i)->getObjectID()))
				continue;
			message->insertByte(1);
			message->insertShort(index++);
			insertItemToMessage(&get(i), message);
		}
	}

	bool add(const ManagedReference<TangibleObject*>& element, DeltaMessage* message = nullptr, int updates = 1) override {
		if (element->isArmorObject()) {
			ManagedReference<ArmorObject*> armor = cast<ArmorObject*>(element.get());
			uint8 hitLocations = armor->getHitLocation();

			if (hitLocations & ArmorObjectTemplate::CHEST)
				addArmor(ArmorObjectTemplate::CHEST, armor);

			if (hitLocations & ArmorObjectTemplate::ARMS)
				addArmor(ArmorObjectTemplate::ARMS, armor);

			if (hitLocations & ArmorObjectTemplate::LEGS)
				addArmor(ArmorObjectTemplate::LEGS, armor);

			if (hitLocations & ArmorObjectTemplate::HEAD)
				addArmor(ArmorObjectTemplate::HEAD, armor);
		}

		return DeltaVector<ManagedReference<TangibleObject*> >::add(element, message, updates);
	}

	ManagedReference<TangibleObject*> remove(int index, DeltaMessage* message = nullptr, int updates = 1) override {
		ManagedReference<TangibleObject*> element = get(index);

		if (element->isArmorObject()) {
			ManagedReference<ArmorObject*> armor = cast<ArmorObject*>(element.get());
			uint8 hitLocations = armor->getHitLocation();

			if (hitLocations & ArmorObjectTemplate::CHEST)
				removeArmor(ArmorObjectTemplate::CHEST, armor);

			if (hitLocations & ArmorObjectTemplate::ARMS)
				removeArmor(ArmorObjectTemplate::ARMS, armor);

			if (hitLocations & ArmorObjectTemplate::LEGS)
				removeArmor(ArmorObjectTemplate::LEGS, armor);

			if (hitLocations & ArmorObjectTemplate::HEAD)
				removeArmor(ArmorObjectTemplate::HEAD, armor);
		}

		return DeltaVector<ManagedReference<TangibleObject*> >::remove(index, message, updates);
	}


	Vector<ManagedReference<ArmorObject*> > getArmorAtHitLocation(uint8 hitLocation) const {
		// TODO: Migrate and remove this when the object versioning and migration system is in place
		switch(hitLocation) {
			case HitLocation::HIT_BODY: {
				return protectionArmorMap.get((uint8)ArmorObjectTemplate::CHEST);
			}

			case HitLocation::HIT_HEAD: {
				return protectionArmorMap.get((uint8)ArmorObjectTemplate::HEAD);
			}

			case HitLocation::HIT_RARM:
			case HitLocation::HIT_LARM: {
				Vector<ManagedReference<ArmorObject*> > armArmor = protectionArmorMap.get((uint8)ArmorObjectTemplate::ARMS);
				Vector<ManagedReference<ArmorObject*> > armorAtLocation;

				if (armArmor.isEmpty()) {
					return armArmor;
				}

				if (hitLocation == HitLocation::HIT_LARM) {
					for (int i = armArmor.size() - 1; i >= 0; i--) {
						ArmorObject* obj = armArmor.get(i);

						if (obj == nullptr) {
							continue;
						}

						if(obj->hasArrangementDescriptor("bicep_l") || obj->hasArrangementDescriptor("bracer_upper_l") || obj->hasArrangementDescriptor("gloves")) {
							armorAtLocation.add(obj);
						}
					}
				} else {
					for (int i = armArmor.size() - 1; i >= 0; i--) {
						ArmorObject* obj = armArmor.get(i);

						if (obj == nullptr) {
							continue;
						}

						if(obj->hasArrangementDescriptor("bicep_r") || obj->hasArrangementDescriptor("bracer_upper_r") || obj->hasArrangementDescriptor("gloves")) {
							armorAtLocation.add(obj);
						}
					}
				}

				if (armorAtLocation.isEmpty()) {
					return armArmor;
				} else {
					return armorAtLocation;
				}
			}

			case HitLocation::HIT_LLEG:
			case HitLocation::HIT_RLEG: {
				return protectionArmorMap.get((uint8)ArmorObjectTemplate::LEGS);
			}
		}

		return protectionArmorMap.get((uint8)ArmorObjectTemplate::NOLOCATION);
	}

	void addArmor(uint8 hitLocation, ManagedReference<ArmorObject*> armor) {
		Vector<ManagedReference<ArmorObject*> > armors = protectionArmorMap.get(hitLocation);
		armors.add(armor);

		protectionArmorMap.drop(hitLocation);
		protectionArmorMap.put(hitLocation, armors);
	}

	void removeArmor(uint8 hitLocation, ManagedReference<ArmorObject*> armor) {
		Vector<ManagedReference<ArmorObject*> > armors = protectionArmorMap.get(hitLocation);
		armors.removeElement(armor);

		protectionArmorMap.drop(hitLocation);
		protectionArmorMap.put(hitLocation, armors);
	}
};


#endif /* WEARABLESDELTAVECTOR_H_ */
