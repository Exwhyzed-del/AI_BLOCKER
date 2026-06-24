#include <ntddk.h>
#include <wdf.h>

NTSTATUS DriverEntry(_In_ PDRIVER_OBJECT DriverObject, _In_ PUNICODE_STRING RegistryPath) {
    NTSTATUS status;
    WDF_DRIVER_CONFIG config;
    WDF_OBJECT_ATTRIBUTES attributes;

    KdPrint(("AI Blocker Driver: DriverEntry called\n"));

    WDF_DRIVER_CONFIG_INIT(&config, WDF_NO_EVENT_CALLBACK);

    WDF_OBJECT_ATTRIBUTES_INIT(&attributes);

    status = WdfDriverCreate(DriverObject, RegistryPath, &attributes, &config, WDF_NO_HANDLE);
    if (!NT_SUCCESS(status)) {
        KdPrint(("AI Blocker Driver: WdfDriverCreate failed: 0x%08X\n", status));
        return status;
    }

    return status;
}
