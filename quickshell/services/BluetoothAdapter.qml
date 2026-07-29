// services/BluetoothAdapter.qml
import QtQuick
import Quickshell
import Quickshell.Bluetooth
pragma Singleton

QtObject {
    id: root

    readonly property Bluetooth manager: Bluetooth
    readonly property var defaultAdapter: manager.defaultAdapter
    readonly property bool available: defaultAdapter !== null
    readonly property bool powered: defaultAdapter ? !!defaultAdapter.enabled : false
    // --- NEW: Deterministic Scanning State Machine ---
    // Do NOT rely on defaultAdapter.discovering for the UI truth.
    // We treat scanning as a strict 12-second window.
    readonly property bool isScanning: scanTimer.running
    property Timer scanTimer

    scanTimer: Timer {
        interval: 12000 // 12 seconds is standard for BT discovery
        repeat: false
        onTriggered: {
            // Proactively tell BlueZ to stop before it drops the connection internally
            if (root.defaultAdapter && root.defaultAdapter.discovering)
                root.defaultAdapter.discovering = false;

        }
    }

    readonly property string adapterName: defaultAdapter ? defaultAdapter.name : ""
    readonly property string adapterId: defaultAdapter ? defaultAdapter.adapterId : ""
    readonly property bool discoverable: defaultAdapter ? !!defaultAdapter.discoverable : false
    readonly property bool pairable: defaultAdapter ? !!defaultAdapter.pairable : false
    readonly property var devices: manager.devices ? manager.devices.values : []
    readonly property bool connected: devices ? devices.some((d) => {
        return d.connected;
    }) : false
    readonly property var connectedDevices: devices ? devices.filter((d) => {
        return d.connected;
    }) : []

    function togglePower() {
        if (defaultAdapter)
            defaultAdapter.enabled = !defaultAdapter.enabled;

    }

    function setPowered(state) {
        if (defaultAdapter)
            defaultAdapter.enabled = state;

    }

    // --- NEW: Timer-Controlled Discovery ---
    function toggleDiscovery() {
        if (!defaultAdapter)
            return ;

        if (scanTimer.running) {
            // User clicked "Stop Scan" manually
            scanTimer.stop();
            defaultAdapter.discovering = false;
        } else {
            // User clicked "Scan"
            if (!defaultAdapter.enabled)
                defaultAdapter.enabled = true;

            // If the QML property is somehow stuck from a previous bad state, force it
            if (defaultAdapter.discovering)
                defaultAdapter.discovering = false;

            defaultAdapter.discovering = true;
            scanTimer.restart();
        }
    }

    function setDiscoverable(state) {
        if (defaultAdapter)
            defaultAdapter.discoverable = state;

    }

    function setPairable(state) {
        if (defaultAdapter)
            defaultAdapter.pairable = state;

    }

    function openSettings() {
        Quickshell.execDetached(["sh", "-c", "kitty --class bluetuith -- bluetuith"]);
    }

}
