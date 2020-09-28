import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
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
			id: thumbnailAnimation
			target: thumbnail
			property: "opacity"
			to: 1
			duration: 500
		}

		onStatusChanged: {
			if (status == 1) {
				thumbnailAnimation.running = true
			}
		}
	}

	// Text under the tile
	Label {
		id: thumbnailText
		anchors.top: parent.bottom
		horizontalAlignment: Text.AlignHCenter

		color: textColor
		width: buttonWidth

		font.pixelSize: normalTextFontSize
		elide: Text.ElideMiddle
	}

	BusyIndicator {
		anchors.centerIn: parent
	    running: thumbnail.status == 1 ? 0:1
	}

	MouseArea {
		ToolTip {
			id: thumbnailTooltip
			visible: parent.containsMouse
			delay: 1000
			timeout: 5000

			Label {
				text: thumbnailText.text
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
			thumbnailText.text = ""
	}
}