import QtQuick.Controls 2.15
import QtQuick 2.15

Column {
    // Reload button alias.
    property alias reloadButton: reloadButton
    property alias icon: icon
    property alias label: label
    property alias area: area

    property bool isSmall: false

    // Reload button properties.
    id: reloadButton
    visible: false

    RoundButton {
        id: icon

        width: isSmall ? reloadSmallButtonWidth : reloadButtonWidth
        height: width
        icon.source: "../../../resources/autorenew.svg"
        icon.width: width
        icon.color: iconColor
        icon.height: width
        flat: true
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            currentPage -= 1
            genSearchData(false)
        }
        MouseArea {
            id: area
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed:  mouse.accepted = false
        }
    }

    Label {
        id: label

        color: placeHolderColor
        font.pixelSize: isSmall ? reloadSmallButtonTextSize : reloadButtonTextSize
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }
}