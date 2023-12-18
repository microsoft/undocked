/*++

Copyright (c) Microsoft Corporation.

Abstract:

    Sample empty application

--*/

#include <windows.h>
#include <stdio.h>
#include "localmsg.h"

void PutMsgW(_In_ UINT MsgNumber, ...)
{
    LPWSTR vp;
    va_list arglist;
    va_start(arglist, MsgNumber);
    DWORD msglen =
        FormatMessageW(
            FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_HMODULE,
            NULL,
            MsgNumber,
            0L,
            (LPWSTR)&vp,
            0,
            &arglist);
    if (!msglen) {
        wprintf(vp);
        LocalFree(vp);
    }
}

void __cdecl wmain(_In_ int argc, _In_count_(argc) wchar_t **argv)
{
    UNREFERENCED_PARAMETER(argc);
    UNREFERENCED_PARAMETER(argv);
    PutMsgW(EXE_USAGE);
}
