import QtQuick 2.14
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.14

Rectangle {
	opacity: 1
	width: 72 * scaling_factor
	height: parent.height
	color: "#1e1e1e"
	z: 98

	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		Button {
			flat: true

			width: parent.parent.width
			height: width

			icon.source: "../resources/menu-white.svg"
			icon.color: "#c5ccd4"
			icon.width: width / 3
			icon.height: height / 3
		}
	}
}