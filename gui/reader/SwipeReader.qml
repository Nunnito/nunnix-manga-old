import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property var listImages
    property int currentIndex: 0
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
        onWheel: contentY -= wheel.angleDelta.y / 4
    }
    
    Connections {
        target: MangaReader

        function onGet_images(images) {
            var chapterImage = Qt.createComponent("ChapterImage.qml")
            var image = chapterImage.createObject(column)

            image.index = currentIndex
            image.source = images
            currentIndex += 1
        }
    }
}