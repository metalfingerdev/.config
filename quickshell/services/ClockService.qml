// services/ClockService.qml
import QtQuick
import Quickshell
pragma Singleton

Singleton {
    id: root

    readonly property string timeStr: Qt.formatDateTime(clock.date, "ddd HH:mm")
    readonly property date currentDate: clock.date

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

}
