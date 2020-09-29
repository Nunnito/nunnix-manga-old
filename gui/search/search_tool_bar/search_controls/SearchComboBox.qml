import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    property string searchParameter
    property var jsonData
    property var currentValue: jsonData == null ? [] : jsonData[comboBox.currentText]
    Material.background: surfaceColor
    topPadding: text.text ? normalSpacing : 0

    Text {
        id: text

        font.pixelSize: normalTextFontSize
        font.bold: true
        color: textColor
    }

    ComboBox {
        id: comboBox
        width: 200
        model: jsonData == null ? [] : Object.keys(jsonData)

        popup: Popup {
            width: comboBox.width
            implicitHeight: contentItem.implicitHeight >= mainWindow.minimumHeight ? mainWindow.minimumHeight - titleBar.height : contentItem.implicitHeight
            padding: 0

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }
}