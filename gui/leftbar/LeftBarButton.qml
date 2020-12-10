import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick 2.15

// Left bar custom button
ItemDelegate {
    property alias leftBarButton: leftBarButton

    // Properties
    property string target
    property string iconFilled
    property string iconOutlined
    property var pastCurrentItem

    id: leftBarButton
    highlighted: (stackView.currentItem.name == target && !swipeView.currentIndex) ? true : false
    display: AbstractButton.IconOnly

    Layout.preferredWidth: parent.parent.width
    Layout.preferredHeight: width - normalSpacing / 2


    icon.source: !highlighted ? iconOutlined : iconFilled
    icon.width: iconSize
    icon.height: iconSize
    icon.color: !highlighted ? iconColor : primaryColor
}
