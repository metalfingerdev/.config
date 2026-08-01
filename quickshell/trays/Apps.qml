import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.config
import qs.services

Repeater {
    id: root

    // Requires the screen to be passed in when the component is instantiated
    required property var screen
    // Calculates the correct monitor and workspaces based on the provided screen
    readonly property var monitor: Hyprland.monitorFor(screen)
    readonly property var activeWs: Hyprland.workspaces.values.find((ws) => {
        return ws.monitor === monitor && ws.active;
    }) ?? null
    readonly property var scratchpadWs: Hyprland.workspaces.values.find((ws) => {
        return ws.name === "special:minimized";
    }) ?? null
    // Combines active toplevels and minimized scratchpad toplevels into one array
    readonly property var visibleToplevels: {
        let tl = activeWs ? activeWs.toplevels.values.slice() : [];
        if (scratchpadWs && scratchpadWs !== activeWs)
            tl = tl.concat(scratchpadWs.toplevels.values);

        return tl;
    }

    model: visibleToplevels

    delegate: Rectangle {
        id: windowRect

        required property var modelData
        // Underlying Wayland Toplevel handle containing properties and methods
        readonly property var wayland: modelData.wayland

        width: 28
        height: 28
        // Integrate with your established styling
        radius: Config.radius
        color: Config.highlight

        IconImage {
            anchors.centerIn: parent
            // Scaled down slightly to fit cleanly inside the 28x28 box with margins
            implicitSize: 20
            asynchronous: true
            source: {
                if (!wayland)
                    return "";

                // Resolves the proper icon using the app's desktop entry
                const appId = wayland.appId;
                const entry = DesktopEntries.byId(appId);
                const iconName = entry ? entry.icon : appId;
                return Quickshell.iconPath(iconName, "application-x-executable");
            }
        }

        // Minimized indicator dot
        Rectangle {
            width: 4
            height: 4
            radius: 2
            // Adapt the indicator color so it remains visible when the background turns into the accent color
            color: windowMouseArea.containsMouse ? Config.bgDark : Qt.rgba(1, 1, 1, 0.5)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            // Only visible if the window is minimized
            visible: wayland ? wayland.minimized : false
        }

        MouseArea {
            id: windowMouseArea

            anchors.fill: parent
            hoverEnabled: true
            // Apply the pointing hand cursor
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (wayland)
                    wayland.activate();

            }
        }

    }

}
