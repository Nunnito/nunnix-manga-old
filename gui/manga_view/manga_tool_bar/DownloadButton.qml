import QtQuick 2.15
import QtQuick.Controls 2.15

// Download button
RoundButton {
    property alias downloadButton: downloadButton

    id: downloadButton
    flat: true

    height: mangaToolBar.height
    width: height

    icon.source: "../../../resources/download-outlined.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize
}