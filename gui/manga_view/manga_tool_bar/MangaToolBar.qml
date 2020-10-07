import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Rectangle {
    property alias mangaToolBar: mangaToolBar
    property alias row: row
    property alias menuButton: menuButton
    property alias downloadButton: downloadButton
    property alias addLibrary: addLibrary
    property alias toolBarArea: toolBarArea

    id: mangaToolBar
    z: 1

    width: parent.width
    height: toolbarHeight
    color: surfaceColor

    Row {
        id: row
        width: parent.width
        layoutDirection: Qt.RightToLeft

        MenuButton {id: menuButton}          // Menu button
        DownloadButton {id: downloadButton}  // Download button
        AddLibrary {id: addLibrary}          // Add to library
    }

	MouseArea {
        id: toolBarArea

		anchors.fill: parent
		acceptedButtons: Qt.NoButton 
	}
}
