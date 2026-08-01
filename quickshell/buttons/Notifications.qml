// buttons/Notifications.qml

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.menus
import qs.services

Rectangle {
    id: notifBtn

    implicitWidth: 28
    implicitHeight: 28
    radius: Config.radius
    color: notifArea.containsMouse ? Config.accent : Config.highlight

    Text {
        id: notifText

        anchors.centerIn: parent
        color: notifArea.containsMouse ? Config.bgDark : Config.foreground
        text: NotificationServer.list.count > 0 ? NotificationServer.list.count : "\uf0f3"
        font.pixelSize: Config.fontSize
    }

    MouseArea {
        id: notifArea

        anchors.fill: notifText
        hoverEnabled: true
        onClicked: notifPopup.toggle()
    }

    Menu {
        id: notifPopup

        anchorItem: notifBtn

        Column {
            spacing: 8

            Row {
                width: 320
                spacing: 8

                Text {
                    text: "Notifications"
                    font.bold: true
                    font.pixelSize: Config.fontSize
                    font.family: Config.font
                    color: Config.foreground
                    width: parent.width - clearText.implicitWidth - parent.spacing
                }

                Text {
                    id: clearText

                    visible: NotificationServer.list.count > 0
                    text: "Clear all"
                    font.pixelSize: Config.fontSize - 2
                    color: Config.foreground
                    opacity: 0.7

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NotificationServer.clearAll()
                    }

                }

            }

            Rectangle {
                width: 320
                height: 1
                color: Config.foreground
                opacity: 0.2
            }

            Text {
                visible: NotificationServer.list.count === 0
                text: "No notifications"
                width: 320
                horizontalAlignment: Text.AlignHCenter
                color: Config.foreground
                opacity: 0.5
                topPadding: 20
                bottomPadding: 20
            }

            ListView {
                width: 320
                height: Math.min(contentHeight, 400)
                visible: NotificationServer.list.count > 0
                clip: true
                spacing: 6
                model: NotificationServer.list

                delegate: Rectangle {
                    id: card

                    required property var notifId
                    required property var appIcon
                    required property var summary
                    required property var body
                    required property var image
                    required property var urgency

                    width: ListView.view.width
                    height: contentRow.implicitHeight + 16
                    radius: Config.radius
                    color: Qt.rgba(1, 1, 1, 0.05)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            NotificationServer.activate(notifId);
                            NotificationServer.dismiss(notifId);
                        }
                    }

                    RowLayout {
                        id: contentRow

                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        Image {
                            source: image !== "" ? image : NotificationServer.resolveIcon(appIcon)
                            visible: source !== ""
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            fillMode: Image.PreserveAspectFit
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: summary
                                font.bold: true
                                font.pixelSize: Config.fontSize - 1
                                color: Config.foreground
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: body !== ""
                                text: body
                                font.pixelSize: Config.fontSize - 2
                                color: Config.foreground
                                opacity: 0.85
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }

                        }

                        Text {
                            text: "\u2715"
                            font.pixelSize: Config.fontSize - 2
                            color: Config.foreground
                            opacity: 0.6

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: NotificationServer.dismiss(notifId)
                            }

                        }

                    }

                }

            }

        }

    }

}
