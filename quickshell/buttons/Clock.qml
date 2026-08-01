// buttons/Clock.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.config
import qs.menus
import qs.services

Rectangle {
    id: clockBtn

    implicitWidth: clockText.implicitWidth + 12
    implicitHeight: 28
    radius: Config.radius
    color: clockArea.containsMouse ? Config.accent : Config.highlight

    Text {
        id: clockText

        anchors.centerIn: parent
        color: clockArea.containsMouse ? Config.bgDark : Config.foreground
        text: ClockService.timeStr
        font.pixelSize: Config.fontSize
        font.family: Config.font
    }

    MouseArea {
        id: clockArea

        anchors.fill: clockText
        hoverEnabled: true
        onClicked: clockPopup.toggle()
    }

    Menu {
        id: clockPopup

        anchorItem: clockBtn

        Column {
            spacing: 0

            // Row 1: full date
            Item {
                width: 220
                height: 28

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy")
                    color: Config.foreground
                    font.bold: true
                    font.pixelSize: Config.fontSize
                }

            }

            // Row 2: full time with seconds
            Item {
                width: 220
                height: 24

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatTime(new Date(), "hh:mm:ss")
                    color: Config.foreground
                    font.pixelSize: Config.fontSize
                }

                Timer {
                    interval: 1000
                    running: clockPopup.visible
                    repeat: true
                    onTriggered: parent.parent.visible = parent.parent.visible
                }

            }

            // Divider
            Item {
                width: 220
                height: 16

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Config.foreground
                    opacity: 0.3
                }

            }

            // Row 3: timezone
            Item {
                width: 220
                height: 24

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "UTC" + (new Date().getTimezoneOffset() <= 0 ? "+" : "-") + Math.abs(new Date().getTimezoneOffset() / 60)
                    color: "gray"
                    font.pixelSize: Config.fontSize - 1
                    font.family: Config.font
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDate(new Date(), "IST")
                    color: Config.foreground
                    font.pixelSize: Config.fontSize - 1
                    font.family: Config.font
                }

            }

        }

    }

}
