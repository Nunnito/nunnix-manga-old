import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    // Advanced search alias.
    property alias advancedSearch: advancedSearch
    property alias label: label
    property alias button: button

    property alias flickable: flickable
    property alias columnControls: columnControls

    id: advancedSearch

    // Advanced search properties.
    modal: true

    width: advancedSearchWidth
    height: parent.height

    // Flickable to scroll.
    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentHeight: columnControls.height + titleBar.height
        maximumFlickVelocity: normalMaximumFlickVelocity
        flickDeceleration: normalFlickDeceleration

        // Scroll indicator.
        ScrollIndicator.vertical: ScrollIndicator {active: true}
        clip: true

        AdvancedSearchLabel {id: label}  // AdvancedSearchLabel

        // Here are all the controls.
        Column {
            id: columnControls

            topPadding: normalSpacing * 2
            padding: normalSpacing

        }

        AdvancedSearchButton {id: button}  // AdvancedSearchButton
    }

    // Overlay modal color.
    Overlay.modal: Rectangle {
        color: modalColor
    }

    Connections {
        target: MangaSearcher
        function onSearch_manga_controls(jsonControls) {
            var controls = JSON.parse(jsonControls)
            
            var searchTextInput = Qt.createComponent("search_controls/SearchTextInput.qml")
            var searchComboBox = Qt.createComponent("search_controls/SearchComboBox.qml")
            var searchCheckComboBox = Qt.createComponent("search_controls/SearchCheckComboBox.qml")
            var searchSlider = Qt.createComponent("search_controls/SearchSlider.qml")

            for (var i=0; i < columnControls.children.length; i++){
                columnControls.children[i].destroy()
            }
            columnControls.children.length = 0

            for (var control in controls) {
                // Creates TextInput control.
                if (controls[control].type == "textinput") {
                    var textInput = searchTextInput.createObject(columnControls)

                    textInput.visible = controls[control].visible
                    textInput.label.text = controls[control].name
                    textInput.searchParameter = controls[control].search_parameter
                }
                // Creates ComboBox control.
                if (controls[control].type == "combobox") {
                    var comboBox = searchComboBox.createObject(columnControls)
                    var comboModel = []

                    comboBox.label.text = controls[control].name
                    comboBox.searchParameter = controls[control].search_parameter
                    comboBox.jsonData = controls[control].content
                }
                // Creates CheckComboBox control.
                if (controls[control].type == "checkcombobox") {
                    var checkComboBox = searchCheckComboBox.createObject(columnControls)
                    var comboModel = []

                    checkComboBox.label.text = controls[control].name
                    checkComboBox.comboBox.displayText = controls[control].combo_name
                    checkComboBox.searchParameter = controls[control].search_parameter
                    checkComboBox.jsonData = controls[control].content
                }
                // Creates Slider control.
                if (controls[control].type == "slider") {
                    var slider = searchSlider.createObject(columnControls)
                    var comboModel = []

                    slider.label.text = controls[control].name
                    slider.slider.from = controls[control].from
                    slider.slider.to = controls[control].to
                    slider.slider.stepSize = controls[control].stepSize
                    slider.searchParameter = controls[control].search_parameter
                    slider.jsonData = controls[control].content
                }
            }
        }
    }

    // Enter advanced search animation.
    enter: Transition {
        NumberAnimation {
            duration: 100
            property: "x"
            from: advancedSearchEndX
            to: advancedSearchStartX
        }
    }

    // Exit advanced search animation.
    exit: Transition {
        NumberAnimation {
            duration: 100
            property: "x"
            from: advancedSearchStartX
            to: advancedSearchEndX
        }
    }

    // Advanced search background.
    background: Rectangle {
        color: backgroundColor
    }
}