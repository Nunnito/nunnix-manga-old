import QtQuick 2.15
import QtQuick.Controls 2.15
import "../wheel_area"

Flickable {
    property alias column: column
    property alias mouseArea: mouseArea

    property int setIndex: 0

    property real oldYPosition: 0
    property real newYPosition: 0

    property bool zoomInAdjust: false
    property bool zoomOutAdjust: false

    property int angleDeltaCount: 0
    property int adjustToWidth: reader.width - scrollBar.width
    property int toContentY: 0

    id: swipeReader

    width: reader.width
    height: reader.height - controlsBar.height
    contentHeight: column.height
    contentWidth: column.width

    boundsMovement: Flickable.StopAtBounds
    interactive: true

    ScrollBar.vertical: scrollBar

    Column {
        id: column
        width: adjustToWidth
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: normalSpacing
    }

    WheelArea {
        id: mouseArea
        cursorShape: Qt.OpenHandCursor

        parent: swipeReader
        useContentX: true

        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                angleDeltaCount += wheel.angleDelta.y

                if (angleDeltaCount >= 120) {
                    zoomIn()
                    angleDeltaCount = 0
                }
                if (angleDeltaCount <= -120) {
                    zoomOut()
                    angleDeltaCount = 0
                }
            }
        }
    }

    PropertyAnimation {id: contentYAnimation; target: swipeReader; property: "contentY"; to: toContentY; duration: 200}

    Connections {
        target: MangaDownloader

        function onGet_images(images, imgWidth, imgHeight, buttonLink, imagesCount, downloadCount) {
            totalPages = imagesCount

            var image = Qt.createComponent("ChapterImage.qml")
            image = image.createObject(column)

            image.realWidth = imgWidth
            image.realHeight = imgHeight
            image.index = setIndex
            image.imagePath = images
            setIndex++
        }
    }

    onDraggingChanged: {
        focus = true
        mouseArea.cursorShape = dragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
    }
    onContentHeightChanged: {
        newYPosition = contentY / contentHeight
        contentY = oldYPosition * contentHeight
    }
    onContentYChanged: {
        if (contentY != ~~contentY || (mouseArea.usingMouse && contentY != ~~contentY)) {
            oldYPosition = contentY / contentHeight
        }
    }

    function zoomOut() {
        if (column.width >= reader.width * 0.25) {
            if (column.width > adjustToWidth) {
                zoomOutAdjust = true
            }
            if (column.width * 0.75 < reader.width && zoomOutAdjust) {
                column.width = Qt.binding(function() {return adjustToWidth})
                zoomOutAdjust = false
            }
            else {
                column.width *= 0.75
            }
        }
    }
    function zoomIn() {
        if (column.width <= reader.width * 2) {
            if (column.width < adjustToWidth) {
                zoomInAdjust = true
            }
            if (column.width * 1.25 > reader.width && zoomInAdjust) {
                column.width = Qt.binding(function() {return adjustToWidth})
                zoomInAdjust = false
            }
            else {
                column.width *= 1.25
            }
        }
    }

    function nextPage() {
        toContentY = column.children[currentIndex + 1].y + 1
        contentYAnimation.start()
    }
    function previousPage() {
        toContentY = column.children[currentIndex - 1].y + 1
        contentYAnimation.start()
    }
    function goToPage(page) {
        contentY = column.children[page - 1].y
    }
}