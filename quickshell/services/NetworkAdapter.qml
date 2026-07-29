import QtQuick
import Quickshell
import Quickshell.Networking
pragma Singleton

Singleton {
    id: root

    // --- Devices ---
    readonly property var wifiDevice: {
        const devs = Networking.devices.values;
        for (const d of devs) {
            if (d.type === DeviceType.Wifi)
                return d;

        }
        return null;
    }
    readonly property var wiredDevice: {
        const devs = Networking.devices.values;
        for (const d of devs) {
            if (d.type === DeviceType.Wired && d.connected)
                return d;

        }
        return null;
    }
    // --- State ---
    readonly property bool isWired: wiredDevice !== null
    readonly property bool isWifi: !isWired && activeNetwork !== null
    readonly property bool connected: isWired || isWifi
    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property var connectivity: Networking.connectivity
    // --- Active network ---
    readonly property var activeNetwork: {
        if (!wifiDevice)
            return null;

        const nets = wifiDevice.networks.values;
        for (const n of nets) {
            if (n.connected)
                return n;

        }
        return null;
    }
    readonly property real signalStrength: activeNetwork ? activeNetwork.signalStrength : 0
    readonly property int signalPercent: Math.round(signalStrength * 100)
    readonly property string activeSsid: activeNetwork ? activeNetwork.name : ""
    readonly property var activeSecurity: activeNetwork ? activeNetwork.security : WifiSecurityType.None
    // --- Available networks (when scanning) ---
    readonly property bool isScanning: wifiDevice ? wifiDevice.scannerEnabled : false
    readonly property var availableNetworks: {
        if (!wifiDevice)
            return [];

        return wifiDevice.networks.values.slice().sort((a, b) => {
            return b.signalStrength - a.signalStrength;
        });
    }

    // --- Actions ---
    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    function toggleScan() {
        if (wifiDevice)
            wifiDevice.scannerEnabled = !wifiDevice.scannerEnabled;

    }

    function connectNetwork(network) {
        network.connect();
    }

    function connectNetworkWithPsk(network, psk) {
        network.connectWithPsk(psk);
    }

    function disconnectNetwork(network) {
        network.disconnect();
    }

    function forgetNetwork(network) {
        network.forget();
    }

}
