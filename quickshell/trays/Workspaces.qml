import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config

Repeater {
    id: wsRepeater

    // Dynamically calculate the array of workspace IDs to show
    model: {
        // 1 and 2 are always present
        let ids = [1, 2];
        let activeWorkspaces = Hyprland.workspaces.values;
        for (let i = 0; i < activeWorkspaces.length; i++) {
            let id = activeWorkspaces[i].id;
            // Add other active workspaces (ignoring negative IDs for named workspaces)
            if (id > 0 && !ids.includes(id))
                ids.push(id);

        }
        // Sort them numerically so the buttons appear in order
        return ids.sort((a, b) => {
            return a - b;
        });
    }

    Rectangle {
        id: wsButton

        // 'modelData' holds the actual ID from the array (e.g., 1, 2, 4...)
        property int wsId: modelData
        property var ws: Hyprland.workspaces.values.find((w) => {
            return w.id === wsId;
        })
        property bool isActive: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === wsId
        property bool hasWindows: wsButton.ws !== null && wsButton.ws !== undefined && wsButton.ws.toplevels.values.length > 0

        width: 28
        height: 28
        radius: Config.radius
        color: wsMouseArea.containsMouse ? Config.accent : Config.highlight

        Text {
            anchors.centerIn: parent
            text: wsId
            color: wsMouseArea.containsMouse ? Config.bgDark : (isActive ? Config.accent : (hasWindows ? Config.foreground : Config.muted))
            font.pixelSize: Config.fontSize
        }

        MouseArea {
            id: wsMouseArea

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (wsButton.ws)
                    wsButton.ws.activate();
                else
                    Hyprland.dispatch(`workspace ${wsId}`);
            }
        }

    }

}
