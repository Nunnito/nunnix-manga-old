import QtQuick.Controls 2.15
import QtQuick 2.15
import "../reusable-components"

Flickable {
	width: main_window.width - leftbar.width - layout.spacing - flickable_slider.nav_button_size * 9
	height: manga_slider_row.height

	contentWidth: manga_slider_row.width - manga_slider_row.height
	contentHeight: manga_slider_row.height

	interactive: false

	property int manga_slider_size: JSON.parse(config_file).explorer.slider_size

    rebound: Transition {
        NumberAnimation {properties: "x"; duration: 1000; easing.type: Easing.OutBounce}
    }

	Row {
		id: manga_slider_row
		spacing: 20 * scale_factor

		Repeater {
			id: manga_slider_repeater
			model: manga_slider_size

			MangaTile {}
		}
	}

	// Set manga tiles to defaults
	function resetSlider() {
		NunnixManga.get_manga_popular_covers()

		for (var i=0; i < manga_slider_size; i++) {
			manga_slider_repeater.itemAt(i).children[0].source = ""
			manga_slider_repeater.itemAt(i).children[0].opacity = 0
			manga_slider_repeater.itemAt(i).children[1].text = ""
		}
	}

	// Set manga tile data
	function setData(data) {
		var covers = data[0]
		var names = data[1]
		var links = data[2]

		// Add the covers to the tiles
		for (var i=0; i < covers.length; i++) {
			manga_slider_repeater.itemAt(i).children[0].source = covers[i]
		}

		// Add names to tiles
		for (var i=0; i < names.length; i++) {
			manga_slider_repeater.itemAt(i).children[1].text = names[i]
		}

		// Link the links with the tiles
		for (var i=0; i < links.length; i++) {
			manga_slider_repeater.itemAt(i).manga_link = links[i]
		}
	}
}