import QtQuick 2.15
import QtQuick.Controls 2.15

// Title bar maximize/restore button.
Button {
    property alias maximizeButton: maximizeButton
    id: maximizeButton

	anchors.bottom: parent.bottom
	height: parent.height
	width: height * 1.25

	icon.source: visibility == 4 ? "../../resources/window-restore.svg" : "../../resources/window-maximize.svg"
	icon.width: width
	icon.height: height
	icon.color: iconColor
	flat: true

	onClicked: {
		if (visibility == 2) {
			showMaximized()
		}
		else {
			showNormal()
		}
	}

	DragHandler {
		grabPermissions: PointerHandler.ApprovesCancellation
	}
}