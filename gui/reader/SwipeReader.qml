import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property var listImages
    id: swipeReader

    width: reader.width
    height: reader.height
    contentHeight: column.height
    boundsMovement: Flickable.StopAtBounds

    ScrollBar.vertical: ScrollBar { }

    Column {
        id: column
        spacing: normalSpacing / 2

        Repeater {
            id: repeater
            model: listImages == null ? null : listImages.length

            ChapterImage {}
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        hoverEnabled: true
        cursorShape: cursorShape = Qt.OpenHandCursor

        onPositionChanged: {
            print(contentY)
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
            listImages = images
        }
    }
}