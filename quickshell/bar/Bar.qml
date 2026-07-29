// bar/Bar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.buttons
import qs.config
import qs.launcher
import qs.popup
import qs.services
import qs.trays

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root

            property bool cpuDropdownOpen: false
            property bool clockDropdownOpen: false

            WlrLayershell.namespace: "quickshell:widgets"
            implicitHeight: Config.top
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                id: bar

                color: Config.background
                radius: Config.radius

                anchors {
                    fill: parent
                    topMargin: Config.margin
                    bottomMargin: Config.bottom
                    leftMargin: Config.sides
                    rightMargin: Config.sides
                }

                border {
                    width: 1
                    color: Config.foreground
                }

                RowLayout {
                    id: leftSection

                    spacing: Config.spacing
                    anchors.left: parent.left
                    anchors.leftMargin: Config.margin
                    anchors.verticalCenter: parent.verticalCenter

                    Workspaces {
                    }

                    Background {
                    }

                    Apps {
                        screen: root.screen
                    }

                    Cpu {
                    }

                }

                // --- CENTER SECTION ---
                Menu {
                }

                RowLayout {
                    id: rightSection

                    spacing: Config.spacing
                    anchors.right: parent.right
                    anchors.rightMargin: Config.margin
                    anchors.verticalCenter: parent.verticalCenter

                    Volume {
                    }

                    Network {
                    }

                    Bluetooth {
                    }

                    Power {
                    }

                    Clock {
                    }

                    Notifications {
                    }

                }

            }

        }

    }

}
