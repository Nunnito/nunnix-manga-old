import QtQuick 2.15
import QtQuick.Controls 2.15

// Back navigation.
RoundButton {
    property alias back: back

    id: back
    flat: true

    height: mangaToolBar.height
    width: height


    icon.source: "../../../resources/arrow_back.svg"
    icon.color: iconColor
    icon.width: iconSize
    icon.height: iconSize

    onClicked: stackView.pop(), leftBar.visible = true
}