import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    width: 250 + normalSpacing
    height: parent.height

    modal: true

    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: controlsColumn.height + titleBar.height

        ScrollIndicator.vertical: ScrollIndicator {}
        clip: true

        Label {
            text: qsTr("Advanced Search")
            color: accentColor
            font.pixelSize: normalTextFontSize
            font.bold: true
            
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            id: controlsColumn
            topPadding: normalSpacing * 2
            padding: normalSpacing

        }
    }

    Overlay.modal: Rectangle {
        color: "#AA000000"
    }

    Connections {
        target: NunnixManga
        function onSearch_manga_controls(jsonControls) {
            var controls = JSON.parse(jsonControls)
            
            var searchTextInput = Qt.createComponent("search_controls/SearchTextInput.qml")
            var searchComboBox = Qt.createComponent("search_controls/SearchComboBox.qml")
            var searchCheckComboBox = Qt.createComponent("search_controls/SearchCheckComboBox.qml")

            for (var control in controls) {
                if (controls[control].type == "textinput") {
                    var textInput = searchTextInput.createObject(controlsColumn)
                }
                if (controls[control].type == "combobox") {
                    var comboBox = searchComboBox.createObject(controlsColumn)
                    var comboModel = []

                    comboBox.children[0].text = controls[control].name
                    comboBox.children[1].searchParameter = controls[control].search_parameter
                    
                    for (var content in controls[control].content) {
                        comboModel.push(content)
                    }
                    comboBox.children[1].model = comboModel
                }
                if (controls[control].type == "checkcombobox") {
                    var checkComboBox = searchCheckComboBox.createObject(controlsColumn)
                    var comboModel = []

                    checkComboBox.children[0].text = controls[control].name
                    checkComboBox.children[1].displayText = controls[control].combo_name
                    checkComboBox.children[1].searchParameter = controls[control].search_parameter

                    for (var content in controls[control].content) {
                        comboModel.push(content)
                    }
                    checkComboBox.children[1].model = comboModel
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation {
            duration: 100
            property: "x"
            from: advancedSearchEndX
            to: advancedSearchStartX
        }
    }

    exit: Transition {
        NumberAnimation {
            duration: 100
            property: "x"
            from: advancedSearchStartX
            to: advancedSearchEndX
        }
    }

    background: Rectangle {
        color: backgroundColor
    }
}