#ifndef DECORATIONREQUEST_H_
#define DECORATIONREQUEST_H_
#include <cstdint>
#include <sstream>
#include <string>
#include <vector>

// Pure wire parsing; coordinates are signed centimetres in client X/Y/Z order.
namespace DecorationWire {
struct Request {
	uint64_t token = 0, cell = 0;
	uint32_t id = 0, revision = 0;
	std::string operation, axis;
	int degrees = 0;
	int x = 0, y = 0, z = 0;
};

inline bool unsignedNumber(const std::string& text, uint64_t limit, uint64_t& value) {
	if (text.empty()) return false;
	value = 0;
	for (char c : text) {
		if (c < '0' || c > '9') return false;
		unsigned digit = c - '0';
		if (value > (limit - digit) / 10) return false;
		value = value * 10 + digit;
	}
	return true;
}

inline bool signedNumber(const std::string& text, unsigned limit, int& value) {
	bool negative = !text.empty() && text[0] == '-';
	uint64_t magnitude = 0;
	if (!unsignedNumber(negative ? text.substr(1) : text, limit, magnitude)) return false;
	value = negative ? -static_cast<int>(magnitude) : static_cast<int>(magnitude);
	return true;
}

inline bool parse(const std::string& text, Request& request) {
	request = Request();
	if (text.size() > 256) return false;
	std::istringstream stream(text);
	std::vector<std::string> words;
	std::string word;
	while (stream >> word) words.push_back(word);
	if (words.size() < 4 || words[0] != "decor1") return false;
	uint64_t id = 0, revision = 0;
	if (!unsignedNumber(words[1], UINT64_MAX, request.token) || !request.token ||
			!unsignedNumber(words[2], UINT32_MAX, id) || !id) return false;
	request.id = static_cast<uint32_t>(id);
	request.operation = words[3];
	if (request.operation == "end" || request.operation == "select") return words.size() == 4;
	if (request.operation == "move") { if (words.size() != 9) return false; }
	else if (request.operation == "rotate") { if (words.size() != 8) return false; }
	else if (request.operation == "floor" || request.operation == "reset" || request.operation == "undo" || request.operation == "redo") { if (words.size() != 6) return false; }
	else return false;
	if (!unsignedNumber(words[4], UINT64_MAX, request.cell) || !request.cell ||
			!unsignedNumber(words[5], UINT32_MAX, revision)) return false;
	request.revision = static_cast<uint32_t>(revision);
	if (request.operation == "floor" || request.operation == "reset" || request.operation == "undo" || request.operation == "redo") return true;
	if (request.operation == "rotate") {
		request.axis = words[6];
		return (request.axis == "yaw" || request.axis == "pitch" || request.axis == "roll") &&
				signedNumber(words[7], 180, request.degrees) && request.degrees != 0;
	}
	if (!signedNumber(words[6], 500, request.x) || !signedNumber(words[7], 500, request.y) ||
			!signedNumber(words[8], 500, request.z)) return false;
	int lengthSquared = request.x * request.x + request.y * request.y + request.z * request.z;
	return lengthSquared > 0 && lengthSquared <= 500 * 500;
}
}
#endif
