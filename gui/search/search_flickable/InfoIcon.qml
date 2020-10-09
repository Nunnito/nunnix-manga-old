import QtQuick.Controls 2.15
import QtQuick 2.15

Column {
    // Information icon alias.
    property alias infoIcon: infoIcon
    property alias icon: icon.icon
    property alias label: label

    property bool isSmall: false

    // Information icon properties.
    id: infoIcon
    visible: false
    x: mainWindow.width / 2 - leftBar.width * 2 - searchFlickable.leftMargin
    y: mainWindow.height / 2 - (titleBar.height + searchFlickable.topMargin) * 2

    RoundButton {
        id: icon

        width: isSmall ? reloadSmallButtonWidth : reloadButtonWidth
        height: width

        icon.width: width
        icon.color: iconColor
        icon.height: width

        flat: true
        enabled: false

        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: label

        color: placeHolderColor
        font.pixelSize: isSmall ? reloadSmallButtonTextSize : reloadButtonTextSize
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }
}