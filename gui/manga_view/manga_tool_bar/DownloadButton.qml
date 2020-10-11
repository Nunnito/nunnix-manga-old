import QtQuick 2.15
import QtQuick.Controls 2.15

// Download button
RoundButton {
    property alias downloadButton: downloadButton
    property alias menu: menu
    property alias downloadAll: downloadAll
    property alias downloadUnread: downloadUnread

    id: downloadButton
    flat: true

    height: mangaToolBar.height
    width: height

    icon.source: "../../../resources/download-outlined.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: menu.open()

    Menu {
        id: menu

        MenuItem {
            id: downloadAll
            text: qsTr("All")

            onTriggered: mangaChapters.downloadChapters(false)
        }

        MenuItem {
            id: downloadUnread
            text: qsTr("Unread")

            onTriggered: mangaChapters.downloadChapters(true)
        }
    }
}