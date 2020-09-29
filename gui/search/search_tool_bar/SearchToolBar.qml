import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Rectangle {
    property int toolbarHeight: 48
    property int searchInputRadius: 5
    property int iconSize: 24
    z: 1
    id: toolBar
    width: parent.width
    height: toolbarHeight
    color: surfaceColor

    Row {
        width: parent.width
        layoutDirection: Qt.RightToLeft
        MenuButton {}
        SearchButton {}

        Rectangle {
            width: parent.width - normalSpacing - toolBar.height * 2
            height: toolBar.height - normalSpacing
            color: textAreaColor
            radius: searchInputRadius
            anchors.verticalCenter: parent.verticalCenter

            TextInput {
                id: searchInput
                width: parent.width
                height: parent.height

                leftPadding: normalSpacing
                rightPadding: normalSpacing

                color: textColor
                font.pixelSize: normalTextFontSize
                verticalAlignment: Text.AlignVCenter
                clip: true

                Label {
                    id: placeHolderText
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

                onAccepted: advancedSearch.genSearchData(true)
            }
        }
    }


	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		acceptedButtons: Qt.NoButton 
	}
}
