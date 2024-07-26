package com.zebra.plugins.barcode;

public enum ScannerStatus {
    /// Scanner is ready to be triggered
    WAITING,

    /// Scanner is emitting a scanner beam
    SCANNING,

    /// Scanner is in one of the following states: enabled but not yet in the waiting state,
    /// in the suspended state by an intent (e.g. SUSPEND_PLUGIN) or disabled due to the hardware trigger
    IDLE,

    /// Scanner is disabled
    DISABLED,

    /// An external (Bluetooth or serial) scanner is connected
    CONNECTED,

    /// The external scanner is disconnected
    DISCONNECTED;

    public static ScannerStatus parse(String value) {
        try {
            return ScannerStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException | NullPointerException e) {
            return ScannerStatus.DISABLED;
        }
    }

    public boolean isConnected() {
        return !(this == DISABLED || this == DISCONNECTED);
    }
}
