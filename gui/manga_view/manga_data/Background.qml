import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    property alias background: background
    property alias gradientBackground: gradientBackground
    property alias gradientPlaceHolder: gradientPlaceHolder
    property alias fastBlur: fastBlur

    width: parent.width
    
    Image {
        id: background

        width: parent.width
        height: imageHeight + row.padding * 3

        source: image.source
        fillMode: Image.PreserveAspectCrop
        
        Rectangle {
            id: gradientBackground
            anchors.fill: parent

            gradient: Gradient {
                GradientStop { position: 0.6; color: "#CC000000"}
                GradientStop { position: 0.9; color: backgroundColor}
                GradientStop { position: 1.0; color: backgroundColor}
            }
        }

        Rectangle {
            id: gradientPlaceHolder

            anchors.fill: parent
            visible: image.status == 1 ? 0:1

            gradient: Gradient {
                GradientStop { position: 0.6; color: surfaceColor}
                GradientStop { position: 0.9; color: backgroundColor}
                GradientStop { position: 1.0; color: backgroundColor}
            }
        }
    }

    FastBlur {
        id: fastBlur

        width: background.width
        height: background.height
        source: background
        radius: 32
    }
}