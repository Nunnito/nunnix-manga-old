import QtQuick.Controls 2.15

LeftBarButton {
    target: "library"
    iconFilled: "../../resources/collections_bookmark-filled.svg"
    iconOutlined: "../../resources/collections_bookmark-outlined.svg"

    onClicked: {
        if (flat) {
            stackView.push("../library/Library.qml")
        }
    }    
}