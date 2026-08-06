#ifndef BOUNTYNOTORIETYMANAGER_H_
#define BOUNTYNOTORIETYMANAGER_H_

#include "server/zone/objects/creature/CreatureObject.h"

class BountyNotorietyManager : public Singleton<BountyNotorietyManager>, public Logger, public Object {
public:
	enum NotorietyAction {
		CITYAUTHORITYATTACK,
		PLAYERDEATHBLOW,
		CONTRABANDDETECTED,
		CRACKDOWNEVASION
	};

private:
	float maxNotoriety;
	float terminalThreshold;
	unsigned int totalDecayTimeInDays;
	unsigned int decayTickRate;
	float decayPerTick;
	int cityAuthorityAttackAmount;
	int playerDeathBlowAmount;
	int contrabandDetectedAmount;
	int crackdownEvasionAmount;

	VectorMap<uint64, ManagedReference<CreatureObject*> > notorietyList;
	Mutex notorietyListLock;

	void loadConfiguration();
	void decreaseNotoriety(CreatureObject* creature);
	void updateBountyStatus(CreatureObject* creature);
	int getActionAmount(NotorietyAction action) const;

public:
	BountyNotorietyManager();

	void increaseNotoriety(CreatureObject* creature, NotorietyAction action);
	void ensureMinimumNotoriety(CreatureObject* creature, float minimum);
	void addToNotorietyList(CreatureObject* creature);
	void removeFromNotorietyList(CreatureObject* creature);
	void performNotorietyDecay();

	unsigned int getDecayTickRate() const {
		return decayTickRate;
	}
};

#endif /* BOUNTYNOTORIETYMANAGER_H_ */
