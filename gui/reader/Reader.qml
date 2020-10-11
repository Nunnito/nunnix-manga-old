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
        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: parent.forceActiveFocus()
    }
}