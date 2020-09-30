import QtQuick 2.14
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.14

Rectangle {
	// Left bar alias.
	property alias leftBar: leftBar
	property alias menuButton: menuButton
	property alias libraryButton: libraryButton
	property alias exploreButton: exploreButton
	property alias downloadsButton: downloadsButton

	// Left bar properties.
	property int iconSize: 24
	property int leftBarWidth: 72

	id: leftBar
	width: leftBarWidth
	height: parent.height
	color: surfaceColor

	// Left bar column.
	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		MenuButton {id: menuButton}            // Menu button.
		LibraryButton {id: libraryButton       // Library button.
		ExploreButton {id: exploreButton}      // Explore button.
		DownloadsButton {id: downloadsButton}  // Downloads button.
	}
}