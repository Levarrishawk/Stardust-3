#define WIN32_LEAN_AND_MEAN
#define COBJMACROS
#include <windows.h>
#include <d3d9.h>
#include <stdio.h>
#include <stdlib.h>

typedef IDirect3D9 *(WINAPI *Direct3DCreate9Function)(UINT);

static LRESULT CALLBACK windowProcedure(HWND window, UINT message,
	WPARAM wparam, LPARAM lparam) {
	return DefWindowProcA(window, message, wparam, lparam);
}

static unsigned char *readFile(const char *path, DWORD *size) {
	HANDLE file = CreateFileA(path, GENERIC_READ, FILE_SHARE_READ, NULL,
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	unsigned char *data;
	DWORD readSize;
	if (file == INVALID_HANDLE_VALUE)
		return NULL;
	*size = GetFileSize(file, NULL);
	data = (unsigned char *)malloc(*size);
	if (data == NULL || !ReadFile(file, data, *size, &readSize, NULL) ||
		readSize != *size) {
		free(data);
		data = NULL;
	}
	CloseHandle(file);
	return data;
}

int main(int argc, char **argv) {
	WNDCLASSA windowClass = {0};
	D3DPRESENT_PARAMETERS parameters = {0};
	HMODULE d3d9Module;
	Direct3DCreate9Function createDirect3D;
	IDirect3D9 *direct3D;
	IDirect3DDevice9 *device = NULL;
	HWND window;
	HRESULT result;
	int index;

	if (argc < 2) {
		fprintf(stderr, "usage: d3d9_shader_validate shader.bin [...]\n");
		return 2;
	}
	d3d9Module = LoadLibraryA("d3d9.dll");
	createDirect3D = d3d9Module != NULL ? (Direct3DCreate9Function)
		GetProcAddress(d3d9Module, "Direct3DCreate9") : NULL;
	if (createDirect3D == NULL) {
		fprintf(stderr, "Direct3DCreate9 unavailable\n");
		return 3;
	}
	windowClass.lpfnWndProc = windowProcedure;
	windowClass.hInstance = GetModuleHandleA(NULL);
	windowClass.lpszClassName = "StardustShaderValidator";
	RegisterClassA(&windowClass);
	window = CreateWindowA(windowClass.lpszClassName, "", WS_POPUP,
		0, 0, 16, 16, NULL, NULL, windowClass.hInstance, NULL);
	direct3D = createDirect3D(D3D_SDK_VERSION);
	if (direct3D == NULL || window == NULL) {
		fprintf(stderr, "Direct3D initialization failed\n");
		return 4;
	}
	parameters.Windowed = TRUE;
	parameters.SwapEffect = D3DSWAPEFFECT_DISCARD;
	parameters.hDeviceWindow = window;
	result = IDirect3D9_CreateDevice(direct3D, D3DADAPTER_DEFAULT,
		D3DDEVTYPE_HAL, window, D3DCREATE_SOFTWARE_VERTEXPROCESSING,
		&parameters, &device);
	if (FAILED(result)) {
		fprintf(stderr, "CreateDevice failed: 0x%08lX\n", (DWORD)result);
		return 5;
	}
	for (index = 1; index < argc; ++index) {
		DWORD size = 0;
		unsigned char *data = readFile(argv[index], &size);
		IDirect3DPixelShader9 *shader = NULL;
		if (data == NULL) {
			printf("READ_FAIL %s\n", argv[index]);
			continue;
		}
		result = IDirect3DDevice9_CreatePixelShader(device,
			(const DWORD *)data, &shader);
		printf("0x%08lX %lu %s\n", (DWORD)result, size, argv[index]);
		if (shader != NULL)
			IDirect3DPixelShader9_Release(shader);
		free(data);
	}
	IDirect3DDevice9_Release(device);
	IDirect3D9_Release(direct3D);
	DestroyWindow(window);
	FreeLibrary(d3d9Module);
	return 0;
}
