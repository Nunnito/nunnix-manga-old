import QtQuick 2.14
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.14

Rectangle {
	property int iconSize: 24
	property int leftBarWidth: 72

	width: leftBarWidth
	height: parent.height
	color: surfaceColor

	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		MenuButton {id: menuButton}
		LibraryButton {id: libraryButton}
		ExploreButton {id: exploreButton}
		DownloadsButton {id: downloadsButton}
	}
}