import QtQuick 2.15

MouseArea {
    property bool usingMouse: false
    property bool useContentX: false
    property bool moveHalfMouse: false

    property real toContentY: 0

    id: mouseArea

    z: -1
    anchors.fill: parent

    onWheel: {
        if (!(wheel.modifiers & Qt.ControlModifier)) {
            var mouseMove = wheel.angleDelta.y / (moveHalfMouse ? 2 : 1) + 0.1

            if (wheel.angleDelta.y % 120 == 0 && wheel.angleDelta.y != 0 && os != "win32") {
                if (contentYAnimation.running) {
                    contentYAnimation.stop()
                    toContentY -= mouseMove
                }
                else {
                    toContentY = parent.contentY - mouseMove
                }
                contentYAnimation.start()
                usingMouse = true
            }
            else {
                usingMouse = false
                parent.contentY -= (wheel.angleDelta.y / moveFlickable) + 0.1
                if (useContentX) {
                    parent.contentX -= (wheel.angleDelta.x / moveFlickable) + 0.1
                }
            }
        }
    }

    PropertyAnimation {
        id: contentYAnimation
        property: "contentY"

        target: parent
        to: toContentY
        duration: moveHalfMouse ? 200 : 100
    }
}