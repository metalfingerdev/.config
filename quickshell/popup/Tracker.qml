import QtQuick
// bar/PopupTracker.qml
pragma Singleton

QtObject {
    property var active: null // use var, not bool — you're storing an object
}
