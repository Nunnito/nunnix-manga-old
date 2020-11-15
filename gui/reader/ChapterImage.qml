import QtQuick 2.15
import QtQuick.Controls 2.15

Image {
    property int index
    property bool loaded
    property string imagePath

    property int currentMinInt: y
    property int currentMaxInt: y + height + normalSpacing

    property bool isPreviousItem: currentIndex == index + 1
    property bool isNextItem: currentIndex == index - 1


    property bool isCurrentItem: {
        if (height < reader.height && swipeReader.contentY >= currentMinInt && swipeReader.contentY <= currentMaxInt) {
            return true
        }
        else if (height > reader.height && swipeReader.contentY >=
            currentMinInt && swipeReader.contentY <= currentMaxInt) {
                return true
        }
        else {
            return false
        }
    }

    property int realWidth
    property int realHeight

    property real aspectRatio: realWidth / realHeight
    property int newHeight: width / aspectRatio

    id: image
    asynchronous: true

    width: column.width
    height: newHeight
    x: column.width <= reader.width ? (reader.width / 2 - width) + (width / 2 - scrollBar.width / 2) : reader.x - scrollBar.width

    sourceSize: updateSourceSize()
    source: (isPreviousItem || isCurrentItem || isNextItem || currentIndex == index - 2) ? imagePath : ""

    onIsCurrentItemChanged: {
        if (isCurrentItem) {
            currentIndex = index
            pixelated.source = imagePath
        }
    }
    onStatusChanged: {
        if (status == 1 && !loaded) {
            loaded = true
        }
    }

    function updateSourceSize() {
        if ((isPreviousItem || isCurrentItem || isNextItem || currentIndex == index - 2)) {
                return Qt.size(width, height)
        }
        else {
            return Qt.size(realWidth / 100, realHeight / 100)
        }
    }

    Image {
        id: pixelated

        z: -1
        asynchronous: true
        fillMode: Image.PreserveAspectFit

        width: parent.width
        height: parent.height

        smooth: false
        sourceSize: Qt.size(100, 100)

        Rectangle {
            z: -2
            width: parent.width
            height: parent.height
            color: "white"
        }
    }
}
