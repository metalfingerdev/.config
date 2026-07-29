// buttons/Cpu.qml
import QtQuick
import Quickshell
import qs.config
import qs.popup
import qs.services

Rectangle {
    id: cpuBtn

    implicitWidth: cpuText.implicitWidth + 12
    implicitHeight: 28
    radius: Config.radius
    color: cpuArea.containsMouse ? Config.accent : Config.bgDark

    Text {
        id: cpuText

        anchors.centerIn: parent
        color: cpuArea.containsMouse ? Config.bgDark : Config.foreground
        text: CpuService.usageStr
        font.pixelSize: Config.fontSize
    }

    MouseArea {
        id: cpuArea

        hoverEnabled: true
        anchors.fill: parent
        onClicked: cpuPopup.toggle()
    }

}
