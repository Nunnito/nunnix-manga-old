import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    property alias searchTextInput: searchTextInput
    property alias label: label
    property alias background: background
    property alias textInput: textInput
    property alias placeHolder: placeHolder
    property alias mouseArea: mouseArea
    property alias rectPlaceHolder: rectPlaceHolder
    property alias rectTextFocus: rectTextFocus
    property alias focusAnimation: focusAnimation
    property alias placeHolderAnimation: placeHolderAnimation

    property string searchParameter
    property var currentValue: textInput.text ? textInput.text : ""

    id: searchTextInput
    Material.background: surfaceColor
    topPadding: label.text ? normalSpacing : 0

    Label {
        id: label
        color: textColor

        font.pixelSize: normalTextFontSize
        font.bold: true
    }

    Rectangle {
        id: background

        width: controlWidth
        height: textInput.height

        radius: rectSearchTextRadius
        color: surfaceColor2

        anchors.horizontalCenter: parent.horizontalCenter

        TextInput {
            id: textInput

            width: controlWidth
            height: searchTextInputHeight

            leftPadding: normalSpacing / 2
            rightPadding: normalSpacing / 2

            clip: true
            color: textColor
            text: searchToolBar.searchLineEdit.searchInput.text

            font.pixelSize: normalTextFontSize
            verticalAlignment: TextInput.AlignVCenter

            Label {
                id: placeHolder
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
                id: mouseArea

                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                acceptedButtons: Qt.NoButton
            }

            onAccepted: genSearchData(true)
        }
    }
    
    Rectangle {
        id: rectPlaceHolder

        color: placeHolderColor
        width: textInput.width
        height: startBottomRectSearchTextHeight

        Rectangle {
            id: rectTextFocus

            height: endBottomRectSearchTextHeight
            color: primaryColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    NumberAnimation {
        id: focusAnimation
        property: "width"

        target: rectTextFocus
        duration: 100
        running: textInput.focus

        from: 0
        to: textInput.width
    }
    NumberAnimation {
        id: placeHolderAnimation
        property: "width"

        target: rectTextFocus
        duration: 100
        running: !textInput.focus

        from: textInput.width
        to: 0
    }

    function setDefault() {}
}