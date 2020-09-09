import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
	focus: true
	id: manga_slider_button

	width: button_width
	height: button_height

	property string manga_cover_dir
	property string manga_link

    property int button_width: 140 * scaling_factor
    property int button_height: 210 * scaling_factor

    property bool animate: true


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
		anchors.top: parent.bottom
		id: manga_slider_text

		color: "white"
		width: button_width

		font.pixelSize: 14 * scaling_factor
		elide: Text.ElideMiddle
	}

	BusyIndicator {
		anchors.centerIn: parent
	    running: manga_slider_cover.status === 0 ? 1:0
	}
}