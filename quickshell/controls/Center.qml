// controls/ControlCenter.qml

import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

ColumnLayout {
    id: root

    // Local placeholders for services that don't exist yet
    property real brightness: 0.7
    property bool dndEnabled: false
    property bool airplaneEnabled: false

    // REMOVE anchors.fill: parent
    implicitWidth: parent ? parent.width : 384
    // Give it a fallback width
    anchors.margins: 12
    spacing: 12

    // ---------- Status row: battery + cpu ----------
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Text {
            visible: UPower.isPresent
            text: UPower.icon + "  " + UPower.percentage + "%"
            font.family: Config.font
            font.pixelSize: Config.fontSize
            color: UPower.isCharging ? Config.accent : Config.foreground
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: "CPU " + CpuService.usageStr.trim()
            font.family: Config.font
            font.pixelSize: Config.fontSize - 2
            color: Config.foreground
            opacity: 0.7
        }

    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Config.foreground
        opacity: 0.2
    }

    // ---------- Toggle grid (2x2, iOS-style tiles) ----------
    GridLayout {
        Layout.fillWidth: true
        columns: 2
        rowSpacing: 10
        columnSpacing: 10

        ToggleTile {
            label: "Wi-Fi"
            sublabel: NetworkAdapter.wifiEnabled ? (NetworkAdapter.activeSsid !== "" ? NetworkAdapter.activeSsid : "On") : "Off"
            active: NetworkAdapter.wifiEnabled
            onToggled: NetworkAdapter.toggleWifi
        }

        ToggleTile {
            label: "Bluetooth"
            sublabel: !BluetoothAdapter.available ? "Unavailable" : BluetoothAdapter.connected ? BluetoothAdapter.connectedDevices[0].name ?? "Connected" : (BluetoothAdapter.powered ? "On" : "Off")
            active: BluetoothAdapter.powered
            onToggled: BluetoothAdapter.togglePower
        }

        // Placeholder - no DND service yet
        ToggleTile {
            label: "Do Not Disturb"
            sublabel: root.dndEnabled ? "On" : "Off"
            active: root.dndEnabled
            onToggled: function() {
                root.dndEnabled = !root.dndEnabled;
            }
        }

        // Placeholder - no airplane mode service yet
        ToggleTile {
            label: "Airplane Mode"
            sublabel: root.airplaneEnabled ? "On" : "Off"
            active: root.airplaneEnabled
            onToggled: function() {
                root.airplaneEnabled = !root.airplaneEnabled;
            }
        }

        // Reusable tile
        component ToggleTile: Rectangle {
            id: tile

            required property string label
            required property string sublabel
            required property bool active
            property var onToggled: function() {
            }

            Layout.fillWidth: true
            Layout.preferredHeight: 64
            radius: Config.radius
            color: active ? Config.accent : Config.bgDark
            border.width: 1
            border.color: Config.foreground

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 2

                Text {
                    text: tile.label
                    font.family: Config.font
                    font.pixelSize: Config.fontSize
                    font.bold: true
                    color: tile.active ? Config.bgDark : Config.foreground
                }

                Text {
                    text: tile.sublabel
                    font.family: Config.font
                    font.pixelSize: Config.fontSize - 3
                    color: tile.active ? Config.bgDark : Config.foreground
                    opacity: 0.75
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: tile.onToggled()
            }

        }

    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Config.foreground
        opacity: 0.2
    }

    SliderRow {
        label: "Volume" + (Pipewire.muted ? " (Muted)" : "")
        value: Pipewire.volume
        onMoved: function(v) {
            Pipewire.setVolume(v);
        }

        MouseArea {
            // dedicated mute toggle lives below instead, kept slider drag-only

            anchors.right: parent.right
            anchors.top: parent.top
            width: 0
            height: 0
        }

    }

    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: -6

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: Pipewire.muted ? "Unmute" : "Mute"
            font.family: Config.font
            font.pixelSize: Config.fontSize - 3
            color: Config.foreground
            opacity: 0.6

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Pipewire.toggleMute()
            }

        }

    }

    // Placeholder - no brightness service yet, drives a local property only
    SliderRow {
        label: "Brightness"
        value: root.brightness
        onMoved: function(v) {
            root.brightness = v;
        }
    }

    Item {
        Layout.fillHeight: true
    }

    // ---------- Sliders ----------
    component SliderRow: ColumnLayout {
        required property string label
        required property real value
        property var onMoved: function(v) {
        }

        Layout.fillWidth: true
        spacing: 4

        Text {
            text: label
            font.family: Config.font
            font.pixelSize: Config.fontSize - 2
            color: Config.foreground
            opacity: 0.7
        }

        Rectangle {
            id: track

            Layout.fillWidth: true
            height: 22
            radius: height / 2
            color: Config.bgDark
            border.width: 1
            border.color: Config.foreground

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.max(0, Math.min(1, value))
                radius: height / 2
                color: Config.accent
            }

            MouseArea {
                anchors.fill: parent
                onPositionChanged: (mouse) => {
                    if (pressed)
                        onMoved(Math.max(0, Math.min(1, mouse.x / width)));

                }
                onPressed: (mouse) => {
                    onMoved(Math.max(0, Math.min(1, mouse.x / width)));
                }
            }

        }

    }

}
