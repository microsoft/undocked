/*++

Copyright (c) Microsoft Corporation.

Abstract:

    Sample empty library

--*/

#include <windows.h>

int
__stdcall
DllMain(
    _In_ HINSTANCE Instance,
    _In_ DWORD Reason,
    _In_ LPVOID Reserved
    )
{
    UNREFERENCED_PARAMETER(Reserved);
    switch (Reason) {
    case DLL_PROCESS_ATTACH:
#ifndef _MT // Don't disable thread library calls with static CRT!
        DisableThreadLibraryCalls(Instance);
#else
        UNREFERENCED_PARAMETER(Instance);
#endif
        break;
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}
