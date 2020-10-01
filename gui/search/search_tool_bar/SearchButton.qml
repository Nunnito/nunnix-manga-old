import QtQuick 2.15
import QtQuick.Controls 2.15

// Search button
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

    // On clicked...
    onClicked: {
        // If there is text in input line...
        if (!searchLineEdit.searchInput.text) {
            searchLineEdit.searchInput.focus = true
        }
        // Else, reset filters and start new search.
        else {
            resetFilters()
            genSearchData(true)
        }
    }
}