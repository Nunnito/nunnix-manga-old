import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
	property alias thumbnailButton: thumbnailButton
	property alias thumbnail: thumbnail
	property alias showAnimation: showAnimation
	property alias label: label
	property alias busyIndicator: busyIndicator
	property alias mouseArea: mouseArea
	property alias tooltip: tooltip
	property alias tooltipLabel: tooltipLabel

	id: thumbnailButton

	width: buttonWidth
	height: buttonHeight

	property string mangaLink
	 background: Rectangle {
		 color: surfaceColor
	 }

	Image {
		id: thumbnail

		width: parent.width
		height: parent.height

		mipmap: true
		opacity: 0
		fillMode: Image.PreserveAspectCrop

		NumberAnimation {
			id: showAnimation
			property: "opacity"
			target: thumbnail

			to: 1
			duration: 500
		}

		onStatusChanged: {
			if (status == 1) {
				showAnimation.running = true
			}
		}
	}

	// Text under the tile
	Label {
		id: label

		anchors.top: parent.bottom
		horizontalAlignment: Text.AlignHCenter

		color: textColor
		width: buttonWidth

		font.pixelSize: normalTextFontSize
		elide: Text.ElideMiddle
	}

	BusyIndicator {
		id: busyIndicator

		anchors.centerIn: parent
	    running: thumbnail.status == 1 ? 0:1
	}

	MouseArea {
		id: mouseArea

		ToolTip {
			id: tooltip
			visible: parent.containsMouse

			delay: 1000
			timeout: 5000

			Label {
				id: tooltipLabel

				text: label.text
				color: textColor
				font.pixelSize: normalTextFontSize
			}
			background: Rectangle {
				color: surfaceColor
			}
		}
		hoverEnabled: true
		onPressed: mouse.accepted = false

		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
	}
	
	function resetTile() {
			thumbnail.source = ""
			thumbnail.opacity = 0
			label.text = ""
	}
}