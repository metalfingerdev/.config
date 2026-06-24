import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import ".."

RowLayout {
    spacing: 6

    Process {
        id: batCap
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                batText.text = this.text.trim() + "%"
            }
        }
    }

    Process {
        id: batStatus
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let state = this.text.trim()
                batIcon.text = state === "Charging" ? "🔌" : "🔋"
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            batCap.running = true
            batStatus.running = true
        }
    }

    Text { 
        id: batIcon 
        color: Config.colors.text
        font.pixelSize: Config.settings.bar.fontSize
    }
    Text { 
        id: batText 
        color: Config.colors.text 
        font.pixelSize: Config.settings.bar.fontSize
        font.family: fontMonaco.name
    }
}