
#pragma once
#include <vector>
#include <string>
#include <map>
#include <cstdint>
#include <algorithm>
#include <cassert>
#include <iostream>
using uint64=uint64_t;using uint32=uint32_t;using uint16=uint16_t;using uint8=uint8_t;
class ObjectOutputStream {public: int getOffset(){return 0;}void writeInt(int){}void writeInt(int,int){}void writeShort(int){}void writeShort(int,int){}};
class ObjectInputStream {public: int readShort(){return 0;}int readInt(){return 0;}int getOffset(){return 0;}void setOffset(int){}};
class String:public std::string {public:using std::string::string; String()=default; String(const char*s):std::string(s){}bool toBinaryStream(ObjectOutputStream*){return true;}bool parseFromBinaryStream(ObjectInputStream*){return true;} };
template<class T>class Vector { std::vector<T> v;public:Vector()=default;int size()const{return (int)v.size();}bool isEmpty()const{return v.empty();}T&get(int i)const{return const_cast<T&>(v.at(i));}void add(const T&t){v.push_back(t);}void remove(int i){v.erase(v.begin()+i);}void removeAll(){v.clear();}bool contains(const T&t)const{return std::find(v.begin(),v.end(),t)!=v.end();}bool removeElement(const T&t){auto i=std::find(v.begin(),v.end(),t);if(i==v.end())return false;v.erase(i);return true;} };
template<class K,class V>class VectorMap {std::map<K,V> v;public:void setAllowOverwriteInsertPlan(){} V get(K k)const{auto i=v.find(k);return i==v.end()?V():i->second;}void drop(K k){v.erase(k);}void put(K k,const V&value){v[k]=value;}};
template<class T>class ManagedReference {T v;public:ManagedReference(T t=nullptr):v(t){}T get()const{return v;}T operator->()const{return v;} operator T()const{return v;}bool operator==(const ManagedReference&o)const{return v==o.v;}bool operator==(T t)const{return v==t;}};
template<class T,class U>T cast(U u){return static_cast<T>(u);}
struct ReadLocker {explicit ReadLocker(void*){}};struct Locker {explicit Locker(void*){}};
struct Event {char kind;uint64 value;String text;};
class BaseMessage {public:std::vector<Event> events;virtual ~BaseMessage()=default;void insertAscii(const String&s){events.push_back({'s',0,s});}void insertInt(uint32 v){events.push_back({'i',v,{}});}void insertLong(uint64 v){events.push_back({'l',v,{}});}void insertByte(uint8 v){events.push_back({'b',v,{}});}void insertShort(uint16 v){events.push_back({'h',v,{}});}};
class DeltaMessage:public BaseMessage {public:int operations=0;uint32 counter=0;void startList(int n,uint32 c){operations=n;counter=c;}};
namespace nlohmann {class json {public:json&operator[](const char*){return *this;}template<class T>json&operator=(const T&){return *this;}};}
template<class T>struct TypeInfo {static bool parseFromBinaryStream(T*,ObjectInputStream*){return true;}static bool toBinaryStream(T*,ObjectOutputStream*){return true;}};
class TangibleObject {public:uint64 id;uint32 crc;int arrangement;String customization;TangibleObject(uint64 i,uint32 c):id(i),crc(c),arrangement(4),customization("actual"){}virtual ~TangibleObject()=default;virtual bool isArmorObject()const{return false;}uint64 getObjectID()const{return id;}uint32 getClientObjectCRC()const{return crc;}int getContainmentType()const{return arrangement;}void getCustomizationString(String&s)const{s=customization;}};
class ArmorObject:public TangibleObject {public:ArmorObject(uint64 id,uint32 crc):TangibleObject(id,crc){}bool isArmorObject()const override{return true;}uint8 getHitLocation()const{return 1;}bool hasArrangementDescriptor(const char*)const{return false;}};
struct ArmorObjectTemplate {enum {NOLOCATION=0,CHEST=1,ARMS=2,LEGS=4,HEAD=8};};
template<class E>class DeltaVector {protected:Vector<E> vector;uint32 updateCounter=1;public:virtual ~DeltaVector()=default;void*getLock()const{return nullptr;}int size()const{return vector.size();}E&get(int i)const{return vector.get(i);}uint32 getNewUpdateCounter(int n){return updateCounter+=n;}uint32 getUpdateCounter()const{return updateCounter;}virtual bool add(const E&e,DeltaMessage*m=nullptr,int n=1){vector.add(e);updateCounter+=n;if(m){m->startList(n,updateCounter);m->insertByte(1);m->insertShort(size()-1);insertItemToMessage(&get(size()-1),m);}return true;}virtual E remove(int i,DeltaMessage*m=nullptr,int n=1){E e=get(i);vector.remove(i);updateCounter+=n;if(m){m->startList(n,updateCounter);m->insertByte(0);m->insertShort(i);}return e;}virtual void insertItemToMessage(E*,BaseMessage*)const{}virtual void insertToMessage(BaseMessage*)const{}virtual bool toBinaryStream(ObjectOutputStream*){return true;}virtual bool parseFromBinaryStream(ObjectInputStream*){return true;}bool readObjectMember(ObjectInputStream*,const String&){return true;}int writeObjectMembers(ObjectOutputStream*){return 0;}friend void to_json(nlohmann::json&,const DeltaVector&){} };
