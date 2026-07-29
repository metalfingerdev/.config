import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.popup

PopupWindow {
    id: root

    required property Item anchorItem
    default property alias content: container.data
    property int padding: 12

    function toggle() {
        if (root.visible) {
            root.visible = false;
            Tracker.active = null;
        } else {
            if (Tracker.active)
                Tracker.active.visible = false;

            Tracker.active = root;
            root.visible = true;
        }
    }

    grabFocus: true
    anchor.item: anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: Config.margin * 4
    visible: false
    color: "transparent"
    implicitWidth: container.childrenRect.width + padding * 2
    implicitHeight: container.childrenRect.height + padding * 2

    // Listen for Escape key pressed anywhere on this window
    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: {
            root.visible = false;
            Tracker.active = null;
        }
    }

    Rectangle {
        id: bg

        anchors.fill: parent
        color: Config.bgDark
        radius: Config.radius
        border.width: 1
        border.color: Config.foreground
    }

    Item {
        id: container

        x: padding
        y: padding
        width: childrenRect.width
        height: childrenRect.height
    }

}
