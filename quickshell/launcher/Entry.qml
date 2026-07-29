import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.config
import qs.services

Rectangle {
    id: delegateRoot

    required property string name
    required property string icon
    required property int index
    required property var entry
    readonly property bool isCurrent: ListView.isCurrentItem

    width: ListView.view.width
    height: 48
    radius: 12
    color: isCurrent ? Config.bgLight : "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        spacing: 12

        IconImage {
            implicitSize: 32
            asynchronous: true
            source: Quickshell.iconPath(icon, "application-x-executable")
        }

        Text {
            text: name
            font.family: Config.font
            font.pixelSize: 16
            color: isCurrent ? Config.accent : Config.foreground
            Layout.fillWidth: true
        }

    }

    MouseArea {
        id: itemArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            entry.execute();
            LauncherState.isOpen = false;
        }
        // No onEntered — fires when UI scrolls under cursor, can't be trusted.
        // onPositionChanged only fires when the physical mouse moves in scene coords.
        onPositionChanged: (mouse) => {
            var list = delegateRoot.ListView.view;
            var scenePos = mapToGlobal(mouse.x, mouse.y);
            var last = list.lastMouseScenePos;
            if (Math.abs(scenePos.x - last.x) > 0.5 || Math.abs(scenePos.y - last.y) > 0.5) {
                list.lastMouseScenePos = scenePos;
                list.currentIndex = index;
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 120
        }

    }

}
