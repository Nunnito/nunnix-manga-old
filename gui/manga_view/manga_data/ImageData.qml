import QtQuick 2.15
import QtQuick.Controls 2.15

Image {
    id: image
    width: imageWidth
    height: imageHeight
    fillMode: Image.PreserveAspectCrop

    
    Rectangle {
        anchors.fill: parent
        color: surfaceColor2
        visible: image.status == 1 ? 0:1
    }

    BusyIndicator {
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