import QtQuick 2.15
import QtQuick.Controls 2.15

// Menu button.
RoundButton {
    property alias menuButton: menuButton
    property alias menu: menu
    property alias menuReload: menuReload
    property alias menuAdvanced: menuAdvanced

    id: menuButton
    flat: true

    height: searchToolBar.height
    width: height

    icon.source: "../../../resources/more_vert.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: menu.open()

    Menu {
        id: menu

        MenuItem {
            id: menuReload
            text: qsTr("Reload")

            onTriggered: genSearchData(true)
        }
        MenuItem {
            id: menuAdvanced
            text: qsTr("Advanced search")

            // Open advanced search menu
            onTriggered: advancedSearch.open()
        }
    }
}