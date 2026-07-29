// buttons/Network.qml
import QtQuick
import Quickshell
import qs.config
import qs.popup
import qs.services

Rectangle {
    id: netBtn

    implicitWidth: netIcon.implicitWidth + 12
    implicitHeight: 28
    radius: Config.radius
    color: netArea.containsMouse ? Config.accent : Config.bgDark

    Text {
        id: netIcon

        anchors.centerIn: parent
        color: netArea.containsMouse ? Config.bgDark : Config.foreground
        font.pixelSize: 16
        text: {
            if (NetworkAdapter.isWired)
                return "󰈁";

            if (NetworkAdapter.isWifi) {
                const s = NetworkAdapter.signalPercent;
                if (s >= 75)
                    return "󰤨";

                if (s >= 50)
                    return "󰤥";

                if (s >= 25)
                    return "󰤢";

                return "󰤟";
            }
            return "󰤭";
        }
    }

    MouseArea {
        id: netArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: netPopup.toggle()
    }

    Popup {
        id: netPopup

        anchorItem: netBtn

        Column {
            spacing: 0

            // Row 1: status header
            Item {
                width: 250
                height: 28

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: NetworkAdapter.isWired ? "Wired" : NetworkAdapter.isWifi ? NetworkAdapter.activeSsid : "Disconnected"
                    color: Config.foreground
                    font.bold: true
                    font.pixelSize: Config.fontSize
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: NetworkAdapter.isWifi ? NetworkAdapter.signalPercent + "%" : NetworkAdapter.isWired ? "Ethernet" : ""
                    color: Config.accent
                    font.pixelSize: Config.fontSize
                }

            }

            // Row 2: connectivity hint
            Item {
                width: 250
                height: 20

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: NetworkAdapter.isWired ? "Connected via ethernet" : NetworkAdapter.isWifi ? "󰌾 " + NetworkAdapter.activeSsid : "No connection"
                    color: "gray"
                    font.pixelSize: Config.fontSize - 1
                }

            }

            // Divider
            Item {
                width: 250
                height: 16

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Config.foreground
                    opacity: 0.3
                }

            }

            // Network list (when scanning)
            ListView {
                width: 250
                height: NetworkAdapter.isScanning ? Math.min(contentHeight, 200) : 0
                visible: NetworkAdapter.isScanning
                clip: true
                model: NetworkAdapter.availableNetworks
                spacing: 2

                delegate: Item {
                    width: 250
                    height: 28

                    Text {
                        id: netName

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: netAction.left
                        anchors.rightMargin: 8
                        text: (modelData.known ? "󰌾 " : "") + modelData.name
                        color: modelData.connected ? Config.accent : Config.foreground
                        font.pixelSize: Config.fontSize
                        elide: Text.ElideRight
                    }

                    Text {
                        id: netAction

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.stateChanging ? "..." : modelData.connected ? "Disconnect" : "Connect"
                        color: modelData.connected ? "gray" : Config.accent
                        font.pixelSize: Config.fontSize - 1

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: !modelData.stateChanging
                            onClicked: {
                                if (modelData.connected)
                                    NetworkAdapter.disconnectNetwork(modelData);
                                else
                                    NetworkAdapter.connectNetwork(modelData);
                            }
                        }

                    }

                }

            }

            // Divider above footer
            Item {
                width: 250
                height: 16

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Config.foreground
                    opacity: 0.3
                }

            }

            // Footer: scan toggle + wifi toggle
            Item {
                width: 250
                height: 24

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: NetworkAdapter.isScanning ? "Stop Scan" : "Scan"
                    color: Config.foreground
                    font.pixelSize: Config.fontSize
                    visible: NetworkAdapter.wifiEnabled

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NetworkAdapter.toggleScan()
                    }

                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: NetworkAdapter.wifiEnabled ? "WiFi Off" : "WiFi On"
                    color: NetworkAdapter.wifiEnabled ? "gray" : Config.accent
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NetworkAdapter.toggleWifi()
                    }

                }

            }

        }

    }

}
