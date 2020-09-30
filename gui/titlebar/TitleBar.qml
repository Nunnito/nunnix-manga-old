import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
	property alias titleBar: titleBar
	property alias row: row
	property alias exitButton: exitButton
	property alias maximizeButton: maximizeButton
	property alias minimizeButton: minimizeButton
	property alias titleLabel: titleLabel
	property alias mouseArea: mouseArea

	property int titleBarHeight: 44
	property int titleBarRowHeight: 48

	id: titleBar

	width: parent.width
	height: titleBarHeight

	color: titleBarColor

	Row {
		id: row

		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter

		spacing: normalSpacing / 4
		layoutDirection: Qt.RightToLeft

		height: titleBarRowHeight

		ExitButton {id: exitButton}
		MaximizeButton {id: maximizeButton}
		MinimizeButton {id: minimizeButton}
	}

	TitleText {id: titleLabel}

	DragHandler {
		target: null
		grabPermissions: PointerHandler.TakeOverForbidden
		onActiveChanged: if (active) { mainWindow.startSystemMove()}
	}

	TapHandler {
		onDoubleTapped: visibility == 2 ? showMaximized() : showNormal()
	}

	MouseArea {
		id: mouseArea

		anchors.fill: parent
		hoverEnabled: true
		acceptedButtons: Qt.NoButton
	}
}