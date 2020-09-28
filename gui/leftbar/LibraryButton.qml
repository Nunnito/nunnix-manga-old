import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

LeftBarButton {
    icon.source:"../../resources/collections_bookmark-outlined.svg"

    onClicked: stackView.push("../library/Library.qml")
}