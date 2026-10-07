#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <bcrypt.h>
#include <d3d9.h>
#include <stdio.h>
#include <string.h>

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
typedef void *(__attribute__((cdecl)) *ParentFunction)(void *);
typedef void *(__attribute__((cdecl)) *LookupFunction)(const ULONGLONG *);
static ParentFunction actualParent;
static LookupFunction lookupObject;
static ULONGLONG objectID(void *object) {
 ULONGLONG id = 0; SIZE_T bytes;
 if (object == NULL || !ReadProcessMemory(GetCurrentProcess(),
     (BYTE *)object + 0x20, &id, sizeof(id), &bytes) || bytes != sizeof(id)) return 0;
 return id;
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
 SIZE_T bytes;
#if APPEARANCE_DIAGNOSTICS
 FILE *file;
#endif
 if (arrangement >= 0x7fff0100 && arrangement <= 0x7fff0102) {
  if (id == 0 || !ReadProcessMemory(GetCurrentProcess(), destination,
      &parent, sizeof(parent), &bytes) || bytes != sizeof(parent)) return;
  EnterCriticalSection(&logLock);
  if (arrangement == 0x7fff0100) clearAppearanceState();
  else if (arrangement == 0x7fff0101) {
   pendingAppearanceSource = 0;
   for (unsigned i = 0; i < appearanceSourceCount; ++i) {
    if (appearanceSources[i] == id) { pendingAppearanceSource = id; break; }
   }
   if (pendingAppearanceSource == 0 && appearanceSourceCount < MAX_APPEARANCE_SOURCES) {
    appearanceSources[appearanceSourceCount++] = id;
    pendingAppearanceSource = id;
   }
  } else if (pendingAppearanceSource != 0 && parent != 0 && id != pendingAppearanceSource) {
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
	struct Hook { DWORD rva; BYTE bytes[5]; void *target; };
	struct Hook hooks[] = {
#if APPEARANCE_DIAGNOSTICS
		{0x376d8, {0xe8,0x73,0x23,0x39,0x00}, (void *)wear1},
		{0x2474e1, {0xe8,0x6a,0x25,0x18,0x00}, (void *)wear2},
		{0x27a0c1, {0xe8,0x8a,0xf9,0x14,0x00}, (void *)wear3},
		{0x2ff10d, {0xe8,0x3e,0xa9,0x0c,0x00}, (void *)wear4},
#endif
		{0x5d71fd, {0xe8,0x4e,0x58,0x73,0x00}, (void *)colorHook},
		{0x11c022, {0xe8,0xf9,0x8f,0x03,0x00}, (void *)containmentHook},
		{0x5d7169, {0xe8,0x02,0xe0,0xc7,0xff}, (void *)inventoryParentHook}
	};
	BYTE *base = (BYTE *)GetModuleHandleW(NULL);
	IMAGE_DOS_HEADER *dos = (IMAGE_DOS_HEADER *)base;
	IMAGE_NT_HEADERS *nt;
	DWORD protection[7], unused, displacement;
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
		if (memcmp(base + hooks[i].rva, hooks[i].bytes, 5) != 0) goto rejected;
	/* Obtain all write permissions before changing any call. */
	for (i = 0; i < hookCount; ++i) {
		if (!VirtualProtect(base + hooks[i].rva, 5, PAGE_EXECUTE_READWRITE,
			&protection[i])) goto restore;
		++protectedCount;
	}
#if APPEARANCE_DIAGNOSTICS
	wear = (WearFunction)(base + 0x3c9a50);
#endif
	setColor = (ColorFunction)(base + 0xd0ca50);
#if APPEARANCE_DIAGNOSTICS
	templateName = (NameFunction)(base + 0x723c40);
#endif
	applyContainment = (ContainmentFunction)(base + 0x155020);
 actualParent = (ParentFunction)(base + 0x255170);
 lookupObject = (LookupFunction)(base + 0x7380e0);
	for (i = 0; i < hookCount; ++i) {
		displacement = (DWORD)((BYTE *)hooks[i].target - (base + hooks[i].rva + 5));
		memcpy(base + hooks[i].rva + 1, &displacement, 4);
		FlushInstructionCache(GetCurrentProcess(), base + hooks[i].rva, 5);
	}
	for (i = 0; i < hookCount; ++i)
		VirtualProtect(base + hooks[i].rva, 5, protection[i], &unused);
	logEvent("appearance-installed", 0, base, NULL, 1);
	return;
restore:
	for (i = 0; i < protectedCount; ++i)
		VirtualProtect(base + hooks[i].rva, 5, protection[i], &unused);
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
