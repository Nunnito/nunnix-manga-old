import QtQuick.Controls 2.15

// Left bar explore button.
LeftBarButton {
    property alias exploreButton: exploreButton
    id: exploreButton

    target: "searcher"
    iconFilled: "../../resources/explore-filled.svg"
    iconOutlined: "../../resources/explore-outlined.svg"

    // On clicked, switch to the searcher.
    onClicked: {
        if (!highlighted) {
            stackView.push("../search/Searcher.qml")
        }
    }
}