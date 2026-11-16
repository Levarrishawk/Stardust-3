#ifndef DECORATIONCEILING_H_
#define DECORATIONCEILING_H_
#include "DecorationWall.h"

namespace DecorationCeiling {
// Share validated rotated bounds with wall snapping; client coordinates are Y-up.
inline void consider(DecorationWall::Search& search, const std::array<DecorationWall::Point,3>& triangle) {
    using namespace DecorationWall;
    for(Point p:triangle) if(!finite(p)) return;
    Point a=subtract(triangle[1],triangle[0]), b=subtract(triangle[2],triangle[0]);
    Point n=cross(a,b); float n2=dot(n,n);
    if(n2<0.000001f || n.y*n.y<n2*0.5f) return; // ceilings up to 45 degrees, not walls
    float determinant=a.x*b.z-a.z*b.x;
    if(std::fabs(determinant)<0.000001f) return;
    float dx=search.origin.x-triangle[0].x, dz=search.origin.z-triangle[0].z;
    float u=(dx*b.z-dz*b.x)/determinant, v=(a.x*dz-a.z*dx)/determinant;
    if(u < -0.00001f || v < -0.00001f || u+v > 1.00001f) return;
    float height=triangle[0].y+u*a.y+v*b.y;
    if(height<=search.origin.y+0.0001f || height-search.origin.y>32) return;
    if(n.y<0) n={-n.x,-n.y,-n.z};
    float support=dot(n,search.corners[0])/n.y;
    for(Point corner:search.corners) support=std::max(support,dot(n,corner)/n.y);
    float travel=height-search.origin.y-support-0.02f;
    if(!std::isfinite(travel)) return;
    // An intersecting lower ceiling must not be skipped in favour of a higher one.
    if(travel < -0.03f) { search.found=false; search.distance=-1; return; }
    if(travel>search.distance) return;
    travel=std::max(0.f,travel);
    search.found=true; search.distance=travel;
    search.destination={search.origin.x,search.origin.y+travel,search.origin.z};
}
}
#endif
