import QtQuick 2.15

Row {
    property alias row: row
    property alias menuButton: menuButton
    property alias downloadButton: downloadButton
    property alias addLibrary: addLibrary

    id: row
    width: parent.width
    layoutDirection: Qt.RightToLeft

    MenuButton {id: menuButton}          // Menu button
    DownloadButton {id: downloadButton}  // Download button
    AddLibrary {id: addLibrary}          // Add to library
}