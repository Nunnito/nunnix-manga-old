import QtQuick 2.15

MouseArea {
    property bool usingMouse: false
    property bool useContentX: false

    property real toContentY: 0

    id: mouseArea

    z: -1
    anchors.fill: parent

    onWheel: {
        if (!(wheel.modifiers & Qt.ControlModifier)) {
            if (wheel.angleDelta.y % 120 == 0 && wheel.angleDelta.y != 0) {
                if (contentYAnimation.running) {
                    contentYAnimation.stop()
                    toContentY -= wheel.angleDelta.y + 0.1
                }
                else {
                    toContentY = parent.contentY - wheel.angleDelta.y + 0.1
                }
                contentYAnimation.start()
                usingMouse = true
            }
            else {
                usingMouse = false
                parent.contentY -= wheel.angleDelta.y / moveFlickable
                if (useContentX) {
                    parent.contentX -= wheel.angleDelta.x / moveFlickable
                }
            }
        }
    }

    PropertyAnimation {id: contentYAnimation; target: parent; property: "contentY"; to: toContentY; duration: 100}
}