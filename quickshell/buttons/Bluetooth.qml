// buttons/Bluetooth.qml
import QtQuick
import Quickshell
import qs.config
import qs.menus
import qs.services

Rectangle {
    id: btBtn

    implicitWidth: 28
    implicitHeight: 28
    radius: Config.radius
    color: btArea.containsMouse ? Config.accent : Config.highlight

    Text {
        id: btLabel

        anchors.centerIn: parent
        color: btArea.containsMouse ? Config.bgDark : Config.foreground
        font.pixelSize: 16
        font.family: Config.font
        text: {
            if (!BluetoothAdapter.available)
                return "󰂲";

            if (!BluetoothAdapter.powered)
                return "󰂲";

            if (BluetoothAdapter.connected)
                return "󰂱";

            return "󰂯";
        }
    }

    MouseArea {
        id: btArea

        anchors.fill: btBtn
        hoverEnabled: true
        onClicked: btPopup.toggle()
    }

    Menu {
        id: btPopup

        anchorItem: btBtn

        Column {
            spacing: 0

            // Row 1: header + power toggle
            Item {
                width: 250
                height: 28

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Bluetooth"
                    color: Config.foreground
                    font.bold: true
                    font.pixelSize: Config.fontSize
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: powerBtnText.implicitWidth + 10
                    implicitHeight: powerBtnText.implicitHeight + 4
                    radius: Config.radius
                    color: powerBtnArea.containsMouse ? Config.accent : "transparent"

                    Text {
                        id: powerBtnText

                        anchors.centerIn: parent
                        text: BluetoothAdapter.powered ? "On" : "Off"
                        color: powerBtnArea.containsMouse ? Config.bgDark : Config.accent
                        font.pixelSize: Config.fontSize
                    }

                    MouseArea {
                        id: powerBtnArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: BluetoothAdapter.togglePower()
                    }

                }

            }

            // Row 2: no adapter warning (conditional height)
            Item {
                width: 250
                height: !BluetoothAdapter.available ? 24 : 0
                visible: !BluetoothAdapter.available

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "No adapter found"
                    color: "red"
                    font.pixelSize: Config.fontSize
                }

            }

            // Divider (only when powered)
            Item {
                width: 250
                height: BluetoothAdapter.powered ? 16 : 0
                visible: BluetoothAdapter.powered

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Config.foreground
                    opacity: 0.3
                }

            }

            // Row 3: device list (only when powered)
            ListView {
                width: 250
                implicitHeight: BluetoothAdapter.powered ? Math.min(contentHeight, 300) : 0
                height: implicitHeight
                visible: BluetoothAdapter.powered
                clip: true
                model: BluetoothAdapter.devices
                spacing: 4

                delegate: Item {
                    width: 250
                    height: 24

                    Text {
                        id: deviceName

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: deviceAction.left
                        anchors.rightMargin: 8
                        text: modelData.name || modelData.address
                        color: Config.foreground
                        font.pixelSize: Config.fontSize
                        elide: Text.ElideRight
                    }

                    Text {
                        id: deviceAction

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.connected ? "Disconnect" : "Connect"
                        color: modelData.connected ? Config.accent : Config.foreground
                        opacity: 0.8
                        font.pixelSize: Config.fontSize

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                        }

                    }

                }

            }

            // Divider above footer (only when powered)
            Item {
                width: 250
                height: BluetoothAdapter.powered ? 16 : 0
                visible: BluetoothAdapter.powered

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Config.foreground
                    opacity: 0.3
                }

            }

            // Row 4: scan + settings footer (only when powered)
            Item {
                width: 250
                height: BluetoothAdapter.powered ? 24 : 0
                visible: BluetoothAdapter.powered

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: BluetoothAdapter.isScanning ? "Stop Scan" : "Scan"
                    color: Config.foreground
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: BluetoothAdapter.toggleDiscovery()
                    }

                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Settings"
                    color: Config.foreground
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            btPopup.toggle();
                            BluetoothAdapter.openSettings();
                        }
                    }

                }

            }

        }

    }

}
