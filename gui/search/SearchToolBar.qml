import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Rectangle {
    property int toolbarHeight: 48 * scaleFactor
    property int searchInputRadius: 10
    z: 1
    id: toolBar
    width: parent.width
    height: toolbarHeight
    color: surfaceColor

    Row {
        width: parent.width
        layoutDirection: Qt.RightToLeft
        RoundButton {
            id: optionButton
            flat: true

            height: toolBar.height
            width: height

            icon.source: "../../resources/more_vert.svg"
            icon.color: iconColor

            onClicked: optionMenu.open()

            Menu {
                id: optionMenu

                MenuItem {
                    text: qsTr("Reload")
                }
                MenuItem {
                    text: qsTr("Advanced search")
                }
                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 40
                    color: surfaceColor2
                    radius: 2
                }
            }
        }
        RoundButton {
            id: searchButton
            flat: true

            height: toolBar.height
            width: height

            icon.source: "../../resources/search.svg"
            icon.color: iconColor

            onClicked: {
                if (!searchInput.text) {
                    searchInput.focus = true
                }
            }
        }
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
            }
        }
    }


	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		acceptedButtons: Qt.NoButton 
	}
}
