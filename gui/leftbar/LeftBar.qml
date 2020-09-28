import QtQuick 2.14
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.14

Rectangle {
	property int iconSize: 24
	property int leftBarWidth: 72

	opacity: 1
	width: leftBarWidth
	height: parent.height
	color: surfaceColor
	z: 98

	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		MenuButton {}
		LibraryButton {}
		ExploreButton {}
		DownloadsButton {}
	}

	function hide() {
		parent.visible = false
	}
}