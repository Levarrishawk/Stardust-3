#ifndef INSPIRATIONSTATE_H_
#define INSPIRATIONSTATE_H_

#include <array>
#include <ctime>

#include "system/platform.h"

struct InspirationState {
	enum Effect {
		CONSTITUTION,
		LUCK,
		MAX_ACTION,
		SECONDARY_DEFENSE,
		HEALER,
		RESILIENCE,
		SECOND_CHANCE,
		EXPERIENCE,
		ASSEMBLY,
		AMAZING_SUCCESS,
		EFFECT_COUNT
	};

	using Ranks = std::array<int, EFFECT_COUNT>;

	uint64 performerID = 0;
	uint64 patronID = 0;
	int token = 0;
	uint64 attendanceStart = 0;
	int points = 0;
	int durationSeconds = 0;
	int coverCharge = 0;
	time_t deadline = 0;
	bool offered = false;
	Ranks ranks{};
};

struct InspirationUpdate {
	enum Origin {
		PERFORMER,
		PATRON,
		SERVER
	};

	uint64 performerID = 0;
	uint64 patronID = 0;
	int token = 0;
	int origin = SERVER;
	int coverCharge = 0;
	bool accepted = false;
	bool valid = false;
	InspirationState::Ranks ranks{};
};

#endif // INSPIRATIONSTATE_H_
