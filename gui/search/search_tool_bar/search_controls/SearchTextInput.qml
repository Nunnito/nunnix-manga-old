import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    property string searchParameter
    property var currentValue: textInput.text ? textInput.text : ""
    Material.background: surfaceColor
    topPadding: text.text ? normalSpacing : 0

    Text {
        id: text

        font.pixelSize: normalTextFontSize
        font.bold: true
        color: textColor
    }

    Rectangle {
        width: 200
        height: textInput.height
        color: surfaceColor2
        radius: 2
        anchors.horizontalCenter: parent.horizontalCenter

        TextInput {
            id: textInput
            width: 200
            height: 32

            leftPadding: normalSpacing / 2
            rightPadding: normalSpacing / 2

            text: searchToolBar.children[0].children[2].children[0].text
            color: textColor
            font.pixelSize: normalTextFontSize
            verticalAlignment: TextInput.AlignVCenter
            clip: true

            Label {
                id: placeHolderText
                text: qsTr("Search here...")

                width: parent.width
                height: parent.height

                leftPadding: normalSpacing / 2
                rightPadding: normalSpacing / 2

                visible: !parent.text
                color: placeHolderColor
                font.pixelSize: normalTextFontSize
                verticalAlignment: TextInput.AlignVCenter
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                acceptedButtons: Qt.NoButton
            }

            onAccepted: genSearchData(true)
        }
    }
    
    Rectangle {
        id: rectPlaceHolder
        width: textInput.width
        height: 2
        color: placeHolderColor
        Rectangle {
            id: rectTextFocus
            height: 3
            color: primaryColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    NumberAnimation {
        duration: 100
        target: rectTextFocus
        running: textInput.focus
        property: "width"
        from: 0
        to: textInput.width
    }
    NumberAnimation {
        duration: 100
        target: rectTextFocus
        running: !textInput.focus
        property: "width"
        from: textInput.width
        to: 0
    }
}