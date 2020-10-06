import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    width: parent.width
    
    Image {
        id: background

        width: parent.width
        height: imageHeight + row.padding * 3

        source: image.source
        fillMode: Image.PreserveAspectCrop
        
        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop { position: 0.6; color: "#CC000000"}
                GradientStop { position: 0.9; color: backgroundColor}
                GradientStop { position: 1.0; color: backgroundColor}
            }
        }
    }

    FastBlur {
        width: background.width
        height: background.height
        source: background
        radius: 32
    }
}