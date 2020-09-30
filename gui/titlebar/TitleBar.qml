import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
	// Title bar alias.
	property alias titleBar: titleBar
	property alias row: row
	property alias exitButton: exitButton
	property alias maximizeButton: maximizeButton
	property alias minimizeButton: minimizeButton
	property alias titleLabel: titleLabel
	property alias mouseArea: mouseArea

	// Title bar properties.
	property int titleBarHeight: 44
	property int titleBarRowHeight: 48

	id: titleBar
	width: parent.width
	height: titleBarHeight
	color: titleBarColor

	// Title bar row.
	Row {
		id: row

		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter

		// Row properties.
		spacing: normalSpacing / 4
		layoutDirection: Qt.RightToLeft
		height: titleBarRowHeight

		// Row buttons.
		ExitButton {id: exitButton}  		 // Close buton.
		MaximizeButton {id: maximizeButton}  // Maximize/restore button.
		MinimizeButton {id: minimizeButton}  // Minimize button.
	}

	// Title bar label
	TitleText {id: titleLabel}

	// Handler that allows to move the application.
	DragHandler {
		target: null
		grabPermissions: PointerHandler.TakeOverForbidden
		onActiveChanged: if (active) { mainWindow.startSystemMove()}
	}

	// Tap handler that allows double click to toggle maximize/restore.
	TapHandler {
		onDoubleTapped: visibility == 2 ? showMaximized() : showNormal()
	}

	MouseArea {
		id: mouseArea

		anchors.fill: parent
		acceptedButtons: Qt.NoButton
	}
}