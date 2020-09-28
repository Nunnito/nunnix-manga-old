import QtQuick.Controls 2.15

LeftBarButton {
    icon.source: "../../resources/explore-outlined.svg"

    onClicked: stackView.push("../search/Searcher.qml")
}