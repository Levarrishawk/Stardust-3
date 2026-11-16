#ifndef DECORATIONFLOOR_H_
#define DECORATIONFLOOR_H_
#include <cmath>

namespace DecorationFloor {
// Choose the highest floor beneath the origin. Allow 2 cm of floor-mesh rounding.
inline bool consider(float origin, float candidate, bool found, float& height) {
    if (!std::isfinite(origin) || !std::isfinite(candidate) || candidate > origin + 0.02f)
        return found;
    if (!found || candidate > height) height = candidate;
    return true;
}
}
#endif
