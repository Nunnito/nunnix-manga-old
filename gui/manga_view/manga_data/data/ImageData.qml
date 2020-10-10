import QtQuick 2.15
import QtQuick.Controls 2.15

// Manga image
Image {
    property alias image: image
    property alias rectPlaceHolder: rectPlaceHolder
    property alias busyIndicator: busyIndicator
    id: image

    width: imageWidth
    height: imageHeight
    fillMode: Image.PreserveAspectCrop

    
    Rectangle {
        id: rectPlaceHolder
        anchors.fill: parent
        color: surfaceColor2
        visible: image.status == 1 ? 0:1
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: image.status == 1 ? 0:1
    }

    OpacityAnimator {id: opacityAnim; target: image; from: 0; to: 1; duration: animTime}

    onStatusChanged: {
        if (status == 1) {
            opacityAnim.start()
        }
    }
}