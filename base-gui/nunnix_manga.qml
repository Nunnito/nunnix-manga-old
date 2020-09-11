import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
	visible: true
	id: main_window

	property double scale_factor: JSON.parse(config_file).system.scale_factor

	title: "Nunnix Manga"
	flags: Qt.FramelessWindowHint

	width: Screen.width / 1.5
	height: Screen.height / 2

	minimumWidth: 512 * scale_factor
	minimumHeight: 512 * scale_factor

	color: "#111111"

	Material.accent: "#242424"
	Material.theme: Material.Dark


	Page {
		background: Rectangle {color: "#161616"}
		anchors.fill: parent

		header : TitleBar {}  // Title bar
		Row {
			id: layout
			anchors.fill: parent
			spacing: 40 * scale_factor

			LeftBar {id: leftbar}  // Lateral bar
			StackView {
				id: stack_view

				height: parent.height
				width: main_window.width - leftbar.width - layout.spacing
				initialItem: "Explore.qml"
			}
		}
	}
}