import QtQuick 2.14
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.14

Rectangle {
	opacity: 1
	width: 72 * scale_factor
	height: parent.height
	color: surfaceColor
	z: 98

	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		Button {
			flat: true

			width: parent.parent.width
			height: width

			icon.source: "../../resources/menu.svg"
			icon.width: width / 3
			icon.height: height / 3
			icon.color: textColor
		}
	}

	function hide() {
		parent.visible = false
	}
}