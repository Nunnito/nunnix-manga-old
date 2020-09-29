import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    Material.background: surfaceColor
    topPadding: text.text ? normalSpacing : 0

    Text {
        id: text

        font.pixelSize: normalTextFontSize
        font.bold: true
        color: textColor
    }

    ComboBox {
        property string searchParameter
        id: comboBox
        width: 200

        delegate: ItemDelegate {
            width: comboBox.width
            height: 48
            contentItem: Row {
                CheckBox {
                    height: parent.height
                    width: height

                    onCheckedChanged: {}
                }
                Label {
                    text: modelData
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
    }
}