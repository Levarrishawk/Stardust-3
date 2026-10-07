
#include "server/zone/objects/creature/variables/WearablesDeltaVector.h"
static std::vector<uint64> ids(const BaseMessage&m){std::vector<uint64> out;for(const auto&e:m.events)if(e.kind=='l')out.push_back(e.value);return out;}
static std::vector<uint64> crcs(const BaseMessage&m){std::vector<uint64> out;for(size_t i=0;i+1<m.events.size();++i)if(m.events[i].kind=='l'){assert(m.events[i+1].kind=='i');out.push_back(m.events[i+1].value);}return out;}
int main(){
 WearablesDeltaVector v;ArmorObject chest(1,101),arm1(2,102),arm2(3,103);TangibleObject boots(4,104),other(5,105);
 v.add(&chest);v.add(&arm1);v.add(&arm2);v.add(&boots);v.add(&other);
 WearablesDeltaVector::AppearanceSelection a;a.sourceID=111;a.crc=900;a.customization="duster";a.slots.add("chest");a.slots.add("bicep_l");a.targets.add(1);a.targets.add(2);a.targets.add(3);v.addAppearance(a);
 WearablesDeltaVector::AppearanceSelection b;b.sourceID=222;b.crc=901;b.customization="shoes";b.slots.add("shoes");b.targets.add(4);v.addAppearance(b);
 BaseMessage baseline;v.insertToMessage(&baseline);
 assert(baseline.events[0].value==3);assert((ids(baseline)==std::vector<uint64>{1,4,5}));assert((crcs(baseline)==std::vector<uint64>{900,901,105}));
 assert(v.size()==5 && v.getArmorAtHitLocation(0).size()==3);
 Vector<String> slots;slots.add("bicep_l");assert(v.getAppearanceSlotConflict(333,slots)=="bicep_l");assert(v.getAppearanceSlotConflict(111,slots).empty());slots.removeAll();slots.add("head");assert(v.getAppearanceSlotConflict(333,slots).empty());
 uint32 counter=v.getUpdateCounter();DeltaMessage delta;v.refreshAppearance(&delta);assert(delta.operations==4 && delta.counter==counter+4 && delta.events[0].kind=='b' && delta.events[0].value==4);assert(ids(delta)==ids(baseline));
 v.clearAppearance(111);DeltaMessage removed;v.refreshAppearance(&removed);assert(removed.operations==6);assert((ids(removed)==std::vector<uint64>{1,2,3,4,5}));assert((crcs(removed)==std::vector<uint64>{101,102,103,901,105}));assert(v.isAppearanceEquipped(222) && !v.isAppearanceEquipped(111));
 v.remove(2,nullptr,0);DeltaMessage equipped;v.refreshAppearance(&equipped);assert(equipped.operations==5);assert((ids(equipped)==std::vector<uint64>{1,2,4,5}));assert(v.getArmorAtHitLocation(0).size()==2);
 v.clearAppearance();BaseMessage restored;v.insertToMessage(&restored);assert((crcs(restored)==std::vector<uint64>{101,102,104,105}));
 Vector<uint64> hidden;hidden.add(5);v.setHiddenContainers(hidden);BaseMessage hiddenBag;v.insertToMessage(&hiddenBag);
 assert((ids(hiddenBag)==std::vector<uint64>{1,2,4}) && v.size()==4 && v.isContainerHidden(5));
 DeltaMessage hideDelta;v.refreshAppearance(&hideDelta);assert(hideDelta.operations==4 && ids(hideDelta)==ids(hiddenBag));
 v.addAppearance(b);BaseMessage both;v.insertToMessage(&both);assert((crcs(both)==std::vector<uint64>{101,102,901}));

 // Hidden head equipment suppresses its cosmetic replacement independently of the bag.
 hidden.add(4);v.setHiddenContainers(hidden);BaseMessage hiddenHead;v.insertToMessage(&hiddenHead);
 assert((ids(hiddenHead)==std::vector<uint64>{1,2}) && v.isAppearanceEquipped(222) && v.size()==4);
 hidden.removeAll();hidden.add(5);v.setHiddenContainers(hidden);BaseMessage shownHead;v.insertToMessage(&shownHead);
 assert(crcs(shownHead)==crcs(both) && v.isContainerHidden(5));
 v.clearAppearance();assert(v.isContainerHidden(5));hidden.removeAll();v.setHiddenContainers(hidden);
 BaseMessage shown;v.insertToMessage(&shown);assert(ids(shown)==ids(restored) && !v.isContainerHidden(5));
 std::cout<<"PASS: actual WearablesDeltaVector projects all covered targets once, preserves armor, uses projected counts and delta counters, rejects slot conflicts, and removes one selection independently. Engine dependencies are stand-ins; Debian compilation remains required.\n";
}
