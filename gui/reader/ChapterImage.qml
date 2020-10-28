import QtQuick 2.15
import QtQuick.Controls 2.15

Image {
    property int index
    property int realWidth
    property int realHeight
    property bool catchRealSize: true

	property int widthResizePercentage: width / realWidth * 100
	property int heightResized: widthResizePercentage * realHeight / 100

    property var buttons: column.children
    property int previousMinInt: buttons[index + 1] != null ? buttons[index + 1].y : -1
    property int previousMaxInt: buttons[index + 2] != null ? buttons[index + 2].y : buttons[index + 1] != null ? buttons[index + 1].y + buttons[index + 1].height : -1

    property int currentMinInt: buttons[index].y
    property int currentMaxInt: index != buttons.length - 1 ? buttons[index + 1].y : buttons[index].y + height

    property int nextMinInt: buttons[index - 1] != null ? buttons[index - 1].y : 0
    property int nextMaxInt: buttons[index].y

    property bool isPreviousItem: swipeReader.contentY >= previousMinInt && swipeReader.contentY <= previousMaxInt
    property bool isCurrentItem: swipeReader.contentY >= currentMinInt && swipeReader.contentY <= currentMaxInt
    property bool isNextItem: swipeReader.contentY >= nextMinInt && swipeReader.contentY <= nextMaxInt

    property bool isHD: isPreviousItem || isCurrentItem || isNextItem
    property bool isNoHD: !isPreviousItem && !isCurrentItem && !isNextItem
    
    id: image
    width: reader.width
    height: heightResized
    asynchronous: true

    Button {onClicked: {for(var i=0;i<column.children.length;i++){print(column.children[i].sourceSize)}}}

    onStatusChanged: {
        if (status == 1) {
            if (catchRealSize) {
                realWidth = sourceSize.width
                realHeight = sourceSize.height
                catchRealSize = false
            }
        }
    }

    onIsPreviousItemChanged: {
        if (status == 1) {
            if (isPreviousItem) {
                sourceSize = Qt.size(realWidth, realHeight)
            }
            if (!isPreviousItem && !isCurrentItem && !isNextItem) {
                sourceSize = Qt.size(realWidth / 100, realHeight / 100)
            }
        }
    }
    onIsCurrentItemChanged: {
        if (status == 1) {
            if (isCurrentItem) {
                sourceSize = Qt.size(realWidth, realHeight)
            }
            if (!isPreviousItem && !isCurrentItem && !isNextItem) {
                sourceSize = Qt.size(realWidth / 100, realHeight / 100)
            }
        }
    }
    onIsNextItemChanged: {
        if (status == 1) {
            if (isNextItem) {
                sourceSize = Qt.size(realWidth, realHeight)
            }
            if (!isPreviousItem && !isCurrentItem && !isNextItem) {
                sourceSize = Qt.size(realWidth / 100, realHeight / 100)
            }
        }
    }
}
