import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    id: flickable
    Button {onClicked: print(index == currentIndex)}

    width: reader.width
    height: reader.height
    boundsBehavior: Flickable.StopAtBounds
    interactive: index == currentIndex
    Image {
        id: image
        source: listImages == null ? "" : listImages[index]

        Component.onCompleted: console.log("created:", index)
        Component.onDestruction: console.log("destroyed:", index)

        onStatusChanged: {
            if (status == 1) {
                flickable.contentHeight = sourceSize.height
            }
        }
    }
}
