import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property alias searchLineEdit: searchLineEdit
    property alias searchInput: searchInput
    property alias placeHolder: placeHolder

    id: searchLineEdit

    width: parent.width - normalSpacing - searchToolBar.height * 2
    height: searchToolBar.height - normalSpacing

    color: textAreaColor
    radius: searchInputRadius

    anchors.verticalCenter: parent.verticalCenter

    TextInput {
        id: searchInput

        width: parent.width
        height: parent.height

        leftPadding: normalSpacing
        rightPadding: normalSpacing

        clip: true
        color: textColor

        font.pixelSize: normalTextFontSize
        verticalAlignment: Text.AlignVCenter

        Label {
            id: placeHolder

            text: qsTr("Search here...")

            width: parent.width
            height: parent.height

            leftPadding: normalSpacing
            rightPadding: normalSpacing

            visible: !parent.text
            color: placeHolderColor

            font.pixelSize: normalTextFontSize
            verticalAlignment: Text.AlignVCenter
        }

        onAccepted: {
            resetFilters()
            genSearchData(true)
        }
    }
}