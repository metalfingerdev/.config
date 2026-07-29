import QtQuick
import qs.config
import qs.launcher
import qs.services

Rectangle {
    // remove: property bool mouseActivated: false

    required property bool windowVisible
    property alias text: searchInput.text
    property var navigationTarget: null
    property bool clickActivated: false
    readonly property bool isActive: text.length > 0 || hoverHandler.hovered || (navigationTarget !== null && navigationTarget.searchBarKeyboardFocus)

    onWindowVisibleChanged: {
        if (!windowVisible)
            clickActivated = false;

    }
    // ADD THIS BLOCK: Wipe the click memory when you hover off an empty bar
    onIsActiveChanged: {
        if (!isActive)
            clickActivated = false;

    }
    implicitHeight: 48
    color: isActive ? Config.bgLight : "transparent"
    radius: 8

    HoverHandler {
        id: hoverHandler

        onHoveredChanged: {
            if (hovered && navigationTarget)
                navigationTarget.currentIndex = -1;

        }
    }

    TapHandler {
        onTapped: mouseActivated = true
    }

    Rectangle {
        height: 1
        color: isActive ? Config.accent : Config.foreground

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

    }

    Text {
        id: searchIcon

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: "\uf002"
        font.family: Config.font
        font.pixelSize: Config.fontSize
        color: Config.foreground
        opacity: 1
    }

    TextInput {
        id: searchInput

        anchors.left: searchIcon.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.rightMargin: 12
        verticalAlignment: TextInput.AlignVCenter
        font.family: Config.font
        font.pixelSize: 18
        font.italic: activeFocus
        color: Config.foreground
        focus: windowVisible
        Keys.forwardTo: navigationTarget ? [navigationTarget] : []
        onVisibleChanged: {
            if (!visible)
                text = "";

        }
        Keys.onEscapePressed: {
            LauncherState.isOpen = false;
        }

        Text {
            text: "Search | 검색 | Поиск | Sök"
            font.family: Config.font
            font.pixelSize: 18
            color: Config.foreground
            opacity: 0.4
            visible: searchInput.text.length === 0
            anchors.verticalCenter: parent.verticalCenter
        }

        cursorDelegate: Rectangle {
            visible: isActive && (clickActivated || searchInput.text.length > 0)
            color: Config.foreground
            width: 1

            // Adds the classic instant-snap cursor blink
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: true

                PauseAnimation {
                    duration: 500
                }

                PropertyAction {
                    value: 0
                }

                PauseAnimation {
                    duration: 500
                }

                PropertyAction {
                    value: 1
                }

            }

        }

    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: (mouse) => {
            clickActivated = true;
            mouse.accepted = false;
        }
    }

}
