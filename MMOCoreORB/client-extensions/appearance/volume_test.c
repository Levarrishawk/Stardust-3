
#include "appearance_probe.c"
#include <assert.h>
static BYTE objects[12][64],properties[12][48],containers[2][48];
static int filler[2];
static void setParent(int i,void*p){memcpy(objects[i]+0x30,&p,4);}
static void* __attribute__((cdecl)) parentOf(void*o){void*p;memcpy(&p,(BYTE*)o+0x30,4);return p;}
static void* __attribute__((cdecl)) findObject(const ULONGLONG*id){for(int i=0;i<12;i++)if(objectID(objects[i])==*id)return objects[i];return NULL;}
static void* __attribute__((cdecl)) getContainer(void*o){return o==objects[0]?containers[0]:o==objects[1]?containers[1]:NULL;}
static void* __attribute__((thiscall)) getProperty(void*o,const DWORD*id){assert(*id==0x8701647c);for(int i=0;i<12;i++)if(o==objects[i])return properties[i];return NULL;}
static int __attribute__((thiscall)) getVolume(void*p){int v;memcpy(&v,(BYTE*)p+12,4);void*c=getContainer(propertyOwner(p));if(c)v+=*(int*)((BYTE*)c+0x20);return v;}
static int __attribute__((thiscall)) recalc(void*c){int which=c==containers[0]?0:1,raw=filler[which];void*owner=propertyOwner(c);for(int i=0;i<12;i++)if(parentOf(objects[i])==owner)raw+=recalculatedItemVolume(properties[i],c);raw=recalculatedVolume(c,raw);*(int*)((BYTE*)c+0x20)=raw;assert(raw<=*(int*)((BYTE*)c+0x24));if(which==1 && parentOf(owner)==objects[0])recalc(containers[0]);return raw;}
static void __attribute__((thiscall)) moveObject(void*o,const ULONGLONG*dest,int arrangement){(void)arrangement;void*old=parentOf(o);void*newParent=findObject(dest);if(old==newParent)return;void*oldC=getContainer(old);void*newC=getContainer(newParent);void*p=getProperty(o,&(DWORD){0x8701647c});int vol=accountedVolume(p);if(newC)assert(*(int*)((BYTE*)newC+0x20)+vol<=*(int*)((BYTE*)newC+0x24));if(oldC){*(int*)((BYTE*)oldC+0x20)-=vol;if(old==objects[1]&&parentOf(old)==objects[0])*(int*)(containers[0]+0x20)-=vol;}if(newC){*(int*)((BYTE*)newC+0x20)+=vol;if(newParent==objects[1]&&parentOf(newParent)==objects[0])*(int*)(containers[0]+0x20)+=vol;}for(int i=0;i<12;i++)if(o==objects[i])setParent(i,newParent);}
static void markerFor(int i,ULONGLONG parent,int arrangement){containmentHook(objects[i],&parent,arrangement);}
static void begin(void){markerFor(9,0,0x7fff0103);markerFor(9,0,0x7fff0100);}
static void end(void){markerFor(9,0,0x7fff0104);}
static int __attribute__((naked,noinline)) sumAdapter(void*c,int raw){
 __asm__ volatile("pushl %ebp\n\tmovl %esp,%ebp\n\tsubl $0x14,%esp\n\tpushl %edi\n\tmovl 8(%ebp),%edi\n\tmovl 12(%ebp),%eax\n\tmovl %eax,-0x14(%ebp)\n\tcalll _recalcSumHook\n\tpopl %ecx\n\tpopl %edi\n\tmovl %ebp,%esp\n\tpopl %ebp\n\tretl\n\t");
}
static int __attribute__((naked,noinline)) itemAdapter(void*p,void*c){
 __asm__ volatile("pushl %edi\n\tmovl 12(%esp),%edi\n\tmovl 8(%esp),%ecx\n\tcalll _recalcItemHook\n\tpopl %edi\n\tretl\n\t");
}
static void setup(int full,int nested){
 memset(objects,0,sizeof(objects));memset(properties,0,sizeof(properties));memset(containers,0,sizeof(containers));
 clearAppearanceState();volumeSourceCount=volumeTargetCount=0;visualTransaction=FALSE;
 for(int i=0;i<12;i++){ULONGLONG id=100+i;void*o=objects[i];int vol=((i>=1&&i<=8)||i==10)?1:0;memcpy(o+0x20,&id,8);memcpy(properties[i]+4,&o,4);memcpy(properties[i]+12,&vol,4);}
 void*inv=objects[0];void*bag=objects[1];memcpy(containers[0]+4,&inv,4);memcpy(containers[1]+4,&bag,4);*(int*)(containers[0]+0x24)=80;*(int*)(containers[1]+0x24)=20;
 filler[0]=nested?(full?78:0):(full?79:2);filler[1]=0;
 setParent(1,nested?inv:NULL);setParent(2,nested?bag:inv);for(int i=3;i<=7;i++)setParent(i,objects[9]);setParent(8,NULL);
 recalc(containers[1]);recalc(containers[0]);
}
static void equip(void){begin();markerFor(2,objectID(parentOf(objects[2])),0x7fff0101);for(int i=3;i<=7;i++){markerFor(i,109,0x7fff0102);markerFor(i,100,-1);}markerFor(2,109,4);end();}
static void removeAppearance(void){begin();markerFor(2,volumeSources[0].parent,-1);for(int i=3;i<=7;i++)markerFor(i,109,4);end();}
int main(void){
 InitializeCriticalSection(&logLock);strcpy(logPath,"volume-test.log");actualParent=parentOf;lookupObject=findObject;volumeProperty=getProperty;originalVolume=getVolume;volumeContainer=getContainer;recalculateContainer=recalc;applyContainment=moveObject;
 for(int full=0;full<=1;full++)for(int nested=0;nested<=1;nested++){
  setup(full,nested);int before=*(int*)(containers[0]+0x20),bagBefore=*(int*)(containers[1]+0x20);
  equip();assert(*(int*)(containers[0]+0x20)==before);assert(*(int*)(containers[1]+0x20)==bagBefore);
  assert(sourceVolume(objects[2])==1);assert(accountedVolume(properties[3])==1); /* normal native calls remain unchanged outside a transaction */
  assert(itemAdapter(properties[3],containers[0])==0);
  assert(sumAdapter(nested?containers[1]:containers[0],nested?0:before-1)==(nested?1:before));
  recalc(containers[1]);recalc(containers[0]);assert(*(int*)(containers[0]+0x20)==before);
  if(full)assert(*(int*)(containers[0]+0x20)+sourceVolume(objects[8])>80); /* ordinary item remains blocked at full capacity */
  removeAppearance();assert(volumeSourceCount==0 && volumeTargetCount==0 && !visualTransaction);assert(*(int*)(containers[0]+0x20)==before);
  equip();removeAppearance();assert(*(int*)(containers[0]+0x20)==before);
 }
 setup(0,0);setParent(8,objects[0]);setParent(10,objects[9]);recalc(containers[0]);assert(*(int*)(containers[0]+0x20)==4);
 equip();begin();markerFor(2,100,0x7fff0101);for(int i=3;i<=7;i++)markerFor(i,109,0x7fff0102);
 markerFor(8,100,0x7fff0101);markerFor(10,109,0x7fff0102);markerFor(10,100,-1);markerFor(8,109,4);end();
 assert(volumeSourceCount==2 && *(int*)(containers[0]+0x20)==4);
 begin();markerFor(2,100,-1);for(int i=3;i<=7;i++)markerFor(i,109,4);
 markerFor(8,100,0x7fff0101);markerFor(10,109,0x7fff0102);end();
 assert(volumeSourceCount==1 && *(int*)(containers[0]+0x20)==4);
 begin();markerFor(8,100,-1);markerFor(10,109,4);end();assert(volumeSourceCount==0 && *(int*)(containers[0]+0x20)==4);
 setup(0,1);equip();begin();markerFor(2,0,-1);for(int i=3;i<=7;i++)markerFor(i,109,4);end();assert(*(int*)(containers[1]+0x20)==0);assert(*(int*)(containers[0]+0x20)==1);
 setup(0,0);markerFor(9,0,0x7fff0100);markerFor(2,100,0x7fff0101);assert(volumeSourceCount==0 && !visualTransaction); /* old server fallback */
 puts("PASS: 3/80 remains 3/80 with five covered targets; 80/80 equip/removal; nested bag and ancestor accounting; recalculation adapters; repeated cycles; moved-source cleanup; legacy-server fallback.");return 0;
}
