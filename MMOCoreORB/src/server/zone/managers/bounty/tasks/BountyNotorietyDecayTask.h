#ifndef BOUNTYNOTORIETYDECAYTASK_H_
#define BOUNTYNOTORIETYDECAYTASK_H_

#include "server/zone/managers/bounty/BountyNotorietyManager.h"

class BountyNotorietyDecayTask : public Task {
public:
	void run() {
		BountyNotorietyManager::instance()->performNotorietyDecay();
		reschedule(BountyNotorietyManager::instance()->getDecayTickRate() * 1000);
	}
};

#endif /* BOUNTYNOTORIETYDECAYTASK_H_ */
