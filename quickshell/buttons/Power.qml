// buttons/Battery.qml
import QtQuick
import Quickshell
import qs.config
import qs.menus
import qs.services

Rectangle {
    id: pwrBtn

    implicitWidth: 28
    implicitHeight: 28
    radius: Config.radius
    color: pwrArea.containsMouse ? Config.accent : Config.highlight

    Text {
        id: batteryText

        anchors.centerIn: parent
        color: pwrArea.containsMouse ? Config.bgDark : Config.foreground
        font.pixelSize: 16
        text: UPower.isPresent ? UPower.icon : ""
        visible: UPower.isPresent
    }

    MouseArea {
        id: pwrArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: batteryPopup.toggle()
    }

    Menu {
        id: batteryPopup

        anchorItem: pwrBtn

        Column {
            spacing: 0

            // Row 1: icon + status on left, percentage on right
            Item {
                width: 250
                height: 28

                Text {
                    id: batteryIcon

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: UPower.icon
                    font.pixelSize: 16
                    color: {
                        if (!UPower.isPresent)
                            return "gray";

                        if (UPower.percentage < 10)
                            return "red";

                        if (UPower.isCharging)
                            return Config.accent;

                        return Config.foreground;
                    }
                }

                Text {
                    anchors.left: batteryIcon.right
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    font.pixelSize: Config.fontSize
                    font.family: Config.font
                    color: Config.foreground
                    text: {
                        if (!UPower.isPresent)
                            return "No battery";

                        if (UPower.isCharging)
                            return "Charging";

                        if (UPower.percentage < 10)
                            return "Critical";

                        return "On battery";
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Config.fontSize
                    text: UPower.isPresent ? UPower.percentage + "%" : "—"
                    color: {
                        if (UPower.percentage < 10)
                            return "red";

                        if (UPower.isCharging)
                            return Config.accent;

                        return Config.foreground;
                    }
                }

            }

            // Spacer
            Item {
                width: 250
                height: 10
            }

            // Row 2: progress bar
            Item {
                width: 250
                height: 6

                Rectangle {
                    anchors.fill: parent
                    radius: 3
                    color: Config.bgDark
                    border.width: 1
                    border.color: Config.foreground

                    Rectangle {
                        width: Math.max(radius * 2, parent.width * (UPower.percentage / 100))
                        height: parent.height
                        radius: parent.radius
                        color: {
                            if (UPower.percentage < 10)
                                return "red";

                            if (UPower.isCharging)
                                return Config.accent;

                            return Config.foreground;
                        }

                        Behavior on width {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutCubic
                            }

                        }

                    }

                }

            }

            // Spacer
            Item {
                width: 250
                height: 10
            }

            // Row 3: remaining hint
            Item {
                width: 250
                height: 20

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: UPower.percentage >= 100 ? "Fully charged" : UPower.percentage + "% remaining"
                    color: "gray"
                    font.pixelSize: Config.fontSize - 1
                }

            }

        }

    }

}
