#ifndef DECORATIONSTATE_H_
#define DECORATIONSTATE_H_
#include "system/platform.h"

struct DecorationState {
	uint64 buildingID = 0;
	uint64 token = 0;
	uint32 lastRequest = 0;
};
#endif
