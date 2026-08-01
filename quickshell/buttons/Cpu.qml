// buttons/Cpu.qml
import QtQuick
import Quickshell
import qs.config
import qs.menus
import qs.services

Rectangle {
    id: cpuBtn

    implicitWidth: cpuText.implicitWidth + 12
    implicitHeight: 28
    radius: Config.radius
    color: cpuArea.containsMouse ? Config.accent : Config.highlight

    Text {
        id: cpuText

        anchors.centerIn: parent
        color: cpuArea.containsMouse ? Config.bgDark : Config.foreground
        text: CpuService.usageStr
        font.pixelSize: Config.fontSize
        font.family: Config.font
    }

    MouseArea {
        id: cpuArea

        hoverEnabled: true
        anchors.fill: parent
        onClicked: cpuPopup.toggle()
    }

}
