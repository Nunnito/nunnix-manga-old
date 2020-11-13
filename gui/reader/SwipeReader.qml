import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property alias column: column
    property alias mouseArea: mouseArea

    property int currentIndex: 0
    property int setIndex: 0

    property real oldYPosition: 0
    property real newYPosition: 0

    property bool zoomInAdjust: false
    property bool zoomOutAdjust: false
    property int adjustToWidth: reader.width - scrollBar.width

    id: swipeReader

    width: reader.width
    height: reader.height
    contentHeight: column.height
    contentWidth: column.width

    boundsMovement: Flickable.StopAtBounds
    pixelAligned: false
    interactive: true

    ScrollBar.vertical: scrollBar

    Column {
        id: column
        width: adjustToWidth
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: normalSpacing
    }

    MouseArea {
        id: mouseArea
        z: -1

        width: parent.height
        height: parent.height
        cursorShape: Qt.OpenHandCursor

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

    onDraggingChanged: {
        mouseArea.cursorShape = dragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
    }
    onContentHeightChanged: {
        newYPosition = contentY / contentHeight
        contentY = oldYPosition * contentHeight
    }
    onContentYChanged: {
        if (contentY != ~~contentY) {
            oldYPosition = contentY / contentHeight
        }
    }

    function zoomOut() {
        if (column.width >= reader.width * 0.25) {
            if (column.width > adjustToWidth) {
                zoomOutAdjust = true
            }
            if (column.width * 0.9 < reader.width && zoomOutAdjust) {
                column.width = Qt.binding(function() {return adjustToWidth})
                zoomOutAdjust = false
            }
            else {
                column.width *= 0.9
            }
        }
    }
    function zoomIn() {
        if (column.width <= reader.width * 2) {
            if (column.width < adjustToWidth) {
                zoomInAdjust = true
            }
            if (column.width * 1.1 > reader.width && zoomInAdjust) {
                column.width = Qt.binding(function() {return adjustToWidth})
                zoomInAdjust = false
            }
            else {
                column.width *= 1.1
            }
        }
    }
}