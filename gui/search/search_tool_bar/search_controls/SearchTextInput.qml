import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    Material.background: surfaceColor
    topPadding: text.text ? normalSpacing : 0

    Text {
        id: text

        font.pixelSize: normalTextFontSize
        color: textColor
    }

    TextInput {
        property string searchParameter
        id: textInput
        width: 200

        color: textColor
        font.pixelSize: normalTextFontSize
        verticalAlignment: Text.AlignVCenter
        clip: true

        Label {
            id: placeHolderText
            text: qsTr("Search here...")

            width: parent.width
            height: parent.height

            visible: !parent.text
            color: placeHolderColor
            font.pixelSize: normalTextFontSize
            verticalAlignment: Text.AlignVCenter
        }
    }
    
    Rectangle {
        id: rectPlaceHolder
        width: textInput.width
        height: 3
        color: textInput.focus ? accentColor : placeHolderColor
    }
}