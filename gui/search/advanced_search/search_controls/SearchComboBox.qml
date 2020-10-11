import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    // Search combo box alias.
    property alias searchComboBox: searchComboBox
    property alias label: label
    property alias comboBox: comboBox
    property alias mouseArea: mouseArea

    // Search combo box properties.
    property string searchParameter
    property var jsonData
    property var currentValue: jsonData == null ? [] : jsonData[comboBox.currentText]

    id: searchComboBox
    topPadding: label.text ? normalSpacing : 0

    // Search combo box title.
    Label {
        id: label
        color: textColor

        font.pixelSize: normalTextFontSize
        font.bold: true
    }

    // Combo box.
    ComboBox {
        id: comboBox
        Material.elevation: 2

        width: controlWidth
        model: jsonData == null ? [] : Object.keys(jsonData)

        // Custom combo box popup.
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