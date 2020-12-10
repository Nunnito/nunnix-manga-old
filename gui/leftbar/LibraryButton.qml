import QtQuick.Controls 2.15

// Left bar library button.
LeftBarButton {
    property alias libraryButton: libraryButton
    id: libraryButton

    target: "library"
    iconFilled: "../../resources/collections_bookmark-filled.svg"
    iconOutlined: "../../resources/collections_bookmark-outlined.svg"

    // On clicked, switch to the library.
    onClicked: {
        if (!highlighted) {
            swipeView.decrementCurrentIndex()
            stackView.replace("../library/Library.qml")
        }
    }    
}
