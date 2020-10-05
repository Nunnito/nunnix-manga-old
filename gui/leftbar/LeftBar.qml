import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Rectangle {
	// Left bar alias.
	property alias leftBar: leftBar
	property alias settingsButton: settingsButton
	property alias libraryButton: libraryButton
	property alias exploreButton: exploreButton
	property alias downloadsButton: downloadsButton

	// Left bar properties.
	property int iconSize: 24
	property int leftBarWidth: 72

	id: leftBar
	z: 99
	width: leftBarWidth
	height: parent.height
	color: surfaceColor

	// Left bar column.
	ColumnLayout {
		anchors.fill: parent
		
		LibraryButton {id: libraryButton}       // Library button.
		ExploreButton {id: exploreButton}      // Explore button.
		DownloadsButton {id: downloadsButton}  // Downloads button.
		HistoryButton {id: historyButton}	   // History button.

		Rectangle {id: spacer; Layout.fillHeight: true}  // Spacer
		SettingsButton {id: settingsButton}            		 // Menu button.
	}
}