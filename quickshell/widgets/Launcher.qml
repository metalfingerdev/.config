import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.launcher


PanelWindow {
    id: launcherWindow

    focusable: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    visible: LauncherState.isOpen
    WlrLayershell.namespace: "quickshell:widgets"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: LauncherState.isOpen = false
    }

    LauncherWindow {
        windowVisible: launcherWindow.visible
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            LauncherState.toggle()
        }
    }

}
