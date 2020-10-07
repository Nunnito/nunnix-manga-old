import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Rectangle {
    // Search toolbar alias.
    property alias searchToolBar: searchToolBar
    property alias searchLineEdit: searchLineEdit
    property alias searchButton: searchButton
    property alias menuButton: menuButton

    property alias row: row
    property alias searchArea: searchArea

    id: searchToolBar
    z: 1

    width: parent.width
    height: toolbarHeight
    color: surfaceColor

    // Row.
    Row {
        id: row

        width: parent.width
        layoutDirection: Qt.RightToLeft

        MenuButton {id: menuButton}          // Menu button.
        SearchButton {id: searchButton}      // Serch button.
        SearchLineEdit {id: searchLineEdit}  // Input line.
    }


	MouseArea {
        id: searchArea

		anchors.fill: parent
		acceptedButtons: Qt.NoButton 
	}
}
