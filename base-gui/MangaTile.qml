import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
	id: slider_button

	width: button_width
	height: button_height

	property string manga_cover_dir
	property string manga_link

    property int button_width: 140 * scaling_factor
    property int button_height: 210 * scaling_factor
	property int animation_width: 176 * scaling_factor
    property int animation_height: 264 * scaling_factor

	Image {
		id: manga_slider_cover

		width: parent.width
		height: parent.height

		mipmap: true
		opacity: 0
		fillMode: Image.PreserveAspectCrop

		NumberAnimation {id: slider_cover_animation; target: manga_slider_cover; property: "opacity"; to: 1; duration: 250}

		onStatusChanged: {
			if (status == 1 || source != "") {
				slider_cover_animation.running = true
			}
		}
	}

	// Text under the tile
	Text {
		id: slider_text
		anchors.top: parent.bottom

		color: "white"
		width: button_width

		font.pixelSize: 14 * scaling_factor
		elide: Text.ElideMiddle
	}

	BusyIndicator {
		anchors.centerIn: parent
	    running: manga_slider_cover.status === 0 ? 1:0
	}

	// Animation for when the mouse is over a manga
	ParallelAnimation {
		id: anim_manga_on

		NumberAnimation {target: slider_button; property: "width"; to: animation_width; duration: 250}
		NumberAnimation {target: slider_button; property: "height"; to: animation_height; duration: 250}
		NumberAnimation {target: slider_text; property: "y"; to: animation_height; duration: 250}
		NumberAnimation {target: slider_text; property: "width"; to: animation_width; duration: 250}
		
	}

	// Animation for when the mouse is not on a manga
	ParallelAnimation {
		id: anim_manga_off

		NumberAnimation {target: slider_button; property: "width"; to: button_width; duration: 250}
		NumberAnimation {target: slider_button; property: "height"; to: button_height; duration: 250}
		NumberAnimation {target: slider_text; property: "y"; to: button_height; duration: 250}
		NumberAnimation {target: slider_text; property: "width"; to: button_width; duration: 250}
	}

	
	MouseArea {
		ToolTip {
			id: slider_tooltip
			visible: parent.containsMouse
			delay: 1000
			timeout: 5000
			text: slider_text.text
			background: Rectangle {
				color: "#1E1E1E"
			}
		}

		anchors.fill: parent
		cursorShape: canAnimateSlider === true ? Qt.PointingHandCursor : Qt.ArrowCursor
		hoverEnabled: true
		onEntered: {
			if (canAnimateSlider) {
				anim_manga_on.start()
			}	
		}
		onExited: anim_manga_off.start()
	}
	
}