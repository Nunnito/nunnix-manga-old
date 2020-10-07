import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property alias loader: loader
    property alias gradient: gradient
    property alias animation: animation

    property int interval: interval

    id: loader
    height: font.pixelSize

    color: surfaceColor2
    radius: 2
    clip: true
    
    Rectangle {
        id: gradient
        height: parent.height

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.1; color: surfaceColor2}
            GradientStop { position: 0.5; color: surfaceColor3}
            GradientStop { position: 1.0; color: surfaceColor2}
        }
    }
    SequentialAnimation {
        id: animation
        running: true
        loops: Animation.Infinite

        XAnimator {
            target: gradient
            from: -gradient.width
            to: loader.width
            duration: interval
        }
        PauseAnimation {duration: 500}
    }
}