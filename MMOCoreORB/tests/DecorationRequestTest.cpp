#include "../src/server/zone/objects/player/sessions/DecorationRequest.h"
#include <cstdlib>
#include <iostream>

static int checks = 0;
static void check(bool value) {
	++checks;
	if (!value) { std::cerr << "Failed check " << checks << "\n"; std::exit(1); }
}
int main() {
	using namespace DecorationWire;
	Request request;
	check(parse("decor1 1 1 select", request));
	check(request.token == 1 && request.id == 1 && request.operation == "select");
	check(parse("decor1 18446744073709551615 4294967295 move 18446744073709551615 4294967295 -300 400 0", request));
	check(request.x == -300 && request.y == 400 && request.z == 0 && request.revision == UINT32_MAX);
	check(parse("decor1 7 2 end", request));
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
