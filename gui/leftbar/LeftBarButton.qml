import QtQuick.Controls 2.15
import QtQuick 2.15

Button {
    property alias leftBarButton: leftBarButton

    property string target
    property string iconFilled
    property string iconOutlined
    property var pastCurrentItem

    id: leftBarButton
    flat: stackView.currentItem.name == target ? false : true

    width: parent.parent.width
    height: width

    icon.source: flat ? iconOutlined : iconFilled
    icon.width: iconSize
    icon.height: iconSize
    icon.color: flat ? iconColor : primaryColor

    onClicked: {
        if (stackView.currentItem.name != target) {
            stackView.pop()
        }
    }
}