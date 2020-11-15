import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: controlsBar

    width: reader.width
    height: 35
    color: surfaceColor

    Row {
        x: parent.width / 2 - (width / 2)

        Button {
            id: slidePrevious
            enabled: currentIndex != 0

            y: (controlsBar.height / 2) - (height / 2)
            flat: true
            icon.source: "../../resources/slide_previous.svg"

            onClicked: swipeReader.previousPage()
        }

        Rectangle {
            id: textInputBackground

            width: 64
            height: 30

            y: (controlsBar.height - height) / 2
            color: surfaceColor2

            radius: 3
            border.width: 1
            border.color: surfaceColor4


            TextInput {
                id: textInput

                width: parent.width
                height: parent.height

                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                text: currentIndex + 1
                validator: IntValidator {bottom: 1; top: totalPages}

                font.pixelSize: normalTextFontSize
                color: textColor

                onAccepted: swipeReader.goToPage(text)

                onFocusChanged: {
                    if (focus) {
                        selectAll()
                        color1.start()
                    }
                    else {
                        color2.start()
                    }
                }
            }

            
            MouseArea {
                z: -1
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                hoverEnabled: true

                onEntered: color1.start()
                onExited: {
                    if (!textInput.focus) {
                        color2.start()
                    }
                }
            }
            

            PropertyAnimation {
                id: color1
                target: textInputBackground
                properties: "border.color"
                to: primaryColor
                duration: 100
            }
            PropertyAnimation {
                id: color2
                target: textInputBackground
                properties: "border.color"
                to: surfaceColor4
                duration: 100
            }

        }
        Label {
            width: 64

            text: "   " + qsTr("of") + "   " + totalPages

            y: (controlsBar.height / 2) - (height / 2)
            font.pixelSize: normalTextFontSize
            color: textColor
        }

        Button {
            id: slideNext
            enabled: currentIndex != totalPages - 1

            y: (controlsBar.height / 2) - (height / 2)
            flat: true
            icon.source: "../../resources/slide_next.svg"

            onClicked: swipeReader.nextPage()
        }
    }
}