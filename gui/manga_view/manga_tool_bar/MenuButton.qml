import QtQuick 2.15
import QtQuick.Controls 2.15

// Menu button.
RoundButton {
    property alias menuButton: menuButton
    property alias menu: menu
    property alias menuCopyLink: menuCopyLink

    id: menuButton
    flat: true

    height: mangaToolBar.height
    width: height

    icon.source: "../../../resources/more_vert.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: menu.open()

    Menu {
        id: menu

        MenuItem {
            id: menuCopyLink
            text: qsTr("Copy manga link")

            onTriggered: copy(mangaLink)
        }

        // Menu background
        background: Rectangle {
            implicitWidth: menuCopyLink.width
            color: surfaceColor2
        }
    }
}