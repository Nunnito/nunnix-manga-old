import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Rectangle {
    property alias mangaToolBar: mangaToolBar
    property alias toolBarStackView: toolBarStackView

    property var menuButton: toolBarStackView.children[0].menuButton
    property var downloadButton: toolBarStackView.children[0].downloadButton
    property var addLibrary: toolBarStackView.children[0].addLibrary
    property var toolBarArea: toolBarStackView.children[0].toolBarArea

    id: mangaToolBar
    z: 1

    width: parent.width
    height: toolbarHeight
    color: surfaceColor


    StackView {
        id: toolBarStackView

        height: parent.height
        width: parent.width
        initialItem: "optionsMenuBar.qml"
    }

	MouseArea {
        id: toolBarArea

		anchors.fill: parent
        z: -1
	}
}
