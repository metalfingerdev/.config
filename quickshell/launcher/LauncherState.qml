import QtQuick
pragma Singleton

QtObject {
    property bool isOpen: false

    function toggle() {
        isOpen = !isOpen;
    }

}
