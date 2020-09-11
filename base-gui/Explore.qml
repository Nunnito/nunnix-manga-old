import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Flickable {
    property int slider_title_size_font: 24 * scale_factor
    property int nav_button_size: 32 * scale_factor

    property bool show_popular: JSON.parse(config_file).explorer.show_popular
    property bool show_seinen: JSON.parse(config_file).explorer.show_seinen
    property bool show_shounen: JSON.parse(config_file).explorer.show_shounen
    property bool show_josei: JSON.parse(config_file).explorer.show_josei
    property bool show_shoujo: JSON.parse(config_file).explorer.show_shoujo

	property bool canAnimateSlider: true

    id: flickable_slider

    width: main_window.width - leftbar.width - layout.spacing
    height: parent.height
    contentHeight: slider_col.height

    onFlickStarted:{
        canAnimateSlider = false
    }
    onFlickEnded:{
        canAnimateSlider = true
    }

    Column {
        id: slider_col
        width: parent.width
        spacing: 75 * scale_factor

        topPadding: 20 * scale_factor
        bottomPadding: 40 * scale_factor
        GridLayout {
            columns: 3
            width: parent.width
            Material.accent: "#2A2A2A"

            Text {
                id: title_slider_text
                text: qsTr("Top Manga")
                color: "white"
                font.pixelSize: slider_title_size_font
                Layout.fillWidth: true
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_left.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: popular_manga_slider.flick(main_window.width, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: popular_manga_slider.flick(-main_window.width, 0)
            }
            MangaSlider{id: popular_manga_slider}
        }
        GridLayout {
            columns: 3
            width: parent.width
            Material.accent: "#2A2A2A"

            Text {
                text: qsTr("Seinen")
                color: "white"
                font.pixelSize: slider_title_size_font
                Layout.fillWidth: true
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_left.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: seinen_manga_slider.flick(main_window.width, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: seinen_manga_slider.flick(-main_window.width, 0)
            }
            MangaSlider{id: seinen_manga_slider}
        }
        GridLayout {
            columns: 3
            width: parent.width
            Material.accent: "#2A2A2A"

            Text {
                text: qsTr("Shounen")
                color: "white"
                font.pixelSize: slider_title_size_font
                Layout.fillWidth: true
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_left.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: shounen_manga_slider.flick(main_window.width, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: shounen_manga_slider.flick(-main_window.width, 0)
            }
            MangaSlider{id: shounen_manga_slider}
        }
        GridLayout {
            columns: 3
            width: parent.width
            Material.accent: "#2A2A2A"

            Text {
                text: qsTr("Josei")
                color: "white"
                font.pixelSize: slider_title_size_font
                Layout.fillWidth: true
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_left.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: josei_manga_slider.flick(main_window.width, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: josei_manga_slider.flick(-main_window.width, 0)
            }
            MangaSlider{id: josei_manga_slider}
        }
        GridLayout {
            width: parent.width
            columns: 3
            Material.accent: "#2A2A2A"

            Text {
                text: qsTr("Shoujo")
                color: "white"
                font.pixelSize: slider_title_size_font
                Layout.fillWidth: true
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_left.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: shoujo_manga_slider.flick(main_window.width, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: shoujo_manga_slider.flick(-main_window.width, 0)
            }
            MangaSlider{id: shoujo_manga_slider}
        }
    }

	Component.onCompleted: {
        if (show_popular) {
		    NunnixManga.get_manga_slider_covers("popular")
        }
        if (show_seinen) {
		    NunnixManga.get_manga_slider_covers("seinen")
        }
        if (show_shounen) {
		    NunnixManga.get_manga_slider_covers("shounen")
        }
        if (show_josei) {
            NunnixManga.get_manga_slider_covers("josei")
        }
        if (show_shoujo) {
            NunnixManga.get_manga_slider_covers("shoujo")
        }
	}

	Connections {
		target: NunnixManga

		function onSlider_data(manga_data, manga_type) {
			if (manga_type == "popular") {
				popular_manga_slider.setData(manga_data)
			}
			if (manga_type == "seinen") {
			seinen_manga_slider.setData(manga_data)
			}
			if (manga_type == "shounen") {
				shounen_manga_slider.setData(manga_data)
			}
            if (manga_type == "josei") {
                josei_manga_slider.setData(manga_data)
            }
            if (manga_type == "shoujo") {
                shoujo_manga_slider.setData(manga_data)
            }
		}
	}

    
    MouseArea {
        z: -1
        anchors.fill: parent
        onPressed: interactive = false
        onReleased: interactive = true
    }
    
}