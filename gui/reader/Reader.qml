import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: reader
    Column {
        SwipeReader {id: swipeReader}
    }

    Keys.onEscapePressed: stackView.pop()

    MouseArea {
        id: mouseArea
        z: -1

        width: parent.width
        height: parent.height

        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: parent.forceActiveFocus()
    }
}