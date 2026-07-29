// controls/Notifications.qml

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.services

ColumnLayout {
    // REMOVE anchors.fill: parent
    implicitWidth: parent ? parent.width : 384
    anchors.margins: 12
    spacing: 8

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: "Notifications"
            font.family: Config.font
            font.pixelSize: Config.fontSize + 2
            font.bold: true
            color: Config.foreground
            Layout.fillWidth: true
        }

        Text {
            visible: NotificationServer.list.count > 0
            text: "Clear all"
            font.family: Config.font
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
        Layout.fillWidth: true
        height: 1
        color: Config.foreground
        opacity: 0.2
    }

    Text {
        visible: NotificationServer.list.count === 0
        text: "No notifications"
        font.family: Config.font
        font.pixelSize: Config.fontSize
        color: Config.foreground
        opacity: 0.5
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 20
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 6
        model: NotificationServer.list

        delegate: Rectangle {
            required property var notifId
            required property var appName
            required property var summary
            required property var body
            required property var image

            width: ListView.view.width
            height: card.implicitHeight + 16
            radius: Config.radius
            color: Qt.rgba(1, 1, 1, 0.05)

            RowLayout {
                id: card

                anchors.fill: parent
                anchors.margins: 8
                spacing: 10

                Image {
                    visible: image !== ""
                    source: image
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    fillMode: Image.PreserveAspectFit
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: appName
                        font.family: Config.font
                        font.pixelSize: Config.fontSize - 3
                        color: Config.foreground
                        opacity: 0.6
                    }

                    Text {
                        text: summary
                        font.family: Config.font
                        font.pixelSize: Config.fontSize - 1
                        font.bold: true
                        color: Config.foreground
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        visible: body !== ""
                        text: body
                        font.family: Config.font
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
