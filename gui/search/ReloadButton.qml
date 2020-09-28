import QtQuick.Controls 2.15
import QtQuick 2.15

Column {
    visible: false
    property bool isSmall: false
    RoundButton {
        width: isSmall ? reloadSmallButtonWidth : reloadButtonWidth
        height: width
        icon.source: "../../resources/autorenew.svg"
        icon.width: width
        icon.color: iconColor
        icon.height: width
        flat: true
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: currentPage -= 1, reconnect(isSmall)
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed:  mouse.accepted = false
        }
    }

    Label {
        color: textColor
        font.pixelSize: isSmall ? reloadSmallButtonTextSize : reloadButtonTextSize
        anchors.horizontalCenter: parent.horizontalCenter
    }
}