import QtQuick 2.15
import QtQuick.Controls 2.15

SwipeView {
    property var listImages
    id: swipeReader

    width: reader.width
    height: reader.height
    orientation: Qt.Vertical

    Repeater {
        id: repeater
        model: listImages == null ? null : listImages.length

        Loader {
            id: loader
            active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem

            source: "ChapterImage.qml"
        }
    }
    
    Connections {
        target: MangaReader
        function onGet_images(images) {
            listImages = images
        }
    }
}