import QtQuick 2.15
import QtQuick.Controls 2.15

RoundButton {
    property alias searchButton: searchButton

    id: searchButton
    flat: true

    height: searchToolBar.height
    width: height

    icon.source: "../../../resources/search.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: {
        if (!searchLineEdit.searchInput.text) {
            searchLineEdit.searchInput.focus = true
        }
        else {
            genSearchData(true)
        }
    }
}