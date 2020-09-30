import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    property alias button: button
    property alias area: area

    id: button

    text: qsTr("Search")
    highlighted: true

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    contentItem: Text {
        text: parent.text  
        color: backgroundColor
        font.bold: true

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        id: area

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }

    onClicked: genSearchData(true)
}