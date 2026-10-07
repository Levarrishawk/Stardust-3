#include "appearance_probe.c"
#include <assert.h>
static const char *currentName="object/tangible/wearables/robe/shared_robe_s27.iff";
static const char * __attribute__((thiscall)) fakeName(void *obj) {(void)obj; return currentName;}
static void *__attribute__((cdecl)) fakeParent(void *obj){(void)obj;return (void*)0x2222;}
static void *__attribute__((cdecl)) fakeLookup(const ULONGLONG *id){return *id==333?(void*)0x3333:NULL;}
static DWORD seenValue;
static void *seenObject; static const ULONGLONG *seenDestination; static int seenArrangement;
static void __attribute__((thiscall)) captureContainment(void *obj,const ULONGLONG *dest,int arr){seenObject=obj;seenDestination=dest;seenArrangement=arr;}
static void *seenReceiver; static const DWORD *seenColor;
static void __attribute__((thiscall)) capture(void *r,const DWORD *c){seenReceiver=r;seenColor=c;seenValue=*c;}
static void __attribute__((naked,noinline)) invoke(void *r,const DWORD *c,void *obj){
 __asm__ volatile("pushl %ebp\n\tmovl %esp,%ebp\n\tsubl $0x34,%esp\n\tmovl 16(%ebp),%eax\n\tmovl %eax,-0x34(%ebp)\n\tpushl 12(%ebp)\n\tmovl 8(%ebp),%ecx\n\tcalll _colorHook\n\tmovl %ebp,%esp\n\tpopl %ebp\n\tretl\n\t");
}
int main(void){
 DWORD color=0xfffe92bf; BYTE object[64]={0},templ[32]={0};
 const char *name="object/tangible/wearables/robe/shared_robe_s27.iff";
 DWORD t=(DWORD)templ,n=(DWORD)name; DWORD vt[2]={0,(DWORD)fakeName}, v=(DWORD)vt; (void)n;
 InitializeCriticalSection(&logLock);strcpy(logPath,"abi-test.log");setColor=capture;
 memcpy(object+16,&t,4);memcpy(templ+4,&v,4);
#if APPEARANCE_DIAGNOSTICS
 templateName=fakeName;
#endif
 ULONGLONG sourceID=111, targetID=222, ownerID=333, originalParent=444;
 BYTE target[64]={0}; memcpy(object+0x20,&sourceID,8);memcpy(target+0x20,&targetID,8);
 applyContainment=captureContainment;actualParent=fakeParent;lookupObject=fakeLookup;
 invoke((void*)0x12345678,&color,object);
 assert(seenReceiver==(void*)0x12345678 && seenValue==color && seenColor==&color);
 containmentHook(object,&originalParent,0x7fff0101);
 containmentHook(target,&ownerID,0x7fff0102);
 invoke((void*)0x12345678,&color,object);
 assert(seenValue==0xff00ffff);
 currentName="object/tangible/wearables/shoes/shared_shoes_s02.iff";
 invoke((void*)0x12345678,&color,object);
 assert(seenValue==0xff00ffff);
 assert(inventoryParentHook(target)==(void*)0x3333);
 assert(inventoryParentHook(object)==(void*)0x2222);
 BYTE source2[64]={0},target2[64]={0},target3[64]={0};
 ULONGLONG source2ID=555,target2ID=666,target3ID=777;
 memcpy(source2+0x20,&source2ID,8);memcpy(target2+0x20,&target2ID,8);memcpy(target3+0x20,&target3ID,8);
 containmentHook(target3,&ownerID,0x7fff0102);
 containmentHook(source2,&originalParent,0x7fff0101);
 containmentHook(target2,&ownerID,0x7fff0102);
 assert(appearanceSourceCount==2 && appearanceTargetCount==3);
 invoke((void*)0x12345678,&color,source2);assert(seenValue==0xff00ffff);
 invoke((void*)0x12345678,&color,object);assert(seenValue==0xff00ffff);
 assert(inventoryParentHook(target2)==(void*)0x3333 && inventoryParentHook(target3)==(void*)0x3333);
 /* Duplicate target markers must not transfer ownership to another appearance. */
 containmentHook(target,&ownerID,0x7fff0102);
 assert(appearanceTargetCount==3 && appearanceTargets[0].source==sourceID);
 /* Removing one selection is a reset followed by replay of the remaining one. */
 containmentHook(target,&ownerID,0x7fff0100);
 containmentHook(source2,&originalParent,0x7fff0101);
 containmentHook(target2,&ownerID,0x7fff0102);
 invoke((void*)0x12345678,&color,object);assert(seenValue==color);
 invoke((void*)0x12345678,&color,source2);assert(seenValue==0xff00ffff);
 assert(inventoryParentHook(target)==(void*)0x2222 && inventoryParentHook(target2)==(void*)0x3333);
 /* Cache bounds reject excess sources without attaching targets to the previous source. */
 containmentHook(target,&ownerID,0x7fff0100);
 BYTE extra[64]={0};
 for (ULONGLONG i=1000;i<1000+MAX_APPEARANCE_SOURCES+1;i++) {
  memcpy(extra+0x20,&i,8);containmentHook(extra,&originalParent,0x7fff0101);
 }
 assert(appearanceSourceCount==MAX_APPEARANCE_SOURCES && pendingAppearanceSource==0);
 containmentHook(target,&ownerID,0x7fff0102);assert(appearanceTargetCount==0);
 containmentHook(target,&ownerID,0x7fff0100);
 containmentHook(object,&originalParent,0x7fff0101);
 for (ULONGLONG i=2000;i<2000+MAX_APPEARANCE_TARGETS+1;i++) {
  memcpy(extra+0x20,&i,8);containmentHook(extra,&ownerID,0x7fff0102);
 }
 assert(appearanceTargetCount==MAX_APPEARANCE_TARGETS);

 currentName="object/tangible/wearables/armor/composite/shared_armor_composite_chest_plate.iff";
 invoke((void*)0x12345678,&color,target);
 assert(seenColor==&color && seenValue==color);
 containmentHook(target,&ownerID,0x7fff0100);
 assert(inventoryParentHook(target)==(void*)0x2222);
 currentName="object/tangible/wearables/robe/shared_robe_s27.iff";
 invoke((void*)0x12345678,&color,object);
 assert(seenReceiver==(void*)0x12345678 && seenValue==color && seenColor==&color);
 invoke((void*)0x12345678,&color,(void*)1);
 assert(seenColor==&color && seenValue==color);
 logObject("invalid-object",0,(void*)1);
 BYTE contained[48]={0}; ULONGLONG item=123456, dest=765432;
 memcpy(contained+0x20,&item,8);applyContainment=captureContainment;
 containmentHook(contained,&dest,-1);
 assert(seenObject==contained && seenDestination==&dest && seenArrangement==-1);
 puts("PASS: multiple appearances, multiple covered targets, selective reset/replay, duplicate markers and cache bounds; normal duster uses original color; explicit cosmetic state uses alternate color; target inventory parent override and clear/reset work; containment forwards unchanged.");return 0;
}
