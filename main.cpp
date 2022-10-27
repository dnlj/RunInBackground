#include <Windows.h>

#if DEBUG
#include <iostream>
#endif


int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow) {
#if DEBUG
	if (AllocConsole()) {
		FILE* unused;
		freopen_s(&unused, "CONIN$", "r", stdin);
		freopen_s(&unused, "CONOUT$", "w", stdout);
		freopen_s(&unused, "CONOUT$", "w", stderr);

		if (auto console = GetStdHandle(STD_OUTPUT_HANDLE);
			!console || !SetConsoleMode(console, ENABLE_PROCESSED_OUTPUT | ENABLE_VIRTUAL_TERMINAL_PROCESSING)) {
			puts("Unable to set console mode.\n");
		}
	}
#endif

	STARTUPINFO si = {};
	PROCESS_INFORMATION pi = {};

	// TODO: look into CreateProcessAsUser
	// TODO: look into CreateProcessWithLogonW
	// See: https://learn.microsoft.com/en-us/windows/win32/procthread/creating-processes
	CreateProcess(
		NULL, // lpApplicationName
		pCmdLine, // lpCommandLine
		NULL, // lpProcessAttributes
		NULL, // lpThreadAttributes
		false, // bInheritHandles
		CREATE_NO_WINDOW, // dwCreationFlags
		NULL, // lpEnvironment
		NULL, // lpCurrentDirectory
		&si, // lpStartupInfo
		&pi  // lpProcessInformation
	);
	
	// Wait until child process exits.
	WaitForSingleObject(pi.hProcess, INFINITE);
	
	// Close process and thread handles. 
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);

	return 0;
}
