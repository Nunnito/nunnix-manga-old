import QtQuick 2.15
import QtQuick.Controls 2.15

// Left bar downloads button.
LeftBarButton {
    property alias downloadsButton: downloadsButton
    id: downloadsButton

    target: "downloader"
    iconFilled: "../../resources/download-fill.svg"
    iconOutlined: "../../resources/download-outlined.svg"

    highlighted: swipeView.currentIndex


    // On clicked, switch to the downloader.
    onClicked: {
        if (!highlighted) {
        swipeView.incrementCurrentIndex()
        }
    }
}
