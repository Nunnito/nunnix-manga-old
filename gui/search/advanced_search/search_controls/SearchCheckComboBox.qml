import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    property alias searchCheckComboBox: searchCheckComboBox
    property alias label: label
    property alias comboBox: comboBox
    property alias mouseArea: mouseArea

    property string searchParameter
    property var jsonData
    property var currentValue: []

    id: searchCheckComboBox
    Material.background: surfaceColor
    topPadding: label.text ? normalSpacing : 0

    Label {
        id: label
        color: textColor

        font.pixelSize: normalTextFontSize
        font.bold: true
    }

    ComboBox {
        property var checkedList: []
        id: comboBox

        width: controlWidth
        model: jsonData == null ? [] : Object.keys(jsonData)

        delegate: Item {
            width: comboBox.width
            implicitHeight: checkDelegate.implicitHeight

            CheckDelegate {
                id: checkDelegate

                width: parent.width
                text: modelData
                checked: comboBox.checkedList.includes(text)

                onCheckedChanged: {
                    if (checked && !comboBox.checkedList.includes(text)) {
                        currentValue.push(jsonData[text])
                        comboBox.checkedList.push(text)
                        comboBox.currentIndex = index
                    }
                    if (!checked && comboBox.checkedList.includes(text)) {
                        currentValue.splice(currentValue.indexOf(jsonData[text]))
                        comboBox.checkedList.splice(comboBox.checkedList.indexOf(text))
                    }
                }
            }
        }

        popup: Popup {
            width: comboBox.width
            padding: 0

            implicitHeight: contentItem.implicitHeight >= mainWindow.minimumHeight ? mainWindow.minimumHeight - titleBar.height : contentItem.implicitHeight

            contentItem: ListView {
                clip: true

                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
        
        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }
}