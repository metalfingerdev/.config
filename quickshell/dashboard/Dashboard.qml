import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.controls
import qs.services

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData
            visible: DashboardState.isOpen
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            implicitWidth: 400
            WlrLayershell.namespace: "quickshell:widgets"

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: DashboardState.isOpen = false
            }

            Shortcut {
                sequence: "Escape"
                enabled: DashboardState.isOpen
                onActivated: DashboardState.isOpen = false
            }

            // The actual visible sidebar
            // Inside your PanelWindow...
            Rectangle {
                id: sidebar

                color: Config.bgDark
                border.color: Config.foreground
                border.width: 1
                radius: 8
                width: 392
                opacity: 1

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    topMargin: 0
                    bottomMargin: 0
                    rightMargin: 0
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    }
                }

                ColumnLayout {
                    anchors.fill: parent

                    Center {
                        // ControlCenter will take up only the height it needs based on its children

                        Layout.fillWidth: true
                    }

                    Notifications {
                        // Notifications will expand to fill the rest of the available sidebar height

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                }

            }

        }

    }

}
