import QtQuick 2.15
import QtQuick.Controls 2.15

RoundButton {
    id: optionButton
    flat: true

    height: toolBar.height
    width: height

    icon.source: "../../../resources/more_vert.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: optionMenu.open()

    Menu {
        id: optionMenu
        MenuItem {
            id: menuReload
            text: qsTr("Reload")
        }
        MenuItem {
            id: menuAdvanced
            text: qsTr("Advanced search")

            onTriggered: advancedSearch.open()
        }
        background: Rectangle {
            implicitWidth: menuAdvanced.width
            color: surfaceColor2
        }
    }
}