import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    width: mainWindow.width / 2
    height: parent.height

    modal: true

    Column {
        id: controlsColumn
        padding: normalSpacing
    }

    Overlay.modal: Rectangle {
        color: "#AA000000"
    }

    Connections {
        target: NunnixManga
        function onSearch_manga_controls(jsonControls) {
            var controls = JSON.parse(jsonControls)
            
            var searchComboBox = Qt.createComponent("search_controls/SearchComboBox.qml")

            for (var control in controls) {
                if (controls[control].type == "combobox"){
                    var comboBox = searchComboBox.createObject(controlsColumn)
                    var comboModel = []

                    comboBox.children[0].text = controls[control].name
                    comboBox.children[1].searchParameter = controls[control].search_parameter
                    
                    for (var content in controls[control].content) {
                        comboModel.push(content)
                    }
                    comboBox.children[1].model = comboModel
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