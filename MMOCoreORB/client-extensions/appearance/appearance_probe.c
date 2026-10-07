#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <bcrypt.h>
#include <d3d9.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>

/* Set to 1 only for local diagnostics; distributed builds log startup status only. */
#ifndef APPEARANCE_DIAGNOSTICS
#define APPEARANCE_DIAGNOSTICS 0
#endif
typedef void (__attribute__((thiscall)) *WearFunction)(void *, void *);
typedef void (__attribute__((thiscall)) *ColorFunction)(void *, const DWORD *);
typedef IDirect3D9 *(WINAPI *CreateFunction)(UINT);
typedef int (WINAPI *BeginFunction)(DWORD, LPCWSTR);
typedef int (WINAPI *EndFunction)(void);
typedef void (WINAPI *MarkerFunction)(DWORD, LPCWSTR);
static HMODULE module, baseProxy;
static CreateFunction create9;
static BeginFunction beginEvent;
static EndFunction endEvent;
static MarkerFunction marker;
#if APPEARANCE_DIAGNOSTICS
static WearFunction wear;
#endif
static ColorFunction setColor;
typedef const char *(__attribute__((thiscall)) *NameFunction)(void *);
#if APPEARANCE_DIAGNOSTICS
static NameFunction templateName;
#endif
typedef void (__attribute__((thiscall)) *ContainmentFunction)(void *, const ULONGLONG *, int);
static ContainmentFunction applyContainment;
#if APPEARANCE_DIAGNOSTICS
static LONG containmentCount;
#endif
static CRITICAL_SECTION logLock;
#define MAX_APPEARANCE_SOURCES 64
#define MAX_APPEARANCE_TARGETS 256
static ULONGLONG appearanceSources[MAX_APPEARANCE_SOURCES], pendingAppearanceSource;
static struct { ULONGLONG target, owner, source; } appearanceTargets[MAX_APPEARANCE_TARGETS];
static unsigned appearanceSourceCount, appearanceTargetCount;
/* Accounting survives a reset until the transaction's end marker. */
#define MAX_VOLUME_SOURCES (MAX_APPEARANCE_SOURCES * 2)
#define MAX_VOLUME_TARGETS (MAX_APPEARANCE_TARGETS * 2)
static struct { ULONGLONG id, parent; } volumeSources[MAX_VOLUME_SOURCES];
static ULONGLONG volumeTargets[MAX_VOLUME_TARGETS];
static unsigned volumeSourceCount, volumeTargetCount;
static BOOL visualTransaction;
typedef void *(__attribute__((thiscall)) *VolumePropertyFunction)(void *, const DWORD *);
typedef int (__attribute__((thiscall)) *VolumeFunction)(void *);
static VolumePropertyFunction volumeProperty;
static VolumeFunction originalVolume, recalculateContainer;
typedef void *(__attribute__((cdecl)) *VolumeContainerFunction)(void *);
static VolumeContainerFunction volumeContainer;

typedef void *(__attribute__((cdecl)) *ParentFunction)(void *);
typedef void *(__attribute__((cdecl)) *LookupFunction)(const ULONGLONG *);
static ParentFunction actualParent;
static LookupFunction lookupObject;
typedef void (__attribute__((thiscall)) *CollectMeshFunction)(void *, void *, int);
typedef void (__attribute__((thiscall)) *DirtyMeshFunction)(void *);
typedef void *(__attribute__((thiscall)) *SkeletalFunction)(void *);
static CollectMeshFunction collectMesh;
static DirtyMeshFunction dirtyMesh;
#define MAX_HIDDEN_CONTAINERS 64
static struct { ULONGLONG id, owner; } hiddenContainers[MAX_HIDDEN_CONTAINERS];
static unsigned hiddenContainerCount;
static ULONGLONG objectID(void *object) {
 ULONGLONG id = 0; SIZE_T bytes;
 if (object == NULL || !ReadProcessMemory(GetCurrentProcess(),
     (BYTE *)object + 0x20, &id, sizeof(id), &bytes) || bytes != sizeof(id)) return 0;
 return id;
}
static void *readPointer(void *object, unsigned offset) {
 void *result = NULL; SIZE_T bytes;
 if (object != NULL && ReadProcessMemory(GetCurrentProcess(), (BYTE *)object + offset,
     &result, sizeof(result), &bytes) && bytes == sizeof(result)) return result;
 return NULL;
}
static void invalidateOwnerMesh(ULONGLONG ownerID) {
 void *owner = lookupObject(&ownerID);
 void *appearance = readPointer(owner, 0x28);
 void *vtable = readPointer(appearance, 0);
 SkeletalFunction asSkeletal = (SkeletalFunction)readPointer(vtable, 0x74);
 void *skeletal = asSkeletal != NULL ? asSkeletal(appearance) : NULL;
 if (skeletal != NULL) dirtyMesh(skeletal);
}
static void setContainerVisibility(ULONGLONG id, ULONGLONG owner, BOOL reset) {
 EnterCriticalSection(&logLock);
 if (reset) {
  /* Owner-only snapshots also clear the previous character on a soft relog. */
  hiddenContainerCount = 0;
 } else {
  unsigned i;
  for (i = 0; i < hiddenContainerCount; ++i) if (hiddenContainers[i].id == id) break;
  if (i < MAX_HIDDEN_CONTAINERS) {
   hiddenContainers[i].id = id; hiddenContainers[i].owner = owner;
   if (i == hiddenContainerCount) ++hiddenContainerCount;
  }
 }
 LeaveCriticalSection(&logLock);
 invalidateOwnerMesh(owner);
}
static void __attribute__((stdcall,used,noinline)) collectVisibleMesh(void *appearance,
 void *mesh, int lod, void *object, void *wearerAppearance) {
 ULONGLONG id = objectID(object);
 /* This recursive call collects a worn child's mesh, never its inventory icon. */
 ULONGLONG owner = objectID(readPointer(wearerAppearance, 0x0c));
 BOOL hidden = FALSE;
 EnterCriticalSection(&logLock);
 for (unsigned i = 0; id != 0 && i < hiddenContainerCount; ++i) {
  if (hiddenContainers[i].id == id && hiddenContainers[i].owner == owner) { hidden = TRUE; break; }
 }
 LeaveCriticalSection(&logLock);
 if (!hidden) collectMesh(appearance, mesh, lod);
}
static void __attribute__((naked)) containerMeshHook(void) {
 __asm__ volatile("pushl -4(%ebp)\n\tpushl %eax\n\tpushl 16(%esp)\n\tpushl 16(%esp)\n\tpushl %ecx\n\t"
  "calll _collectVisibleMesh@20\n\tretl $8\n\t");
}
static void clearAppearanceState(void) {
 appearanceSourceCount = appearanceTargetCount = 0;
 pendingAppearanceSource = 0;
}
static void * __attribute__((cdecl)) inventoryParentHook(void *object) {
 ULONGLONG id = objectID(object), owner = 0;
 void *parent;
 EnterCriticalSection(&logLock);
 for (unsigned i = 0; id != 0 && i < appearanceTargetCount; ++i) {
  if (id == appearanceTargets[i].target) { owner = appearanceTargets[i].owner; break; }
 }
 LeaveCriticalSection(&logLock);
 if (owner != 0) {
  parent = lookupObject(&owner);
  if (parent != NULL) return parent;
 }
 return actualParent(object);
}

static void *propertyOwner(void *property) {
 void *owner = NULL; SIZE_T bytes;
 if (property == NULL || !ReadProcessMemory(GetCurrentProcess(), (BYTE *)property + 4,
     &owner, sizeof(owner), &bytes) || bytes != sizeof(owner)) return NULL;
 return owner;
}
static int sourceVolume(void *object) {
 const DWORD propertyID = 0x8701647c;
 void *property = object != NULL ? volumeProperty(object, &propertyID) : NULL;
 return property != NULL ? originalVolume(property) : 0;
}
static BOOL volumeIdentity(ULONGLONG id, ULONGLONG *originalParent, BOOL *target) {
 BOOL found = FALSE;
 *originalParent = 0; *target = FALSE;
 EnterCriticalSection(&logLock);
 for (unsigned i = 0; id != 0 && i < volumeSourceCount; ++i) {
  if (volumeSources[i].id == id) { *originalParent = volumeSources[i].parent; found = TRUE; break; }
 }
 for (unsigned i = 0; id != 0 && i < volumeTargetCount; ++i) {
  if (volumeTargets[i] == id) { *target = TRUE; found = TRUE; break; }
 }
 LeaveCriticalSection(&logLock);
 return found;
}
static int __attribute__((thiscall)) accountedVolume(void *property) {
 ULONGLONG parent; BOOL target, transaction;
 EnterCriticalSection(&logLock); transaction = visualTransaction; LeaveCriticalSection(&logLock);
 if (transaction && volumeIdentity(objectID(propertyOwner(property)), &parent, &target)) return 0;
 return originalVolume(property);
}
static int __attribute__((stdcall,used,noinline)) recalculatedItemVolume(void *property, void *container) {
 void *object = propertyOwner(property);
 ULONGLONG parent; BOOL target;
 if (volumeIdentity(objectID(object), &parent, &target)) {
  if (target) return 0;
  if (parent != objectID(propertyOwner(container))) return 0;
 }
 return originalVolume(property);
}
static int __attribute__((stdcall,used,noinline)) recalculatedVolume(void *container, int physical) {
 ULONGLONG sources[MAX_VOLUME_SOURCES], parents[MAX_VOLUME_SOURCES];
 unsigned count;
 ULONGLONG containerID = objectID(propertyOwner(container));
 if (containerID == 0) return physical;
 EnterCriticalSection(&logLock);
 count = volumeSourceCount;
 for (unsigned i = 0; i < count; ++i) { sources[i] = volumeSources[i].id; parents[i] = volumeSources[i].parent; }
 LeaveCriticalSection(&logLock);
 for (unsigned i = 0; i < count; ++i) {
  if (parents[i] != containerID) continue;
  void *source = lookupObject(&sources[i]);
  if (source != NULL && objectID(actualParent(source)) != containerID) {
   int volume = sourceVolume(source);
   if (volume > 0 && physical <= INT_MAX - volume) physical += volume;
  }
 }
 return physical;
}
static void __attribute__((naked)) recalcItemHook(void) {
 __asm__ volatile("pushl %edi\n\tpushl %ecx\n\tcalll _recalculatedItemVolume@8\n\tretl\n\t");
}
/* Replaces load sum, push container, store sum; retain the original cdecl argument. */
static void __attribute__((naked)) recalcSumHook(void) {
 __asm__ volatile("pushl -0x14(%ebp)\n\tpushl %edi\n\tcalll _recalculatedVolume@8\n\tmovl %eax,-0x14(%ebp)\n\tmovl %eax,0x20(%edi)\n\tpopl %edx\n\tpushl %edi\n\tpushl %edx\n\tretl\n\t");
}
static void finishVisualTransaction(void) {
 unsigned out = 0;
 for (unsigned i = 0; i < volumeSourceCount; ++i) {
  for (unsigned j = 0; j < appearanceSourceCount; ++j) {
   if (volumeSources[i].id == appearanceSources[j]) { volumeSources[out++] = volumeSources[i]; break; }
  }
 }
 volumeSourceCount = out; out = 0;
 for (unsigned i = 0; i < volumeTargetCount; ++i) {
  for (unsigned j = 0; j < appearanceTargetCount; ++j) {
   if (volumeTargets[i] == appearanceTargets[j].target) { volumeTargets[out++] = volumeTargets[i]; break; }
  }
 }
 volumeTargetCount = out; visualTransaction = FALSE;
}

static char logPath[MAX_PATH];
#if APPEARANCE_DIAGNOSTICS
static LONG wearCount, colorCount;
#endif
static BOOL installed;

static void logEvent(const char *kind, DWORD site, void *receiver,
	void *argument, DWORD value) {
	FILE *file;
	SYSTEMTIME time;
	GetLocalTime(&time);
	EnterCriticalSection(&logLock);
	file = fopen(logPath, "a");
	if (file != NULL) {
		fprintf(file, "%04u-%02u-%02u %02u:%02u:%02u.%03u "
			"pid=%lu tid=%lu %s site=%08lx receiver=%p argument=%p value=%08lx\n",
			time.wYear, time.wMonth, time.wDay, time.wHour, time.wMinute,
			time.wSecond, time.wMilliseconds, GetCurrentProcessId(), GetCurrentThreadId(), kind,
			site, receiver, argument, value);
		fclose(file);
	}
	LeaveCriticalSection(&logLock);
}

#if APPEARANCE_DIAGNOSTICS
static BOOL logObject(const char *kind, DWORD site, void *object) {
 DWORD templateAddress = 0, vtable = 0, getter = 0, nameAddress;
 SIZE_T bytes;
 char name[320] = {0};
 FILE *file;
 unsigned int i;
 BYTE *base = (BYTE *)GetModuleHandleW(NULL);
 /* Object::template-name path: 0xb23c40 -> Object+0x10 -> 0xaa5730.
  * The CRCString at template+4 supplies its string through vtable slot 1. */
 if (object == NULL || templateName == NULL ||
     !ReadProcessMemory(GetCurrentProcess(), (BYTE *)object + 0x10,
     &templateAddress, 4, &bytes) || bytes != 4 || templateAddress == 0 ||
     !ReadProcessMemory(GetCurrentProcess(), (void *)(templateAddress + 4),
     &vtable, 4, &bytes) || bytes != 4 || vtable == 0 ||
     !ReadProcessMemory(GetCurrentProcess(), (void *)(vtable + 4),
     &getter, 4, &bytes) || bytes != 4 ||
     getter < (DWORD)base + 0x1000 || getter >= (DWORD)base + 0x11dc000)
     return FALSE;
 nameAddress = (DWORD)templateName(object);
 if (nameAddress == 0) return FALSE;
 /* Read one byte at a time so a string ending at a page boundary remains safe. */
 for (i = 0; i < sizeof(name) - 1; ++i) {
  if (!ReadProcessMemory(GetCurrentProcess(), (void *)(nameAddress + i),
      &name[i], 1, &bytes) || bytes != 1) return FALSE;
  if (name[i] == 0) break;
  if ((unsigned char)name[i] < 32 || (unsigned char)name[i] > 126) return FALSE;
 }
 if (i == sizeof(name) - 1 || strncmp(name, "object/", 7) != 0 ||
     strstr(name, ".iff") == NULL) return FALSE;
 EnterCriticalSection(&logLock);
 file = fopen(logPath, "a");
 if (file != NULL) {
  fprintf(file, "pid=%lu tid=%lu %s site=%08lx object=%p template=%s\n",
      GetCurrentProcessId(), GetCurrentThreadId(), kind, site, object, name);
  fclose(file);
 }
 LeaveCriticalSection(&logLock);
 return strcmp(name, "object/tangible/wearables/robe/shared_robe_s27.iff") == 0;
}

#else
static BOOL __attribute__((unused)) logObject(const char *kind, DWORD site, void *object) {
 (void)kind; (void)site; (void)object; return FALSE;
}
#endif

#if APPEARANCE_DIAGNOSTICS
static void observeWear(DWORD site, void *receiver, void *object) {
	LONG count = InterlockedIncrement(&wearCount);
	if (count <= 4096) {
		logEvent("wear-before", site, receiver, object, count);
		logObject("wear-template", site, object);
	}
	wear(receiver, object);
	if (count <= 4096)
		logEvent("wear-after", site, receiver, object, count);
}
#define WEAR_HOOK(name, site) \
static void __attribute__((thiscall)) name(void *receiver, void *object) { \
	observeWear(site, receiver, object); \
}
WEAR_HOOK(wear1, 0x4376d8)
WEAR_HOOK(wear2, 0x6474e1)
WEAR_HOOK(wear3, 0x67a0c1)
WEAR_HOOK(wear4, 0x6ff10d)

#endif

static void __attribute__((stdcall, used, noinline)) observeColor(void *receiver,
 const DWORD *color, void *object) {
 DWORD cyan = 0xff00ffff;
 BOOL cosmetic;
#if APPEARANCE_DIAGNOSTICS
 logObject("inventory-template", 0x9d71fd, object);
#endif
 ULONGLONG id = objectID(object);
 EnterCriticalSection(&logLock);
 cosmetic = FALSE;
 for (unsigned i = 0; id != 0 && i < appearanceTargetCount; ++i) {
  if (id == appearanceTargets[i].source) { cosmetic = TRUE; break; }
 }
 LeaveCriticalSection(&logLock);
#if APPEARANCE_DIAGNOSTICS
 if (InterlockedIncrement(&colorCount) <= 8192)
  logEvent("equipped-color", 0x9d71fd, receiver, (void *)color, *color);
#endif
 if (cosmetic) {
#if APPEARANCE_DIAGNOSTICS
  logEvent("appearance-color", 0x9d71fd, receiver, object, cyan);
#endif
  setColor(receiver, &cyan);
 } else {
  setColor(receiver, color);
 }
}

/* This exact call site's caller keeps the item at EBP-0x34. */
static void __attribute__((naked)) colorHook(void) {
 __asm__ volatile(
  "pushl -0x34(%ebp)\n\t"
  "pushl 8(%esp)\n\t"
  "pushl %ecx\n\t"
  "calll _observeColor@12\n\t"
  "retl $4\n\t");
}

static void __attribute__((thiscall)) containmentHook(void *object,
 const ULONGLONG *destination, int arrangement) {
 ULONGLONG id = objectID(object), parent = 0;
 ULONGLONG affectedParents[MAX_VOLUME_SOURCES];
 unsigned affectedCount = 0;
 SIZE_T bytes;
#if APPEARANCE_DIAGNOSTICS
 FILE *file;
#endif
 if (arrangement == 0x7fff0105 || arrangement == 0x7fff0107) {
  if (id == 0 || !ReadProcessMemory(GetCurrentProcess(), destination,
      &parent, sizeof(parent), &bytes) || bytes != sizeof(parent) || parent == 0) return;
  setContainerVisibility(id, parent, arrangement == 0x7fff0107);
  return;
 }
 if (arrangement >= 0x7fff0100 && arrangement <= 0x7fff0104) {
  if (id == 0 || !ReadProcessMemory(GetCurrentProcess(), destination,
      &parent, sizeof(parent), &bytes) || bytes != sizeof(parent)) return;
  EnterCriticalSection(&logLock);
  if (arrangement == 0x7fff0100) {
   clearAppearanceState();
   if (!visualTransaction) { volumeSourceCount = volumeTargetCount = 0; }
  }
  else if (arrangement == 0x7fff0103) visualTransaction = TRUE;
  else if (arrangement == 0x7fff0104) {
   for (unsigned i = 0; i < volumeSourceCount; ++i) {
    unsigned j;
    for (j = 0; j < affectedCount; ++j) if (affectedParents[j] == volumeSources[i].parent) break;
    if (j == affectedCount) affectedParents[affectedCount++] = volumeSources[i].parent;
   }
   finishVisualTransaction();
  }
  else if (arrangement == 0x7fff0101) {
   unsigned v;
   for (v = 0; v < volumeSourceCount; ++v) if (volumeSources[v].id == id) break;
   if (visualTransaction && (v < volumeSourceCount || v < MAX_VOLUME_SOURCES)) {
    volumeSources[v].id = id; volumeSources[v].parent = parent;
    if (v == volumeSourceCount) ++volumeSourceCount;
   }
   pendingAppearanceSource = 0;
   for (unsigned i = 0; i < appearanceSourceCount; ++i) {
    if (appearanceSources[i] == id) { pendingAppearanceSource = id; break; }
   }
   if (pendingAppearanceSource == 0 && appearanceSourceCount < MAX_APPEARANCE_SOURCES) {
    appearanceSources[appearanceSourceCount++] = id;
    pendingAppearanceSource = id;
   }
  } else if (pendingAppearanceSource != 0 && parent != 0 && id != pendingAppearanceSource) {
   unsigned v;
   for (v = 0; v < volumeTargetCount; ++v) if (volumeTargets[v] == id) break;
   if (visualTransaction && v == volumeTargetCount && v < MAX_VOLUME_TARGETS) volumeTargets[volumeTargetCount++] = id;
   unsigned i;
   for (i = 0; i < appearanceTargetCount; ++i) {
    if (appearanceTargets[i].target == id) break;
   }
   if (i < appearanceTargetCount) {
    /* Never reassign an existing target to a conflicting source. */
    if (appearanceTargets[i].source == pendingAppearanceSource) appearanceTargets[i].owner = parent;
   } else if (appearanceTargetCount < MAX_APPEARANCE_TARGETS) {
    appearanceTargets[i].target = id;
    appearanceTargets[i].owner = parent;
    appearanceTargets[i].source = pendingAppearanceSource;
    ++appearanceTargetCount;
   }
  }
  LeaveCriticalSection(&logLock);
  /* Recompute after pruning: a moved/removed source must stop charging its old bag. */
  for (unsigned i = 0; i < affectedCount; ++i) {
   void *owner = lookupObject(&affectedParents[i]);
   void *container = owner != NULL ? volumeContainer(owner) : NULL;
   if (container != NULL) recalculateContainer(container);
  }
#if APPEARANCE_DIAGNOSTICS
  logEvent("appearance-state-marker", 0x51c022, object, (void *)destination, arrangement);
#endif
  return;
 }
#if APPEARANCE_DIAGNOSTICS
 if (InterlockedIncrement(&containmentCount) <= 4096 && object != NULL &&
     ReadProcessMemory(GetCurrentProcess(), (BYTE *)object + 0x20,
         &id, sizeof(id), &bytes) && bytes == sizeof(id) &&
     ReadProcessMemory(GetCurrentProcess(), destination, &parent,
         sizeof(parent), &bytes) && bytes == sizeof(parent)) {
  logEvent("containment", 0x51c022, object, (void *)destination, arrangement);
  EnterCriticalSection(&logLock);
  file = fopen(logPath, "a");
  if (file != NULL) {
   fprintf(file, "pid=%lu tid=%lu containment-ids object=%p id=%llu parent=%llu arrangement=%d\n",
       GetCurrentProcessId(), GetCurrentThreadId(), object, id, parent, arrangement);
   fclose(file);
  }
  LeaveCriticalSection(&logLock);
  logObject("containment-template", 0x51c022, object);
 }
#endif
 applyContainment(object, destination, arrangement);
}

static BOOL executableMatches(void) {
	static const BYTE expected[32] = {
		0xe7,0x82,0xbf,0x1c,0x49,0xb3,0xda,0x73,
		0x0f,0x66,0xb5,0x4b,0xc5,0x58,0x94,0x7c,
		0x46,0x49,0x3f,0x71,0x33,0xf6,0x72,0xee,
		0xd1,0xd8,0xe0,0xc5,0x6a,0x6b,0x61,0x50
	};
	WCHAR path[MAX_PATH];
	HANDLE file = INVALID_HANDLE_VALUE;
	BCRYPT_ALG_HANDLE algorithm = NULL;
	BCRYPT_HASH_HANDLE hash = NULL;
	BYTE buffer[16384], digest[32];
	DWORD read, length;
	BOOL success = FALSE;
	length = GetModuleFileNameW(NULL, path, MAX_PATH);
	if (length == 0 || length >= MAX_PATH) goto done;
	file = CreateFileW(path, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE |
		FILE_SHARE_DELETE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (file == INVALID_HANDLE_VALUE) goto done;
	if (BCryptOpenAlgorithmProvider(&algorithm, BCRYPT_SHA256_ALGORITHM,
		NULL, 0) < 0) goto done;
	if (BCryptCreateHash(algorithm, &hash, NULL, 0, NULL, 0, 0) < 0) goto done;
	for (;;) {
		if (!ReadFile(file, buffer, sizeof(buffer), &read, NULL)) goto done;
		if (read == 0) break;
		if (BCryptHashData(hash, buffer, read, 0) < 0) goto done;
	}
	if (BCryptFinishHash(hash, digest, sizeof(digest), 0) < 0) goto done;
	success = memcmp(digest, expected, sizeof(digest)) == 0;
done:
	if (hash != NULL) BCryptDestroyHash(hash);
	if (algorithm != NULL) BCryptCloseAlgorithmProvider(algorithm, 0);
	if (file != INVALID_HANDLE_VALUE) CloseHandle(file);
	return success;
}

static void installProbe(void) {
	struct Hook { DWORD rva; BYTE bytes[7]; void *target; unsigned int length; };
	struct Hook hooks[] = {
#if APPEARANCE_DIAGNOSTICS
		{0x376d8, {0xe8,0x73,0x23,0x39,0x00}, (void *)wear1, 5},
		{0x2474e1, {0xe8,0x6a,0x25,0x18,0x00}, (void *)wear2, 5},
		{0x27a0c1, {0xe8,0x8a,0xf9,0x14,0x00}, (void *)wear3, 5},
		{0x2ff10d, {0xe8,0x3e,0xa9,0x0c,0x00}, (void *)wear4, 5},
#endif
		{0x5d71fd, {0xe8,0x4e,0x58,0x73,0x00}, (void *)colorHook, 5},
		{0x11c022, {0xe8,0xf9,0x8f,0x03,0x00}, (void *)containmentHook, 5},
		{0x5d7169, {0xe8,0x02,0xe0,0xc7,0xff}, (void *)inventoryParentHook, 5},
		{0x3cae5e, {0xe8,0x5d,0xff,0xff,0xff}, (void *)containerMeshHook, 5},
		{0x741de1, {0xe8,0xea,0xfd,0xff,0xff}, (void *)accountedVolume, 5},
		{0x742349, {0xe8,0x82,0xf8,0xff,0xff}, (void *)accountedVolume, 5},
		{0x741ee9, {0xe8,0xe2,0xfc,0xff,0xff}, (void *)accountedVolume, 5},
		{0x7421ca, {0xe8,0x01,0xfa,0xff,0xff}, (void *)recalcItemHook, 5},
		{0x74220d, {0x8b,0x45,0xec,0x57,0x89,0x47,0x20}, (void *)recalcSumHook, 7}
	};
	BYTE *base = (BYTE *)GetModuleHandleW(NULL);
	IMAGE_DOS_HEADER *dos = (IMAGE_DOS_HEADER *)base;
	IMAGE_NT_HEADERS *nt;
	DWORD protection[13], unused, displacement;
	unsigned int i, protectedCount = 0;
	const unsigned int hookCount = sizeof(hooks) / sizeof(hooks[0]);
	if (installed) return;
	installed = TRUE;
	if (!executableMatches() || dos->e_magic != IMAGE_DOS_SIGNATURE) goto rejected;
	nt = (IMAGE_NT_HEADERS *)(base + dos->e_lfanew);
	if (nt->Signature != IMAGE_NT_SIGNATURE ||
		nt->FileHeader.Machine != IMAGE_FILE_MACHINE_I386 ||
		nt->FileHeader.TimeDateStamp != 0x425ed458 ||
		nt->OptionalHeader.SizeOfImage != 0x15c0000) goto rejected;
	for (i = 0; i < hookCount; ++i)
		if (memcmp(base + hooks[i].rva, hooks[i].bytes, hooks[i].length) != 0) goto rejected;
	/* Obtain all write permissions before changing any call. */
	for (i = 0; i < hookCount; ++i) {
		if (!VirtualProtect(base + hooks[i].rva, hooks[i].length, PAGE_EXECUTE_READWRITE,
			&protection[i])) goto restore;
		++protectedCount;
	}
#if APPEARANCE_DIAGNOSTICS
	wear = (WearFunction)(base + 0x3c9a50);
#endif
	volumeProperty = (VolumePropertyFunction)(base + 0x723ee0);
	originalVolume = (VolumeFunction)(base + 0x741bd0);
	recalculateContainer = (VolumeFunction)(base + 0x742060);
	volumeContainer = (VolumeContainerFunction)(base + 0x2550a0);
	setColor = (ColorFunction)(base + 0xd0ca50);
#if APPEARANCE_DIAGNOSTICS
	templateName = (NameFunction)(base + 0x723c40);
#endif
	applyContainment = (ContainmentFunction)(base + 0x155020);
 actualParent = (ParentFunction)(base + 0x255170);
 lookupObject = (LookupFunction)(base + 0x7380e0);
	collectMesh = (CollectMeshFunction)(base + 0x3cadc0);
	dirtyMesh = (DirtyMeshFunction)(base + 0x3cb440);
	for (i = 0; i < hookCount; ++i) {
		displacement = (DWORD)((BYTE *)hooks[i].target - (base + hooks[i].rva + 5));
		base[hooks[i].rva] = 0xe8;
		memcpy(base + hooks[i].rva + 1, &displacement, 4);
		for (unsigned int j = 5; j < hooks[i].length; ++j) base[hooks[i].rva + j] = 0x90;
		FlushInstructionCache(GetCurrentProcess(), base + hooks[i].rva, hooks[i].length);
	}
	for (i = 0; i < hookCount; ++i)
		VirtualProtect(base + hooks[i].rva, hooks[i].length, protection[i], &unused);
	logEvent("appearance-installed", 0, base, NULL, 1);
	return;
restore:
	for (i = 0; i < protectedCount; ++i)
		VirtualProtect(base + hooks[i].rva, hooks[i].length, protection[i], &unused);
rejected:
	logEvent("appearance-rejected", 0, base, NULL, 0);
}

static BOOL loadBase(void) {
	WCHAR path[MAX_PATH], *separator;
	DWORD length;
	if (baseProxy != NULL)
		return create9 != NULL && beginEvent != NULL && endEvent != NULL && marker != NULL;
	length = GetModuleFileNameW(module, path, MAX_PATH);
	if (length == 0 || length >= MAX_PATH) return FALSE;
	separator = path + length;
	while (separator > path && separator[-1] != L'\\' && separator[-1] != L'/')
		--separator;
	if (separator - path + 26 >= MAX_PATH) return FALSE;
	lstrcpyW(separator, L"d3d9-appearance-base.dll");
	baseProxy = LoadLibraryW(path);
	if (baseProxy == NULL) return FALSE;
	create9 = (CreateFunction)GetProcAddress(baseProxy, "Direct3DCreate9");
	beginEvent = (BeginFunction)GetProcAddress(baseProxy, "D3DPERF_BeginEvent");
	endEvent = (EndFunction)GetProcAddress(baseProxy, "D3DPERF_EndEvent");
	marker = (MarkerFunction)GetProcAddress(baseProxy, "D3DPERF_SetMarker");
	return create9 != NULL && beginEvent != NULL && endEvent != NULL && marker != NULL;
}

IDirect3D9 *WINAPI Direct3DCreate9(UINT version) {
	if (!loadBase()) return NULL;
	installProbe();
	return create9(version);
}
int WINAPI D3DPERF_BeginEvent(DWORD color, LPCWSTR name) {
	return loadBase() ? beginEvent(color, name) : -1;
}
int WINAPI D3DPERF_EndEvent(void) { return loadBase() ? endEvent() : -1; }
void WINAPI D3DPERF_SetMarker(DWORD color, LPCWSTR name) {
	if (loadBase()) marker(color, name);
}
BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID reserved) {
	DWORD length;
	char *separator;
	(void)reserved;
	if (reason == DLL_PROCESS_ATTACH) {
		module = instance;
		DisableThreadLibraryCalls(instance);
		InitializeCriticalSection(&logLock);
		length = GetModuleFileNameA(instance, logPath, MAX_PATH);
		if (length == 0 || length >= MAX_PATH) return FALSE;
		separator = logPath + length;
		while (separator > logPath && separator[-1] != '\\' && separator[-1] != '/')
			--separator;
		if (separator - logPath + 24 >= MAX_PATH) return FALSE;
		strcpy(separator, "appearance-client.log");
	}
	return TRUE;
}
