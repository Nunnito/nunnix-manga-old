import QtQuick 2.15
import QtQuick.Controls 2.15

// TEMPORAL CODE, FOR TESTING

Rectangle {
    id: footer
    width: parent.width
    height: 30
    color: surfaceColor

    Row {
        id: row

        layoutDirection: Qt.RightToLeft
        width: parent.width
        height: parent.height

        ChangeSource {id: changeSource}
    }

	MouseArea {
		id: mouseArea

		anchors.fill: parent
        z: -1
	}
}