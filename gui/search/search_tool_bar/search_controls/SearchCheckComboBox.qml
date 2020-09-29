import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    property string searchParameter
    property var jsonData
    property var currentValue: []
    Material.background: surfaceColor
    topPadding: text.text ? normalSpacing : 0

    Text {
        id: text

        font.pixelSize: normalTextFontSize
        font.bold: true
        color: textColor
    }

    ComboBox {
        property var checkedList: []
        id: comboBox
        width: 200
        model: jsonData == null ? [] : Object.keys(jsonData)

        delegate: ItemDelegate {
            width: comboBox.width
            height: 48
            contentItem: Row {
                CheckBox {
                    id: checkBox
                    height: parent.height
                    width: height
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
                Label {
                    text: checkBox.text
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }
        popup: Popup {
            width: comboBox.width
            implicitHeight: contentItem.implicitHeight >= mainWindow.minimumHeight ? mainWindow.minimumHeight - titleBar.height : contentItem.implicitHeight
            padding: 0

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }
}