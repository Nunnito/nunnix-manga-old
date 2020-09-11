import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Flickable {
    property int slider_title_size_font: 24 * scaling_factor
    property int nav_button_size: 32 * scaling_factor
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
        spacing: 75 * scaling_factor

        topPadding: 20 * scaling_factor
        bottomPadding: 40 * scaling_factor
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

                onClicked: popular_manga_slider.flick(popular_manga_slider.contentWidth / 1.5, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: popular_manga_slider.flick(-popular_manga_slider.contentWidth / 1.5, 0)
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

                onClicked: seinen_manga_slider.flick(seinen_manga_slider.contentWidth / 1.5, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: seinen_manga_slider.flick(-seinen_manga_slider.contentWidth / 1.5, 0)
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

                onClicked: shounen_manga_slider.flick(shounen_manga_slider.contentWidth / 1.5, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: shounen_manga_slider.flick(-shounen_manga_slider.contentWidth / 1.5, 0)
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

                onClicked: josei_manga_slider.flick(josei_manga_slider.contentWidth / 1.5, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: josei_manga_slider.flick(-josei_manga_slider.contentWidth / 1.5, 0)
            }
            MangaSlider{id: josei_manga_slider}
        }
        GridLayout {
            columns: 3
            width: parent.width
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

                onClicked: shoujo_manga_slider.flick(shoujo_manga_slider.contentWidth / 1.5, 0)
            }
            RoundButton {
                highlighted: true
                icon.source: "../resources/chevron_right.svg"

                width: nav_button_size
                height: nav_button_size
                icon.width: nav_button_size
                icon.height: nav_button_size

                onClicked: shoujo_manga_slider.flick(-shoujo_manga_slider.contentWidth / 1.5, 0)
            }
            MangaSlider{id: shoujo_manga_slider}
        }
    }

	Component.onCompleted: {
		NunnixManga.get_manga_popular_covers("popular")
		NunnixManga.get_manga_popular_covers("seinen")
		NunnixManga.get_manga_popular_covers("shounen")
        NunnixManga.get_manga_popular_covers("josei")
        NunnixManga.get_manga_popular_covers("shoujo")
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