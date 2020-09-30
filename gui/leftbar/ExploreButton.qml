import QtQuick.Controls 2.15

LeftBarButton {
    property alias exploreButton: exploreButton
    id: exploreButton

    target: "searcher"
    iconFilled: "../../resources/explore-filled.svg"
    iconOutlined: "../../resources/explore-outlined.svg"

    onClicked: {
        if (flat) {
            stackView.push("../search/Searcher.qml")
        }
    }
}