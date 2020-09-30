import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "leftbar"
import "titlebar"

ApplicationWindow {
	visible: true
	id: mainWindow

	// Global properties.
	property int normalTextFontSize: 14
	property int normalSpacing: 20
	property bool darkTheme: true

	// Colors used for the entire application.
	property string backgroundColor: darkTheme? "#121212" :"#ffffff"
	property string surfaceColor: darkTheme? "#181818" : "#ffffff"
	property string surfaceColor2: darkTheme? "#222222" : "#ffffff"
	property string titleBarColor: darkTheme? "#1F1F1F" : "#ffffff"
	property string textColor: darkTheme? "#FFFFFF" : "#000000"
	property string iconColor: darkTheme? "#AAAAAA" : "#000000"
	property string primaryColor: Material.color(Material.DeepPurple, Material.Shade200)
	property string secondaryColor: Material.color(Material.DeepPurple)
	property string textAreaColor: "#2D2D2D"
	property string placeHolderColor: "#AAAAAA"

	// Aplication Window properties.
	title: "Nunnix Manga"
	flags: Qt.FramelessWindowHint
	width: Screen.width / 1.5
	height: Screen.height / 1.5
	minimumWidth: Screen.width / 1.5
	minimumHeight: Screen.height / 1.5


	// Material style color config.
	Material.theme: darkTheme? Material.Dark : Material.Light
	Material.accent: primaryColor
	Material.foreground: "white"
	Material.background: surfaceColor2
	Material.primary: primaryColor

	// Create the title bar
	menuBar: TitleBar {id: titleBar}


	// Page container. Main container.
	Page {
		background: Rectangle {color: backgroundColor}  // Background color
		anchors.fill: parent

		// Row container
		Row {
			id: layout
			anchors.fill: parent

			// Lateral bar
			LeftBar {id: leftBar}

			// Each part of the application is loaded here.
			StackView {
				id: stackView

				height: parent.height
				width: mainWindow.width - leftBar.width - layout.spacing
				initialItem: "library/Library.qml"
			}
		}
	}
}