import QtQuick
import Quickshell
import qs.launcher
import qs.services

ListView {
    id: listRoot

    property string searchQuery: ""
    property point lastMouseScenePos: Qt.point(-1, -1) // replaces ignoreHover
    property bool searchBarKeyboardFocus: false

    clip: true
    spacing: 8
    currentIndex: -1
    highlightMoveDuration: 0
    onSearchQueryChanged: {
        searchBarKeyboardFocus = false;
        currentIndex = 0;
    }
    Keys.onUpPressed: (event) => {
        if (currentIndex <= 0) {
            currentIndex = -1;
            searchBarKeyboardFocus = true; // hand focus back to search bar
        } else {
            currentIndex--;
        }
        event.accepted = true;
    }
    Keys.onDownPressed: (event) => {
        searchBarKeyboardFocus = false; // leaving search bar
        if (count > 0) {
            if (currentIndex >= count - 1)
                currentIndex = 0;
            else
                currentIndex++;
        }
        event.accepted = true;
    }
    Keys.onReturnPressed: {
        if (currentIndex >= 0 && currentItem) {
            currentItem.entry.execute();
            LauncherState.isOpen = false;
        }
    }
    interactive: false

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onWheel: (wheel) => {
            const itemSize = 48 + 8;
            listRoot.contentY = Math.max(0, Math.min(listRoot.contentHeight - listRoot.height, listRoot.contentY - (wheel.angleDelta.y / 120) * itemSize * 3));
            wheel.accepted = true;
        }
        onPressed: (mouse) => {
            return mouse.accepted = false;
        }
    }

    model: ScriptModel {
        values: {
            let apps = DesktopEntries.applications.values;
            if (searchQuery.length === 0)
                return apps;

            let query = searchQuery.toLowerCase();
            return apps.filter((app) => {
                return app.name.toLowerCase().includes(query) || (app.genericName && app.genericName.toLowerCase().includes(query));
            });
        }
    }

    delegate: Entry {
        required property var modelData

        name: modelData.name
        icon: modelData.icon
        entry: modelData
    }

}
