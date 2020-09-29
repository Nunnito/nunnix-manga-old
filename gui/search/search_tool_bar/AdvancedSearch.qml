import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Popup {
    width: 250 + normalSpacing
    height: parent.height

    modal: true

    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: controlsColumn.height + titleBar.height

        ScrollIndicator.vertical: ScrollIndicator {active: true}
        clip: true

        Label {
            text: qsTr("Advanced Search")
            color: primaryColor
            font.pixelSize: normalTextFontSize
            font.bold: true
            
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            id: controlsColumn
            topPadding: normalSpacing * 2
            padding: normalSpacing

        }

        Button {
            text: qsTr("Search")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            highlighted: true

            contentItem: Text {
                text: parent.text  
                color: backgroundColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }

            onClicked: genSearchData(true)
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

                    textInput.children[0].text = controls[control].name
                    textInput.searchParameter = controls[control].search_parameter
                }
                if (controls[control].type == "combobox") {
                    var comboBox = searchComboBox.createObject(controlsColumn)
                    var comboModel = []

                    comboBox.children[0].text = controls[control].name
                    comboBox.searchParameter = controls[control].search_parameter
                    comboBox.jsonData = controls[control].content
                }
                if (controls[control].type == "checkcombobox") {
                    var checkComboBox = searchCheckComboBox.createObject(controlsColumn)
                    var comboModel = []

                    checkComboBox.children[0].text = controls[control].name
                    checkComboBox.children[1].displayText = controls[control].combo_name
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

    function genSearchData(initPage) {
        if (initPage) {
            currentPage = 1
            var gridSearch = searcherFlickable.children[0].children[0].children[0]
            
            for (var i=0; i < gridSearch.children.length; i++){
                gridSearch.children[i].destroy()
            }
            searcherFlickable.children[0].children[1].running = true
        }

        searchData = {}
        for (var i=0; i < controlsColumn.children.length; i++) {
            var key = controlsColumn.children[i].searchParameter
            var value = controlsColumn.children[i].currentValue

            searchData[key] = value
        }
        print(JSON.stringify(searchData))
        NunnixManga.search_manga(JSON.stringify(searchData), currentPage)
        currentPage += 1
    }
}