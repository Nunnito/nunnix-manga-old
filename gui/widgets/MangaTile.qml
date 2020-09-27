import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
	id: thumbnailButton

	width: buttonWidth
	height: buttonHeight

	property string mangaLink
	 background: Rectangle {
		 color: surfaceColor
		 width: parent.width
		 height: parent.height
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
	Text {
		id: thumbnailText
		anchors.top: parent.bottom
		horizontalAlignment: Text.AlignHCenter

		color: "white"
		width: buttonWidth

		font.pixelSize: 14 * scale_factor
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
			text: thumbnailText.text
			background: Rectangle {
				color: surfaceColor
			}
		}

		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
	}
	
	function resetTile() {
			thumbnail.source = ""
			thumbnail.opacity = 0
			thumbnailText.text = ""
	}
}