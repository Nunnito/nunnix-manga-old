import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property int currentIndex: 0
    property int setIndex: 0

    id: swipeReader

    width: reader.width
    height: reader.height
    contentHeight: column.height

    boundsMovement: Flickable.StopAtBounds
    interactive: true

    ScrollBar.vertical: ScrollBar {}

    Column {
        id: column
        spacing: normalSpacing
    }

    MouseArea {
        z: -1
        anchors.fill: parent

        onWheel: {
            swipeReader.contentY -= wheel.angleDelta.y / moveFlickable
        }
    }
    
    Connections {
        target: MangaDownloader

        function onGet_images(images, imgWidth, imgHeight, buttonLink, imagesCount, downloadCount) {
            var image = Qt.createComponent("ChapterImage.qml")
            image = image.createObject(column)

            image.realWidth = imgWidth
            image.realHeight = imgHeight
            image.index = setIndex
            image.source = images
            setIndex++
        }
    }
}