/*++

Copyright (c) Microsoft Corporation.

Abstract:

    Sample empty driver

--*/

#include <wdm.h>
#include <wdf.h>

#define INITCODE __declspec(code_seg("INIT"))
#define PAGEDX __declspec(code_seg("PAGE"))

INITCODE DRIVER_INITIALIZE DriverEntry;
PAGEDX EVT_WDF_DRIVER_UNLOAD EvtDriverUnload;

INITCODE
_Function_class_(DRIVER_INITIALIZE)
_IRQL_requires_same_
_IRQL_requires_(PASSIVE_LEVEL)
NTSTATUS
DriverEntry(
    _In_ PDRIVER_OBJECT DriverObject,
    _In_ PUNICODE_STRING RegistryPath
    )
{
    WDF_DRIVER_CONFIG Config;
    WDF_DRIVER_CONFIG_INIT(&Config, NULL);
    Config.EvtDriverUnload = EvtDriverUnload;
    Config.DriverInitFlags = WdfDriverInitNonPnpDriver;
    Config.DriverPoolTag = ' gaT'; // TODO - Real pool tag

    WDFDRIVER Driver;
    NTSTATUS Status =
        WdfDriverCreate(
            DriverObject,
            RegistryPath,
            WDF_NO_OBJECT_ATTRIBUTES,
            &Config,
            &Driver);
    if (!NT_SUCCESS(Status)) {
        goto Error;
    }

Error:

    return Status;
}

PAGEDX
_Function_class_(EVT_WDF_DRIVER_UNLOAD)
_IRQL_requires_same_
_IRQL_requires_max_(PASSIVE_LEVEL)
void
EvtDriverUnload(
    _In_ WDFDRIVER Driver
    )
{
    UNREFERENCED_PARAMETER(Driver);
    PAGED_CODE();
}
