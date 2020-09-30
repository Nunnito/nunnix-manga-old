import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    property alias exitButton: exitButton
    id: exitButton

    anchors.bottom: parent.bottom
    height: parent.height
    width: height * 1.25

    icon.source: "../../resources/window-close.svg"
    icon.width: width
    icon.height: height
    icon.color: iconColor
    flat: true

    onClicked: close()

    DragHandler {
        grabPermissions: PointerHandler.ApprovesCancellation
    }
}