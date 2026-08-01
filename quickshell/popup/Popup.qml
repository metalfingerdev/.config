import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.config
import qs.services

PanelWindow {
    id: root

    property int notifWidth: 360
    property int margin: 12
    property int maxHeight: (screen ? screen.height : 1080) - 80
    property int maxVisible: 5

    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notification-popup"
    implicitWidth: notifWidth
    implicitHeight: Math.min(list.contentHeight, maxHeight)

    ListModel {
        id: popupModel
    }

    Connections {
        function onAdded(notification) {
            popupModel.insert(0, {
                "notifId": notification.id,
                "appIcon": notification.appIcon,
                "summary": notification.summary,
                "body": notification.body,
                "image": notification.image,
                "urgency": notification.urgency,
                "timeout": NotificationServer.timeoutFor(notification)
            });
            while (popupModel.count > root.maxVisible)popupModel.remove(popupModel.count - 1)
        }

        function onRemoved(notifId) {
            for (let i = 0; i < popupModel.count; i++) {
                if (popupModel.get(i).notifId === notifId) {
                    popupModel.remove(i);
                    break;
                }
            }
        }

        target: NotificationServer
    }

    anchors {
        top: true
        right: true
    }

    margins {
        top: margin
        right: margin
    }

    ListView {
        id: list

        anchors.fill: parent
        model: popupModel
        spacing: 10
        interactive: contentHeight > root.maxHeight
        clip: true

        add: Transition {
            NumberAnimation {
                properties: "opacity"
                from: 0
                to: 1
                duration: 180
            }

            NumberAnimation {
                properties: "x"
                from: root.notifWidth
                to: 0
                duration: 180
                easing.type: Easing.OutCubic
            }

        }

        remove: Transition {
            NumberAnimation {
                properties: "opacity"
                to: 0
                duration: 150
            }

            NumberAnimation {
                properties: "x"
                to: root.notifWidth
                duration: 150
                easing.type: Easing.InCubic
            }

        }

        displaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: 180
                easing.type: Easing.OutCubic
            }

        }

        delegate: Rectangle {
            id: card

            width: list.width
            height: contentCol.implicitHeight + 48
            radius: 10
            color: Config.background
            border.width: 2
            border.color: Config.foreground

            Timer {
                id: hideTimer

                interval: timeout
                running: timeout > 0
                onTriggered: {
                    for (let i = 0; i < popupModel.count; i++) {
                        if (popupModel.get(i).notifId === notifId) {
                            popupModel.remove(i);
                            break;
                        }
                    }
                }
            }
            // Changed from Layout to anchors

            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                radius: 6
                color: urgency === 2 ? Config.danger : urgency === 0 ? Config.warning : Config.highlight

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        NotificationServer.activate(notifId);
                        NotificationServer.dismiss(notifId);
                    }
                }

                RowLayout {
                    id: contentCol

                    anchors.fill: parent
                    anchors.margins: 12
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
                            color: urgency === 2 ? Config.bgDark : urgency === 0 ? Config.bgDark : Config.foreground
                            font.bold: true
                            font.pixelSize: 14
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Text {
                            text: body
                            color: urgency === 2 ? Config.bgDark : urgency === 0 ? Config.bgDark : Config.foreground
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }

                    }

                }

            }

        }

    }

}
