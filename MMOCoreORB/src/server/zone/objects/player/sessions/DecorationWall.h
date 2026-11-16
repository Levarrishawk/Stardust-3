#ifndef DECORATIONWALL_H_
#define DECORATIONWALL_H_
#include <array>
#include <algorithm>
#include <cmath>

namespace DecorationWall {
struct Point { float x, y, z; };
inline Point subtract(Point a, Point b) { return {a.x-b.x,a.y-b.y,a.z-b.z}; }
inline float dot(Point a, Point b) { return a.x*b.x+a.y*b.y+a.z*b.z; }
inline Point cross(Point a, Point b) { return {a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x}; }
inline bool finite(Point p) { return std::isfinite(p.x)&&std::isfinite(p.y)&&std::isfinite(p.z); }
inline Point rotate(Point p, const std::array<float,4>& q) {
    Point v={q[0],q[1],q[2]}, t=cross(v,p), u=cross(v,t);
    return {p.x+2*(q[3]*t.x+u.x),p.y+2*(q[3]*t.y+u.y),p.z+2*(q[3]*t.z+u.z)};
}
struct Search {
    Point origin, destination;
    std::array<Point,8> corners;
    float height=0, distance=32;
    bool found=false;
    bool initialize(Point position, Point low, Point high, const std::array<float,4>& q) {
        if(!finite(position)||!finite(low)||!finite(high)||low.x>high.x||low.y>high.y||low.z>high.z) return false;
        float norm=0; for(float value:q) { if(!std::isfinite(value)) return false; norm+=value*value; }
        if(std::fabs(norm-1)>0.01f || dot(subtract(high,low),subtract(high,low))<0.000001f) return false;
        origin=destination=position; found=false; distance=32;
        for(int i=0;i<8;++i) corners[i]=rotate({i&1?high.x:low.x,i&2?high.y:low.y,i&4?high.z:low.z},q);
        Point center=rotate({(low.x+high.x)/2,(low.y+high.y)/2,(low.z+high.z)/2},q);
        height=position.y+std::max(0.1f,center.y);
        return true;
    }
    void consider(const std::array<Point,3>& triangle) {
        for(Point p:triangle) if(!finite(p)) return;
        Point normal=cross(subtract(triangle[1],triangle[0]),subtract(triangle[2],triangle[0]));
        float n2=dot(normal,normal);
        if(n2<0.000001f || normal.y*normal.y>n2*0.0225f) return; // near-vertical walls only
        Point hits[3]; int count=0;
        for(int i=0;i<3;++i) {
            Point a=triangle[i], b=triangle[(i+1)%3];
            if((a.y<=height && b.y>height)||(b.y<=height && a.y>height)) {
                float t=(height-a.y)/(b.y-a.y);
                hits[count++]={a.x+(b.x-a.x)*t,height,a.z+(b.z-a.z)*t};
            }
        }
        if(count!=2) return;
        Point edge=subtract(hits[1],hits[0]), offset=subtract(origin,hits[0]); edge.y=offset.y=0;
        float length2=dot(edge,edge); if(length2<0.000001f) return;
        float t=dot(offset,edge)/length2;
        if(t < -0.00001f || t > 1.00001f) return; // perpendicular projection must land on the wall
        t=std::max(0.f,std::min(1.f,t));
        Point toward={hits[0].x+edge.x*t-origin.x,0,hits[0].z+edge.z*t-origin.z};
        float length=std::sqrt(dot(toward,toward)); if(length<0.0001f || length>32) return;
        toward.x/=length; toward.z/=length;
        float support=dot(corners[0],toward);
        for(Point corner:corners) support=std::max(support,dot(corner,toward));
        float travel=length-support-0.02f;
        if(travel < -0.03f || travel>distance) return; // do not pull an overlapping item through a wall
        travel=std::max(0.f,travel);
        found=true; distance=travel;
        destination={origin.x+toward.x*travel,origin.y,origin.z+toward.z*travel};
    }
};
}
#endif
