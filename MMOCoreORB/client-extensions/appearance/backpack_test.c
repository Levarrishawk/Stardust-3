#include "appearance_probe.c"
#include <assert.h>
static BYTE owner[64], otherOwner[64], bag[64], clothing[64], appearance[256], otherAppearance[256];
static DWORD vtable[32];
static unsigned collects, invalidations, moves;
static void *seenAppearance, *seenMesh;
static int seenLod;
static void * __attribute__((cdecl)) findOwner(const ULONGLONG *id) { return *id == 333 ? owner : *id == 444 ? otherOwner : NULL; }
static void * __attribute__((thiscall)) asSkeleton(void *value) { return value; }
static void __attribute__((thiscall)) dirty(void *value) { assert(value == appearance || value == otherAppearance); ++invalidations; }
static void __attribute__((thiscall)) collect(void *value, void *mesh, int lod) { ++collects; seenAppearance = value; seenMesh = mesh; seenLod = lod; }
static void __attribute__((thiscall)) move(void *value, const ULONGLONG *destination, int arrangement) { (void)value; (void)destination; (void)arrangement; ++moves; }
/* Mirror the verified caller's saved parent appearance and register/stack arguments. */
static void __attribute__((naked,noinline)) invokeMesh(void *childAppearance, void *mesh, int lod, void *object, void *parentAppearance) {
 __asm__ volatile("pushl %ebp\n\tmovl %esp,%ebp\n\tsubl $4,%esp\n\tmovl 24(%ebp),%eax\n\tmovl %eax,-4(%ebp)\n\t"
  "pushl 16(%ebp)\n\tpushl 12(%ebp)\n\tmovl 20(%ebp),%eax\n\tmovl 8(%ebp),%ecx\n\tcalll _containerMeshHook\n\t"
  "movl %ebp,%esp\n\tpopl %ebp\n\tretl\n\t");
}
static void writeID(void *object, ULONGLONG id) { memcpy((BYTE *)object + 0x20, &id, 8); }
static void writePointer(void *object, unsigned offset, void *value) { memcpy((BYTE *)object + offset, &value, 4); }
int main(void) {
 InitializeCriticalSection(&logLock);
 lookupObject = findOwner; dirtyMesh = dirty; collectMesh = collect; applyContainment = move;
 writeID(owner,333); writeID(otherOwner,444); writeID(bag,111); writeID(clothing,222);
 vtable[0x74 / 4] = (DWORD)asSkeleton;
 writePointer(appearance,0,vtable); writePointer(appearance,0x0c,owner); writePointer(owner,0x28,appearance);
 writePointer(otherAppearance,0,vtable); writePointer(otherAppearance,0x0c,otherOwner); writePointer(otherOwner,0x28,otherAppearance);
 BYTE before[64]; memcpy(before,bag,sizeof(bag));
 ULONGLONG destination = 333;
 containmentHook(bag,&destination,0x7fff0105);
 assert(hiddenContainerCount == 1 && invalidations == 1 && moves == 0);
 assert(memcmp(before,bag,sizeof(bag)) == 0 && volumeTargetCount == 0 && volumeSourceCount == 0);
 invokeMesh((void *)0x1234,(void *)0x5678,3,bag,appearance); assert(collects == 0);
 invokeMesh((void *)0x1234,(void *)0x5678,3,clothing,appearance);
 assert(collects == 1 && seenAppearance == (void *)0x1234 && seenMesh == (void *)0x5678 && seenLod == 3);
 invokeMesh((void *)0x1234,(void *)0x5678,3,bag,otherAppearance); assert(collects == 2);
 containmentHook(bag,&destination,0x7fff0105); assert(hiddenContainerCount == 1);
 containmentHook(owner,&destination,0x7fff0107); assert(hiddenContainerCount == 0 && moves == 0);
 invokeMesh((void *)0x1234,(void *)0x5678,3,bag,appearance); assert(collects == 3);
 destination = 444; containmentHook(bag,&destination,0x7fff0105);
 destination = 333; containmentHook(owner,&destination,0x7fff0107); assert(hiddenContainerCount == 0);
 destination = 444; containmentHook(otherOwner,&destination,0x7fff0107); assert(hiddenContainerCount == 0);
 for (unsigned i=0;i<MAX_HIDDEN_CONTAINERS+2;++i) setContainerVisibility(1000+i,333,FALSE);
 assert(hiddenContainerCount == MAX_HIDDEN_CONTAINERS);
 setContainerVisibility(333,333,TRUE); assert(hiddenContainerCount == 0);
 puts("PASS: backpack mesh suppression/restoration; native stack adapter; unchanged object and containment; no volume accounting entries; normal clothing; owner isolation; duplicate markers; bounded cache.");
 return 0;
}
