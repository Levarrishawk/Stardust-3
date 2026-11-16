#include "../src/server/zone/objects/player/sessions/DecorationRequest.h"
#include "../src/server/zone/objects/player/sessions/DecorationHistory.h"
#include "../src/server/zone/objects/player/sessions/DecorationFloor.h"
#include <limits>
#include <cstdlib>
#include <iostream>

static int checks = 0;
static void check(bool value) {
	++checks;
	if (!value) { std::cerr << "Failed check " << checks << "\n"; std::exit(1); }
}

static void historyTests() {
	using namespace DecorationHistory;
	Store store; Pose a, b, c, destination;
	b.values[0] = 1; c.values[0] = 2;
	store.record(10, 100, 1, 3, a, b);
	check(store.undoCount(10) == 1 && store.redoCount(10) == 0);
	check(store.destination(10, false, destination) && same(destination, a));
	// Merely validating an undo (including a collision failure) cannot consume it.
	check(store.destination(10, false, destination) && store.undoCount(10) == 1);
	store.committed(10, false, 5);
	store.synchronize(10, 100, 5, a);
	check(store.undoCount(10) == 0 && store.redoCount(10) == 1);
	check(store.destination(10, true, destination) && same(destination, b));
	store.committed(10, true, 7);
	store.record(10, 100, 7, 9, b, c);
	check(store.undoCount(10) == 2);
	store.committed(10, false, 11);
	store.synchronize(10, 100, 11, b);
	check(store.destination(10, false, destination) && same(destination, a));
	store.committed(10, false, 13);
	store.synchronize(10, 100, 13, a);
	check(store.redoCount(10) == 2);
	store.committed(10, true, 15);
	store.synchronize(10, 100, 15, b);
	check(store.destination(10, true, destination) && same(destination, c));
	// No-op edits advance the revision but preserve redo.
	store.record(10, 100, 15, 17, b, b);
	check(store.redoCount(10) == 1);
	Pose branch = b; branch.values[1] = 0.5f;
	store.record(10, 100, 17, 19, b, branch);
	check(store.undoCount(10) == 2 && store.redoCount(10) == 0);
	// Different items and cells retain independent histories.
	store.record(20, 200, 2, 4, a, c);
	store.synchronize(10, 100, 19, branch);
	check(store.undoCount(10) == 2 && store.undoCount(20) == 1);
	// Another editor's revision invalidates only this item's history.
	store.synchronize(10, 100, 20, branch);
	check(store.undoCount(10) == 0 && store.undoCount(20) == 1);
	store.synchronize(20, 201, 4, c);
	check(store.undoCount(20) == 0);
	store.record(30, 300, 1, 3, a, b);
	store.synchronize(30, 300, 3, c); // pose changed without a revision update
	check(store.undoCount(30) == 0);
	// Reset rotation can restore the original full quaternion, not a guessed inverse.
	Pose tilted;
	tilted.values[3] = 0.5f; tilted.values[6] = 0.8660254f;
	store.record(40, 400, 1, 3, tilted, a);
	check(store.destination(40, false, destination) && same(destination, tilted));
	Store bounded;
	for (unsigned i=0; i<40; ++i) {
		Pose from, to; from.values[0]=float(i); to.values[0]=float(i+1);
		bounded.record(1, 100, i*2, i*2+2, from, to);
	}
	check(bounded.undoCount(1) == Store::maxEdits);
	for (unsigned i=0; i<Store::maxEdits; ++i) {
		check(bounded.destination(1, false, destination));
		bounded.committed(1, false, 82+i*2);
		bounded.synchronize(1, 100, 82+i*2, destination);
	}
	check(destination.values[0] == 8 && bounded.redoCount(1) == Store::maxEdits);
	for (uint64_t i=2; i<=17; ++i) bounded.record(i, 100, 0, 2, a, b);
	check(bounded.undoCount(1) == 0 && bounded.redoCount(1) == 0);
	check(bounded.undoCount(17) == 1);
}

static void floorTests() {
    float height = 0; bool found = false;
    found = DecorationFloor::consider(8, 0, found, height);
    found = DecorationFloor::consider(8, 12, found, height);
    found = DecorationFloor::consider(8, 5, found, height);
    found = DecorationFloor::consider(8, 3, found, height);
    check(found && height == 5); // stacked floors, regardless of hit order
    check(!DecorationFloor::consider(-2, 0, false, height));
    check(DecorationFloor::consider(-2, -4, false, height) && height == -4);
    check(DecorationFloor::consider(-0.01f, 0, false, height) && height == 0);
    check(!DecorationFloor::consider(-0.03f, 0, false, height));
    check(!DecorationFloor::consider(1, std::numeric_limits<float>::quiet_NaN(), false, height));
    check(!DecorationFloor::consider(std::numeric_limits<float>::infinity(), 0, false, height));
    DecorationHistory::Store history; DecorationHistory::Pose before, after, destination;
    before.values = {{2, 8, 3, 0.5f, 0, 0, 0.8660254f}};
    after = before; after.values[1] = 5;
    history.record(1, 42, 1, 3, before, after);
    check(history.destination(1, false, destination) && DecorationHistory::same(destination, before));
    history.committed(1, false, 5);
    check(history.destination(1, true, destination) && DecorationHistory::same(destination, after));
}

int main() {
    floorTests();
    historyTests();
	using namespace DecorationWire;
	Request request;
    check(parse("decor1 7 3 floor 42 17", request));
    check(request.operation == "floor" && request.cell == 42 && request.revision == 17);
    check(!parse("decor1 7 3 floor 42 17 0", request));
    check(!parse("decor1 7 3 floor 0 17", request));
    check(!parse("decor1 7 3 floor 42 -1", request));
    check(!parse("decor1 7 3 floor 42", request));
	check(parse("decor1 1 1 select", request));
	check(request.token == 1 && request.id == 1 && request.operation == "select");
	check(parse("decor1 18446744073709551615 4294967295 move 18446744073709551615 4294967295 -300 400 0", request));
	check(request.x == -300 && request.y == 400 && request.z == 0 && request.revision == UINT32_MAX);
	check(parse("decor1 7 2 end", request));
    check(parse("decor1 7 3 undo 42 17", request));
    check(parse("decor1 7 4 redo 42 19", request));
    check(!parse("decor1 7 4 redo 42 19 extra", request));
    check(!parse("decor1 7 4 undo 0 19", request));
	const char* invalid[] = {
		"", "decor1", "decor1 0 1 select", "decor1 1 0 select",
		"decor1 -1 1 select", "decor1 +1 1 select", "decor1 1 -1 select",
		"decor1 18446744073709551616 1 select", "decor1 1 4294967296 select",
		"decor1 1 1 select extra", "decor1 1 1 end extra", "decor2 1 1 select",
		"decor1 1 1 move 0 1 1 0 0", "decor1 1 1 move 2 -1 1 0 0",
		"decor1 1 1 move 2 4294967296 1 0 0", "decor1 1 1 move 2 1 0 0 0",
		"decor1 1 1 move 2 1 500 1 0", "decor1 1 1 move 2 1 -501 0 0",
		"decor1 1 1 move 2 1 1.5 0 0", "decor1 1 1 move 2 1 nan 0 0",
		"decor1 1 1 move 2 1 1e2 0 0", "decor1 1 1 move 2 1 +1 0 0",
		"decor1 1 1 move 2 1 - 0 0", "decor1 1 1 move 2 1 1 0",
		"decor1 1 1 move 2 1 1 0 0 extra", "decor1 1 1 rotate 2 1 1 0 0",
		"decor1 1 1 move 18446744073709551616 1 1 0 0"
	};
	for (const auto& input : invalid) check(!parse(input, request));
	check(!parse(std::string(257, '1'), request));
	for (int x = -550; x <= 550; x += 50)
		for (int y = -550; y <= 550; y += 50)
			for (int z = -550; z <= 550; z += 50) {
				std::string input = "decor1 4 9 move 42 17 " + std::to_string(x) + " " +
						std::to_string(y) + " " + std::to_string(z);
				int squared = x*x + y*y + z*z;
				bool expected = squared > 0 && squared <= 250000;
				check(parse(input, request) == expected);
				if (expected) check(request.x == x && request.y == y && request.z == z);
			}
	for (const std::string& axis : {"yaw", "pitch", "roll"}) {
		for (int degrees = -200; degrees <= 200; ++degrees) {
			bool expected = degrees >= -180 && degrees <= 180 && degrees != 0;
			check(parse("decor1 1 2 rotate 42 17 " + axis + " " + std::to_string(degrees), request) == expected);
			if (expected) check(request.axis == axis && request.degrees == degrees);
		}
	}
	check(parse("decor1 1 2 reset 42 17", request));
	check(!parse("decor1 1 2 rotate 42 17 x 45", request));
	check(!parse("decor1 1 2 rotate 42 17 yaw 0.5", request));
	check(!parse("decor1 1 2 reset 42 17 extra", request));
	// Malformed numeric suffixes and every overflowing uint64 prefix boundary.
	for (int i = 0; i < 256; ++i) {
		if (i >= '0' && i <= '9') continue;
		if (i == ' ' || i == '\t' || i == '\n' || i == '\r' || i == '\v' || i == '\f') continue;
		std::string input = "decor1 12";
		input += static_cast<char>(i);
		input += "34 1 select";
		check(!parse(input, request));
	}
	std::cout << checks << " decoration request checks passed\n";
}
