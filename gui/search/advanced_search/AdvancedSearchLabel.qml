import QtQuick 2.15
import QtQuick.Controls 2.15

Label {
    property alias label: label

    id: label

    text: qsTr("Advanced Search")
    color: primaryColor

    font.pixelSize: normalTextFontSize
    font.bold: true
    
    anchors.horizontalCenter: parent.horizontalCenter
}