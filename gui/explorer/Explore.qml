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
    property bool isNotLoading: true

    id: flickable_slider

    width: main_window.width - leftbar.width - layout.spacing
    height: parent.height
    contentHeight: slider_col.height

    onMovementStarted: {
        canAnimateSlider = false
        if (atYEnd, contentY + main_window.height > contentHeight / 2 && isNotLoading) {
            infinite.next()
            isNotLoading = false
        }
    }
    onMovementEnded: {
        canAnimateSlider = true
        if (atYEnd, contentY + main_window.height > contentHeight / 2 && isNotLoading) {
            infinite.next()
            isNotLoading = false
        }
    }

    Column {
        id: slider_col
        width: parent.width
        spacing: 75 * scale_factor

        topPadding: 20 * scale_factor
        bottomPadding: 40 * scale_factor

        Repeater {
            id: manga_slider_nav_repeater
            model: getTotalModel()

            MangaSliderNav {id: index}

            onItemAdded: {
                NunnixManga.get_manga_slider_covers(model[index], index)
            }
        }

        ExploreInfinite {id: infinite}
    }

	Connections {
		target: NunnixManga

		function onSlider_data(manga_data, manga_type, slider_int) {
            var manga_slider_nav = manga_slider_nav_repeater.itemAt(slider_int)

			if (manga_type == "popular") {
				manga_slider_nav.children[3].setData(manga_data)
                manga_slider_nav.children[0].text = qsTr("Top Manga")
			}
			if (manga_type == "seinen") {
				manga_slider_nav.children[3].setData(manga_data)
                manga_slider_nav.children[0].text = qsTr("Seinen")
			}
			if (manga_type == "shounen") {
				manga_slider_nav.children[3].setData(manga_data)
                manga_slider_nav.children[0].text = qsTr("Shounen")
			}
            if (manga_type == "josei") {
				manga_slider_nav.children[3].setData(manga_data)
                manga_slider_nav.children[0].text = qsTr("Josei")
            }
            if (manga_type == "shoujo") {
				manga_slider_nav.children[3].setData(manga_data)
                manga_slider_nav.children[0].text = qsTr("Shoujo")
            }
		}
	}

    MouseArea {
        z: -1
        anchors.fill: parent
        onPressed: interactive = false
        onReleased: interactive = true
    }

    function getTotalModel () {
        var modelInt = []

        if (show_popular) modelInt.push("popular")
        if (show_seinen) modelInt.push("seinen")
        if (show_shounen) modelInt .push("shounen")
        if (show_josei) modelInt.push("josei")
        if (show_shoujo) modelInt.push("shoujo")

        return modelInt
    }
}