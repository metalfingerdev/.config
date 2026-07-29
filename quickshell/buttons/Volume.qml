// buttons/Volume.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import qs.config
import qs.popup
import qs.services

Rectangle {
    id: volBtn

    implicitWidth: volIcon.implicitWidth + 12
    implicitHeight: 28
    radius: Config.radius
    color: volArea.containsMouse ? Config.accent : Config.bgDark

    Text {
        id: volIcon

        anchors.centerIn: parent
        color: volArea.containsMouse ? Config.bgDark : Config.foreground
        font.pixelSize: 16
        text: {
            if (Pipewire.muted)
                return "󰝟";

            const v = Pipewire.volume;
            if (v == 0)
                return "󰝟";

            if (v < 0.3)
                return "󰕿";

            if (v < 0.6)
                return "󰖀";

            return "󰕾";
        }
    }

    MouseArea {
        id: volArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: volPopup.toggle()
    }

    Popup {
        id: volPopup

        anchorItem: volBtn

        Column {
            spacing: 0

            // Row 1: label + mute button
            Item {
                width: 250
                height: 24

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Volume"
                    color: Config.foreground
                    font.bold: true
                    font.pixelSize: Config.fontSize
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: muteBtnText.implicitWidth + 10
                    implicitHeight: muteBtnText.implicitHeight + 4
                    radius: Config.radius
                    color: muteBtnArea.containsMouse ? (Pipewire.muted ? Config.danger : Config.accent) : "transparent"

                    Text {
                        id: muteBtnText

                        anchors.centerIn: parent
                        text: Pipewire.muted ? "Unmute" : "Mute"
                        color: muteBtnArea.containsMouse ? Config.bgDark : (Pipewire.muted ? Config.danger : Config.accent)
                        font.pixelSize: Config.fontSize
                    }

                    MouseArea {
                        id: muteBtnArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Pipewire.toggleMute()
                    }

                }

            }

            // Gap
            Item {
                width: 250
                height: 8
            }

            // Row 2: percentage + slider
            Item {
                width: 250
                height: 24

                Text {
                    id: volPct

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 35
                    horizontalAlignment: Text.AlignRight
                    color: Pipewire.muted ? "gray" : Config.foreground
                    font.pixelSize: Config.fontSize
                    text: Math.round(Pipewire.volume * 100) + "%"
                }

                Slider {
                    anchors.left: volPct.right
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    from: 0
                    to: 1
                    value: Pipewire.volume
                    onMoved: Pipewire.setVolume(value)
                }

            }

        }

    }

}
