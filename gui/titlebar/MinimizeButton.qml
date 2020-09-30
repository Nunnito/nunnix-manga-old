import QtQuick 2.15
import QtQuick.Controls 2.15

// Title bar minimize button.
Button {
    property alias minimizeButton: minimizeButton
    id: minimizeButton

	anchors.bottom: parent.bottom
	height: parent.height
	width: height * 1.25

	icon.source: "../../resources/window-minimize.svg"
	icon.width: width
	icon.height: height
	icon.color: iconColor
	flat: true

	onClicked: showMinimized()

	DragHandler {
		grabPermissions: PointerHandler.ApprovesCancellation
	}
}