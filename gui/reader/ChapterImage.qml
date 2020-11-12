import QtQuick 2.15
import QtQuick.Controls 2.15

Image {
    property bool loaded

    property int currentMinInt: y
    property int currentMaxInt: y + height + normalSpacing
    property bool isCurrentItem: swipeReader.contentY >= currentMinInt && swipeReader.contentY <= currentMaxInt

    property int realWidth
    property int realHeight
    property int index
    property int widthResizePercentage: width / realWidth * 100
    property int heightResized: widthResizePercentage * realHeight / 100

    id: image
    asynchronous: true

    width: reader.width
    height: heightResized

    sourceSize: {
        if ((currentIndex == index - 1 || currentIndex == index || currentIndex == index + 1)) {
            return Qt.size(realWidth, realHeight)
        }
        else {
            return Qt.size(realWidth / 100, realHeight / 100)
        }
    }

    onIsCurrentItemChanged: {
        if (isCurrentItem && status == 1) {
            currentIndex = index
        }
    }
    onStatusChanged: {
        if (status == 1 && !loaded) {
            loaded = true
        }
    }
}
