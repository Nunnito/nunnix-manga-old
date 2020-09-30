import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Rectangle {
    property alias searchToolBar: searchToolBar
    property alias searchLineEdit: searchLineEdit
    property alias searchButton: searchButton
    property alias menuButton: menuButton

    property alias column: column
    property alias searchArea: searchArea

    property int toolbarHeight: 48
    property int searchInputRadius: 5
    property int iconSize: 24

    id: searchToolBar
    z: 1

    width: parent.width
    height: toolbarHeight
    color: surfaceColor

    Row {
        id: column

        width: parent.width
        layoutDirection: Qt.RightToLeft

        MenuButton {id: menuButton}
        SearchButton {id: searchButton}
        SearchLineEdit {id: searchLineEdit}
    }


	MouseArea {
        id: searchArea

		anchors.fill: parent
		acceptedButtons: Qt.NoButton 
	}
}
