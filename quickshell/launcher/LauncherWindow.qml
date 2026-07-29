import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

Rectangle {
    id: root

    required property bool windowVisible

    width: 500
    height: 500
    color: Config.background
    border.color: Config.foreground
    border.width: 1
    radius: 14

    anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
        topMargin: 64
    }

    MouseArea {
        anchors.fill: parent
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Search {
            id: searchBar

            Layout.fillWidth: true
            windowVisible: root.windowVisible
            navigationTarget: appList
        }

        List {
            id: appList

            Layout.fillWidth: true
            Layout.fillHeight: true
            searchQuery: searchBar.text
        }

    }

}
