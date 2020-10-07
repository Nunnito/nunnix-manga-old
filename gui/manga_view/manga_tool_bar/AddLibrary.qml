import QtQuick 2.15
import QtQuick.Controls 2.15

// Add to library button.
RoundButton {
    property alias addLibrary: addLibrary

    id: addLibrary
    flat: true

    height: mangaToolBar.height
    width: height

    icon.source: "../../../resources/bookmark_border.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize
}