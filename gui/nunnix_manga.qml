import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "widgets"

ApplicationWindow {
	visible: true
	id: main_window

	property double scale_factor: JSON.parse(config_file).system.scale_factor
	property bool darkTheme: true

	property string backgroundColor: darkTheme? "#121212":"#ffffff"
	property string surfaceColor: darkTheme? "#181818": "#ffffff"
	property string titleBarColor: darkTheme? "#1F1F1F": "#ffffff"

	title: "Nunnix Manga"
	flags: Qt.FramelessWindowHint

	width: Screen.width / 1.5
	height: Screen.height / 1.5

	minimumWidth: Screen.width / 1.5
	minimumHeight: Screen.height / 1.5


	Material.theme: Material.Dark
	Material.accent: Material.DeepPurple

	Page {
		background: Rectangle {color: backgroundColor}
		anchors.fill: parent

		header : TitleBar {}  // Title bar
		Row {
			id: layout
			anchors.fill: parent
			spacing: 20 * scale_factor

			LeftBar {id: leftbar}  // Lateral bar
			StackView {
				id: stack_view

				height: parent.height
				width: main_window.width - leftbar.width - layout.spacing
				initialItem: "search/Searcher.qml"
			}
		}
	}
}