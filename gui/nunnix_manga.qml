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
	property int smallTextFontSize: 12
	property int normalTextFontSize: 14
	property int bigTextFontSize: 22
	property int normalSpacing: 20
	property bool darkMode: true
	property int normalMaximumFlickVelocity: 1500
    property int normalFlickDeceleration: 2000

	// Colors used for the entire application.
	property var materialAccent: Material.DeepPurple
	property string backgroundColor: darkMode ? "#121212" :"#ffffff"
	property string surfaceColor: darkMode ? "#181818" : "#ffffff"
	property string surfaceColor2: darkMode ? "#222222" : "#ffffff"
	property string surfaceColor3: darkMode ? "#303030" : "#ffffff"
	property string surfaceColor4: darkMode ? "#595959" : "#ffffff"
	property string titleBarColor: darkMode ? "#1F1F1F" : "#ffffff"
	property string textColor: darkMode ? "#FFFFFF" : "#000000"
	property string iconColor: darkMode ? "#AAAAAA" : "#000000"
	property string textAreaColor: "#2D2D2D"
	property string placeHolderColor: "#AAAAAA"
	property string primaryColor: darkMode  ? Material.color(materialAccent, Material.Shade200) : Material.color(materialAccent, Material.Shade500)

	// Aplication Window properties.
	title: "Nunnix Manga"
	flags: Qt.FramelessWindowHint
	width: Screen.width / 1.5
	height: Screen.height / 1.5
	minimumWidth: Screen.width / 1.5
	minimumHeight: Screen.height / 1.5


	// Material style color config.
	Material.theme: darkMode? Material.Dark : Material.Light
	Material.accent: primaryColor
	Material.foreground: textColor
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
				width: leftBar.visible ? mainWindow.width - leftBar.width - layout.spacing : mainWindow.width - layout.spacing
				initialItem: "library/Library.qml"
			}
		}
	}

	function copy(content) {
		var textEdit = Qt.createQmlObject("import QtQuick 2.15; TextEdit{visible: false}", mainWindow)

		textEdit.text = content
		textEdit.selectAll()
		textEdit.copy()
		textEdit.destroy()
	}
}