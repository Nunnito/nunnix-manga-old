import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    property alias searchComboBox: searchComboBox
    property alias label: label
    property alias comboBox: comboBox
    property alias mouseArea: mouseArea

    property string searchParameter
    property var jsonData
    property var currentValue: jsonData == null ? [] : jsonData[comboBox.currentText]

    id: searchComboBox
    Material.background: surfaceColor
    topPadding: label.text ? normalSpacing : 0

    Label {
        id: label
        color: textColor

        font.pixelSize: normalTextFontSize
        font.bold: true
    }

    ComboBox {
        id: comboBox

        width: controlWidth
        model: jsonData == null ? [] : Object.keys(jsonData)

        popup: Popup {
            width: comboBox.width
            padding: 0

            implicitHeight: contentItem.implicitHeight >= mainWindow.minimumHeight ? mainWindow.minimumHeight - titleBar.height : contentItem.implicitHeight

            contentItem: ListView {
                clip: true

                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }

    function setDefault() {
        comboBox.currentIndex = 0
    }
}