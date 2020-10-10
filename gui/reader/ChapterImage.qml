import QtQuick 2.15
import QtQuick.Controls 2.15

Image {
    property int index
    property int realWidth
    property int realHeight

	property int widthResizePercentage: width / sourceSize.width * 100
	property int heightResized: widthResizePercentage * sourceSize.height / 100

    // property var buttons: column.children
    // property int previousMinInt: buttons[index + 1] != null ? buttons[index + 1].y : 0
    // property int previousMaxInt: buttons[index + 2] != null ? buttons[index + 2].y : 0

    // property int currentMinInt: buttons[index].y
    // property int currentMaxInt: index + 1 != buttons.length - 1 ? buttons[index + 1].y : buttons[index].y + height

    // property int nextMinInt: buttons[index - 1] != null ? buttons[index - 1].y : 0
    // property int nextMaxInt: buttons[index].y

    // property bool isPreviousItem: swipeReader.contentY >= previousMinInt && swipeReader.contentY <= previousMaxInt
    // property bool isCurrentItem: swipeReader.contentY >= currentMinInt && swipeReader.contentY <= currentMaxInt
    // property bool isNextItem: swipeReader.contentY >= nextMinInt && swipeReader.contentY <= nextMaxInt
    
    Button {
        onClicked: {
            parent.sourceSize.width = 250
            parent.sourceSize.height = 250
            print(realWidth, realHeight)


            // print(currentMaxInt, parent.height, currentMinInt, isCurrentItem, buttons[index + 1].y)
            // for (var i=0; i < column.children.length - 1; i++) {
                // print(column.children[i].isPreviousItem, column.children[i].isCurrentItem, column.children[i].isNextItem)
            // }
        }
    }
    id: image
    width: reader.width
    height: heightResized

    onStatusChanged: {
        if (status == 1) {
            realWidth = sourceSize.width
            realHeight = sourceSize.height
        }
    }
}
