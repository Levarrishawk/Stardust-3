#ifndef DECORATIONHISTORY_H_
#define DECORATIONHISTORY_H_
#include <array>
#include <cmath>
#include <cstdint>
#include <map>
#include <vector>

namespace DecorationHistory {
struct Pose {
	std::array<float, 7> values; // client X/Y-up/Z, quaternion X/Y/Z/W
	Pose() : values{{0, 0, 0, 0, 0, 0, 1}} {}
};
inline bool same(const Pose& a, const Pose& b) {
	for (int i = 0; i < 3; ++i)
		if (std::fabs(a.values[i] - b.values[i]) > 0.0001f) return false;
	float dot = 0;
	for (int i = 3; i < 7; ++i) dot += a.values[i] * b.values[i];
	return std::fabs(dot) > 0.999999f;
}
struct Edit { Pose before, after; };
struct Timeline {
	uint64_t cell = 0, touched = 0;
	uint32_t revision = 0;
	size_t cursor = 0;
	std::vector<Edit> edits;
};
class Store {
	std::map<uint64_t, Timeline> items;
	uint64_t clock = 0;
public:
	enum { maxItems = 16, maxEdits = 32 };
	void forget(uint64_t target) { items.erase(target); }
	void synchronize(uint64_t target, uint64_t cell, uint32_t revision, const Pose& pose) {
		auto it = items.find(target);
		if (it == items.end()) return;
		Timeline& t = it->second;
		const Pose& expected = t.cursor ? t.edits[t.cursor - 1].after : t.edits.front().before;
		if (t.cell != cell || t.revision != revision || !same(expected, pose)) items.erase(it);
		else t.touched = ++clock;
	}
	void record(uint64_t target, uint64_t cell, uint32_t beforeRevision, uint32_t afterRevision,
			const Pose& before, const Pose& after) {
		synchronize(target, cell, beforeRevision, before);
		if (same(before, after)) {
			auto it = items.find(target);
			if (it != items.end()) it->second.revision = afterRevision;
			return;
		}
		if (!items.count(target) && items.size() >= maxItems) {
			auto oldest = items.begin();
			for (auto it = items.begin(); it != items.end(); ++it)
				if (it->second.touched < oldest->second.touched) oldest = it;
			items.erase(oldest);
		}
		Timeline& t = items[target];
		t.edits.resize(t.cursor); // Only an accepted new edit discards redo.
		Edit edit; edit.before = before; edit.after = after;
		t.edits.push_back(edit);
		if (t.edits.size() > maxEdits) t.edits.erase(t.edits.begin());
		t.cursor = t.edits.size(); t.cell = cell; t.revision = afterRevision; t.touched = ++clock;
	}
	unsigned undoCount(uint64_t target) const {
		auto it = items.find(target); return it == items.end() ? 0 : static_cast<unsigned>(it->second.cursor);
	}
	unsigned redoCount(uint64_t target) const {
		auto it = items.find(target);
		return it == items.end() ? 0 : static_cast<unsigned>(it->second.edits.size() - it->second.cursor);
	}
	bool destination(uint64_t target, bool redo, Pose& pose) const {
		auto it = items.find(target); if (it == items.end()) return false;
		const Timeline& t = it->second;
		if (redo) { if (t.cursor == t.edits.size()) return false; pose = t.edits[t.cursor].after; }
		else { if (!t.cursor) return false; pose = t.edits[t.cursor - 1].before; }
		return true;
	}
	void committed(uint64_t target, bool redo, uint32_t revision) {
		auto it = items.find(target); if (it == items.end()) return;
		Timeline& t = it->second;
		if (redo) { if (t.cursor == t.edits.size()) return; ++t.cursor; }
		else { if (!t.cursor) return; --t.cursor; }
		t.revision = revision; t.touched = ++clock;
	}
};
}
#endif
