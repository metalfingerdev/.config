// services/CpuService.qml
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    readonly property string usageStr: "   " + (_usage < 10 ? "0" + _usage : _usage) + "%"
    readonly property int usage: _usage
    property int _usage: 0
    property int _lastIdle: 0
    property int _lastTotal: 0

    Process {
        id: cpuProc

        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: (data) => {
                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1, 8).reduce((a, b) => {
                    return a + parseInt(b);
                }, 0);
                if (root._lastTotal > 0)
                    root._usage = Math.round(100 * (1 - (idle - root._lastIdle) / (total - root._lastTotal)));

                root._lastIdle = idle;
                root._lastTotal = total;
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }

}
