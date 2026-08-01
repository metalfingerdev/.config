import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    implicitHeight: 40
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        id: pill

        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        height: 28
        // Width shrink-wraps the inner RowLayout + padding
        implicitWidth: row.implicitWidth + 24
        width: implicitWidth
        color: "#1e1e2e"
        radius: 14

        border {
            width: 1
            color: "#313244"
        }

        RowLayout {
            id: row

            anchors.centerIn: parent
            spacing: 10

            // --- Placeholder: Workspaces ---
            Repeater {
                model: [1, 2, 3]

                delegate: Rectangle {
                    required property int modelData

                    width: 18
                    height: 18
                    radius: 4
                    color: modelData === 1 ? "#cba6f7" : "transparent"

                    border {
                        width: 1
                        color: "#cba6f7"
                    }

                    Text {
                        anchors.centerIn: parent
                        text: parent.modelData
                        color: parent.modelData === 1 ? "#1e1e2e" : "#cba6f7"
                        font.pixelSize: 9
                    }

                }

            }

            // Divider
            Rectangle {
                width: 1
                height: 14
                color: "#313244"
            }

            // --- Placeholder: App name ---
            Text {
                text: "kitty"
                color: "#cdd6f4"
                font.pixelSize: 11
            }

            // Divider
            Rectangle {
                width: 1
                height: 14
                color: "#313244"
            }

            // --- Placeholder: Clock ---
            Text {
                text: Qt.formatTime(new Date(), "hh:mm")
                color: "#cdd6f4"
                font.pixelSize: 11

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm")
                }

            }

            // Divider
            Rectangle {
                width: 1
                height: 14
                color: "#313244"
            }

            // --- Placeholder: Volume ---
            Text {
                text: "󰕾  80%"
                color: "#cdd6f4"
                font.pixelSize: 11
            }

            // Divider
            Rectangle {
                width: 1
                height: 14
                color: "#313244"
            }

            // --- Placeholder: Battery ---
            Text {
                text: "󰁹  95%"
                color: "#a6e3a1"
                font.pixelSize: 11
            }

        }

        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }

        }

    }

    // Restrict input to only the pill
    mask: Region {
        x: pill.x
        y: pill.y
        width: pill.width
        height: pill.height
    }

}
