import QtQuick
import Quickshell.Services.UPower
pragma Singleton

QtObject {
    id: batteryService

    property var _device: UPower.displayDevice
    property bool isPresent: _device !== null && _device.ready && _device.isLaptopBattery
    property int percentage: isPresent ? Math.round(_device.percentage * 100) : 0
    property bool isCharging: isPresent && _device.state === UPowerDeviceState.Charging
    property string icon: {
        if (isCharging)
            return String.fromCodePoint(983172);

        if (percentage >= 100)
            return String.fromCodePoint(983161);

        if (percentage < 10)
            return String.fromCodePoint(983171);

        return String.fromCodePoint(983162 + (Math.floor(percentage / 10) - 1));
    }
}
