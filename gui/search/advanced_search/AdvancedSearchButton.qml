import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    property alias searchButton: searchButton
    property alias searchArea: searchArea
    property alias resetButton: resetButton
    property alias resetArea: resetArea

    width: parent.width
    spacing: normalSpacing / 2
    topPadding: normalSpacing * 2
    padding: normalSpacing
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
        id: searchButton

        text: qsTr("Search")
        width: advancedSearch.width / 2 - normalSpacing * 2
        highlighted: true

        contentItem: Text {
            text: parent.text  
            color: backgroundColor
            font.bold: true
            font.capitalization: Font.AllUppercase

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            id: searchArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }

        onClicked: genSearchData(true)
    }

    Button {
        id: resetButton
        text: qsTr("Reset")
        width: advancedSearch.width / 2 - normalSpacing * 2
        flat: true
        highlighted: true

        MouseArea {
            id: resetArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }

        onClicked: resetFilters()
    }
}