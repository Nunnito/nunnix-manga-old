import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    // Search slider alias.
    property alias searchSlider: searchSlider
    property alias label: label
    property alias slider: slider
    property alias mouseArea: mouseArea

    // Search slider properties.
    property string searchParameter
    property var jsonData
    property var currentValue: slider.value
    property bool grabLastIndex: true
    property int lastIndexOfLabel

    id: searchSlider
    topPadding: label.text ? normalSpacing : 0

    // Search slider title.
    Label {
        id: label
        color: textColor

        font.pixelSize: normalTextFontSize
        font.bold: true
    }

    // Slider.
    Slider {
        id: slider
        width: controlWidth

        onValueChanged: updateText()
        onToChanged: updateText()

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }
    
    // Update label text.
    function updateText() {
        if (grabLastIndex) {
            lastIndexOfLabel = label.text.length
            grabLastIndex = false
        }
        label.text = label.text.substring(0, lastIndexOfLabel) + slider.value
    }

    function setDefault() {
        slider.value = 0
    }
}