import QtQuick 2.15
import QtQuick.Layouts 1.15

RowLayout {
    property alias row: row
    property alias menuButton: menuButton
    property alias downloadButton: downloadButton
    property alias addLibrary: addLibrary
    property alias back: back

    id: row
    width: parent.width
    layoutDirection: Qt.RightToLeft

    MenuButton {id: menuButton}          // Menu button
    DownloadButton {id: downloadButton}  // Download button
    AddLibrary {id: addLibrary}          // Add to library
    Rectangle {
        Layout.fillWidth: true
        color: "transparent"
    }
    BackButton {id: back}                // Back
}