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


Repeater {
                        model: 32

                        // Fixed container delegate managed by the Row
                        delegate: Item {
                            required property int index
                            readonly property real value: Cava.leftBars.length > index ? Cava.leftBars[index] : 0

                            width: 3
                            height: 32 // Matches launcherButton height

                            // Inner visual bar (NOT managed by Row, so anchors are 100% valid)
                            Rectangle {
                                width: parent.width
                                height: Math.max(0, parent.value * 28)
                                radius: 1
                                color: Config.foreground
                                anchors.centerIn: parent

                                Behavior on height {
                                    NumberAnimation {
                                        duration: 80
                                        easing.type: Easing.OutCubic
                                    }

                                }

                            }

                        }

                    }

                    Rectangle {
                        id: launcherButton

                        z: 10
                        width: 32
                        height: 32
                        color: launcherMouseArea.containsMouse ? Config.accent : Config.bgDark
                        radius: Config.radius

                        Text {
                            anchors.centerIn: parent
                            text: "〇"
                            font.bold: true
                            color: launcherMouseArea.containsMouse ? Config.bgDark : Config.foreground
                        }

                        MouseArea {
                            id: launcherMouseArea

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                LauncherState.toggle();
                            }
                        }

                    }

                    Repeater {
                        model: 32

                        delegate: Item {
                            required property int index
                            readonly property real value: Cava.rightBars.length > index ? Cava.rightBars[index] : 0

                            width: 3
                            height: 32

                            Rectangle {
                                width: parent.width
                                height: Math.max(0, parent.value * 28)
                                radius: 1
                                color: Config.foreground
                                anchors.centerIn: parent

                                Behavior on height {
                                    NumberAnimation {
                                        duration: 80
                                        easing.type: Easing.OutCubic
                                    }

                                }

                            }

                        }

                    }