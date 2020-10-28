import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property var listImages
    property int currentIndex: 0
    property bool loaded

    id: swipeReader

    width: reader.width
    height: reader.height
    contentHeight: column.height
    boundsMovement: Flickable.StopAtBounds

    ScrollBar.vertical: ScrollBar { }

    Column {
        id: column
        spacing: normalSpacing / 2
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        hoverEnabled: true
        cursorShape: cursorShape = Qt.OpenHandCursor

        onPositionChanged: {
            if (pressedButtons == Qt.LeftButton) {
                cursorShape = Qt.ClosedHandCursor
            }
            else {
                cursorShape = Qt.OpenHandCursor
            }
        }
        onWheel: {
            if (os == "win32") {
                contentY -= wheel.angleDelta.y
            }
            if (os == "linux") {
                contentY -= wheel.angleDelta.y / 4
            }
        }
    }
    
    Connections {
        target: MangaDownloader

        function onGet_images(images, buttonLink, imagesCount, downloadCount) {
            var chapterImage = Qt.createComponent("ChapterImage.qml")
            var image = chapterImage.createObject(column)

            image.index = currentIndex
            image.source = images
            currentIndex += 1

            if (imagesCount == downloadCount) {
                loaded = true
            }
        }
    }
}