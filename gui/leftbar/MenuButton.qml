import QtQuick.Controls 2.15

// Left bar menu button.
LeftBarButton {
    property alias menuButton: menuButton
    id: menuButton

    icon.source: "../../resources/menu.svg"
    icon.width: iconSize
    icon.height: iconSize
}