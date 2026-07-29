// buttons/Notifications.qml

import QtQuick
import Quickshell
import qs.config
import qs.dashboard
import qs.services

Rectangle {
    id: notifBtn

    implicitWidth: notifText.implicitWidth + 12
    implicitHeight: 28
    radius: Config.radius
    color: notifArea.containsMouse ? Config.accent : Config.bgDark

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
        onClicked: DashboardState.isOpen = !DashboardState.isOpen
    }

}
