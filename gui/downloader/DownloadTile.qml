import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    property alias dropArea: dropArea

    id: downloadItem

    width: parent.width
    height: normalSpacing * 4 - normalSpacing / 2

    ItemDelegate {
        id: downloadButton

        width: parent.width
        height: normalSpacing * 4 - normalSpacing / 2
        
        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: height / 2
        Drag.hotSpot.y: height / 2

        Image {
            id: dragButton

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            source: "../../resources/drag_indicator.svg"
            sourceSize.width: iconSize
            sourceSize.height: iconSize

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: placeHolderColor
            }

            MouseArea {
                id: dragArea

                cursorShape: containsPress ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                anchors.fill: parent

                drag.target: downloadButton
                drag.axis: Drag.YAxis
                drag.maximumY: listView.contentHeight - downloadButton.height - index * downloadButton.height
                drag.minimumY: 0 - index * downloadButton.height

                onReleased: {
                    downloads.move(index, dragTouching, 1)
                    downloadButton.y = 0
                }
                onPressed: dragIndex = index
            }

            states: [
                State {
                    when: dragArea.drag.active
                    name: "dragging"

                    PropertyChanges {
                        target: downloadButton
                        opacity: 0.75
                    }
                }
            ]
        }

        Rectangle {
            width: parent.width
            height: 1
            color: surfaceColor4
            y: parent.height
        }
    }

    DropArea {
        id: dropArea

        width: parent.width
        height: normalSpacing * 4 - normalSpacing / 2

        onEntered: dragTouching = index
    }
}
