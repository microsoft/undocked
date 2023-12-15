/*++

Copyright (c) Microsoft Corporation.

Abstract:

    Sample empty static library

--*/

#include <windows.h>

int
foo(
    _In_ int bar
    )
{
    UNREFERENCED_PARAMETER(bar);
    return 1;
}
