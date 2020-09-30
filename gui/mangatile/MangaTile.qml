import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
	// Manga tile alias.
	property alias thumbnailButton: thumbnailButton
	property alias thumbnail: thumbnail
	property alias showAnimation: showAnimation
	property alias labelBackground: labelBackground
	property alias label: label
	property alias busyIndicator: busyIndicator
	property alias mouseArea: mouseArea
	property alias tooltip: tooltip
	property alias tooltipLabel: tooltipLabel

	id: thumbnailButton

	// Manga tile properties.
	width: buttonWidth
	height: buttonHeight

	property string mangaLink
	background: Rectangle {
		 color: surfaceColor
	 }

	// Manga title image
	Image {
		id: thumbnail

		width: parent.width
		height: parent.height

		mipmap: true
		opacity: 0  						// Set opacity to 0 for smooth animation.
		fillMode: Image.PreserveAspectCrop  // Crop the image if it doesn't fit the button.
		
		NumberAnimation {
			id: showAnimation
			property: "opacity"
			target: thumbnail

			to: 1
			duration: 500
		}

		// If the image is loaded, run the animation.
		onStatusChanged: {
			if (status == 1) {
				showAnimation.running = true
			}
		}
	}

	// Background gradient for label.
	Rectangle {
		id: labelBackground

		width: parent.width
		height: parent.height

		// Text under the tile.
		Label {
			id: label

			bottomPadding: normalSpacing / 4
			anchors.bottom: parent.bottom
			horizontalAlignment: Text.AlignHCenter

			color: textColor
			width: buttonWidth

			font.pixelSize: normalTextFontSize
			elide: Text.ElideMiddle

		}

		// Gradient.
		gradient: Gradient {
			GradientStop {position: 0.8; color: "#00000000"}
			GradientStop {position: 0.9; color: "#CC000000"}
			GradientStop { position: 1.0; color: backgroundColor}
		}
	}

	BusyIndicator {
		id: busyIndicator

		anchors.centerIn: parent
	    running: thumbnail.status == 1 ? 0:1  // Run if image is not loaded.
	}

	MouseArea {
		id: mouseArea

		// Manga tile tooltip. Appears when the mouse is over it for 1000 milliseconds.
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
	
	// Reset manga tile to default.
	function resetTile() {
			thumbnail.source = ""
			thumbnail.opacity = 0
			label.text = ""
	}
}