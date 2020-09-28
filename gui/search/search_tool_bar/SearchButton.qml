import QtQuick 2.15
import QtQuick.Controls 2.15

RoundButton {
    flat: true

    height: toolBar.height
    width: height

    icon.source: "../../../resources/search.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: {
        if (!searchInput.text) {
            searchInput.focus = true
        }
    }
}