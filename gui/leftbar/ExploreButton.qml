import QtQuick.Controls 2.15

LeftBarButton {
    target: "searcher"
    iconFilled: "../../resources/explore-filled.svg"
    iconOutlined: "../../resources/explore-outlined.svg"

    onClicked: {
        if (flat) {
            stackView.push("../search/Searcher.qml")
        }
    }
}