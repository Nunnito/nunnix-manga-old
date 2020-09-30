import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    property alias advancedSearch: advancedSearch
    property alias label: label
    property alias button: button

    property alias flickable: flickable
    property alias columnControls: columnControls

    property int controlWidth: 200
    property int searchTextInputHeight: 32
    property int rectSearchTextRadius: 5
    property int startBottomRectSearchTextHeight: 2
    property int endBottomRectSearchTextHeight: 3

    id: advancedSearch
    modal: true

    width: 250 + normalSpacing
    height: parent.height

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentHeight: columnControls.height + titleBar.height

        ScrollIndicator.vertical: ScrollIndicator {active: true}
        clip: true

        AdvancedSearchLabel {id: label}

        Column {
            id: columnControls

            topPadding: normalSpacing * 2
            padding: normalSpacing

        }

        AdvancedSearchButton {id: button}
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
                    var textInput = searchTextInput.createObject(columnControls)

                    textInput.label.text = controls[control].name
                    textInput.searchParameter = controls[control].search_parameter
                }
                if (controls[control].type == "combobox") {
                    var comboBox = searchComboBox.createObject(columnControls)
                    var comboModel = []

                    comboBox.label.text = controls[control].name
                    comboBox.searchParameter = controls[control].search_parameter
                    comboBox.jsonData = controls[control].content
                }
                if (controls[control].type == "checkcombobox") {
                    var checkComboBox = searchCheckComboBox.createObject(columnControls)
                    var comboModel = []

                    checkComboBox.label.text = controls[control].name
                    checkComboBox.comboBox.displayText = controls[control].combo_name
                    checkComboBox.searchParameter = controls[control].search_parameter
                    checkComboBox.jsonData = controls[control].content
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