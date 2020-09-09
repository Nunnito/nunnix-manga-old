import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
	visible: true
	id: main_window

	title: "Nunnix Manga"
	flags: Qt.FramelessWindowHint

	width: Screen.width / 1.5
	height: Screen.height / 2

	minimumWidth: 512 * scaling_factor
	minimumHeight: 512 * scaling_factor

	color: "#111111"

	Material.accent: "#242424"
	Material.theme: Material.System

	property int previousX
	property int previousY

	property int cover_width: 240 * scaling_factor
	property int cover_height: 360 * scaling_factor
	property int window_border: 5 * scaling_factor

	Rectangle {
		anchors.fill: parent
		color: "transparent"
		border.color: "#161616"
		border.width: window_border
		visible: visibility === 2 ? true : false
		z: 1
	}

	Page {
		background: Rectangle {color: "#161616"}
		anchors.fill: parent
		anchors.margins: visibility === 2 ? window_border : 0

		header : TitleBar {}  // Title bar
		Row {
			id: layout
			anchors.fill: parent
			spacing: 40 * scaling_factor

			LeftBar {}  // Lateral bar

			Column {
				topPadding: 20 * scaling_factor
				spacing: 20 * scaling_factor

				Image {
					source: "../resources/fire.svg"

					sourceSize.width: 48 * scaling_factor
					sourceSize.height: 48 * scaling_factor
				}

				MangaSlider{id: popular_manga_slider}
				MangaSlider{id: seinen_manga_slider}
			}
		}
	}


	MouseArea {
		anchors.fill: parent
		hoverEnabled: true

		z: 99
		id: edges_mouse_area

		cursorShape: {
			if (visibility == 2) {
				const pointer = Qt.point(mouseX, mouseY);
				const border = window_border  // Increase the corner size slightly
				if (pointer.x < border && pointer.y < border) return Qt.SizeFDiagCursor
				if (pointer.x >= width - border && pointer.y >= height - border) return Qt.SizeFDiagCursor
				if (pointer.x >= width - border && pointer.y < border) return Qt.SizeBDiagCursor
				if (pointer.x < border && pointer.y >= height - border) return Qt.SizeBDiagCursor
				if (pointer.x < border || pointer.x >= width - border) return Qt.SizeHorCursor
				if (pointer.y < border || pointer.y >= height - border) return Qt.SizeVerCursor
			}
		}
		acceptedButtons: Qt.NoButton  // don't handle actual events
	}

	DragHandler {
		id: resizeHandler
		grabPermissions: PointerHandler.CanTakeOverFromAnything
		target: null

		onActiveChanged: if (active && visibility == 2) {
			const pointer = resizeHandler.centroid.position
			const border = window_border + 10 // Increase the corner size slightly
			let e = 0

			if (pointer.x < border) { e |= Qt.LeftEdge }
			if (pointer.x >= width - border) { e |= Qt.RightEdge }
			if (pointer.y < border) { e |= Qt.TopEdge }
			if (pointer.y >= height - border) { e |= Qt.BottomEdge }

			if (e != 0) {
				startSystemResize(e)
			}
		}
	}

	Component.onCompleted: {
		NunnixManga.get_manga_popular_covers("popular")
		NunnixManga.get_manga_popular_covers("seinen")
	}

	Connections {
		target: NunnixManga

		function onPopular_mangas(popular_data, manga_type) {
			if (manga_type == "popular") {
				popular_manga_slider.setData(popular_data)
			}
			if (manga_type == "seinen") {
			seinen_manga_slider.setData(popular_data)
			}
		}
	}
}