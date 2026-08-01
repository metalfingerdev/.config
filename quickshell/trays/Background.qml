import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.config

Repeater {
    id: sysTrayLayout

    property var parentWindow: {
        let p = parent;
        while (p && !(p instanceof PanelWindow))p = p.parent
        return p;
    }

    // Just like Hyprland.workspaces, SystemTray.items is an ObjectModel.
    // We use .values to get the reactive Javascript array of SystemTrayItems.
    model: SystemTray.items

    delegate: Rectangle {
        id: trayItemRect

        // modelData is the SystemTrayItem object itself
        required property var modelData

        width: 28
        height: 28
        radius: Config.radius
        color: Config.highlight

        IconImage {
            anchors.centerIn: parent
            implicitSize: 20
            asynchronous: true
            source: modelData.icon ?? ""
        }

        QsMenuAnchor {
            id: menuAnchor

            menu: modelData.menu
            anchor.window: parentWindow
            anchor.item: trayItemRect
            anchor.edges: Edges.Bottom
        }

        MouseArea {
            // Triggers the app's native right-click menu.
            // NOTE: You MUST replace 'myPanelWindowId' with the id of your root PanelWindow.

            id: trayMouseArea

            anchors.fill: parent
            hoverEnabled: true
            // Changes the mouse cursor to a pointing hand on hover
            cursorShape: Qt.PointingHandCursor
            // Allow left, middle, and right clicks
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: (ev) => {
                if (ev.button === Qt.LeftButton) {
                    // Some tray apps only have a menu and no left-click action
                    if (modelData.onlyMenu)
                        menuAnchor.open();
                    else
                        modelData.activate();
                } else if (ev.button === Qt.RightButton) {
                    if (modelData.hasMenu)
                        menuAnchor.open();
                    else
                        modelData.secondaryActivate();
                } else {
                    // Middle click
                    modelData.secondaryActivate();
                }
            }
            onWheel: (ev) => {
                // Smoothly handles both vertical and horizontal scroll wheels
                const delta = ev.angleDelta.y !== 0 ? ev.angleDelta.y : ev.angleDelta.x;
                modelData.scroll(delta, ev.angleDelta.y === 0);
            }
        }

    }

}
