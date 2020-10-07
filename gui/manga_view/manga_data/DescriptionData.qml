import QtQuick 2.15
import QtQuick.Controls 2.15
Column {
    property alias descriptionData: descriptionData
    property alias label: label
    property alias flickable: flickable
    property alias description: description

    property string descriptionText: descriptionText

    id: descriptionData
    width: parent.width

    Label {
        id: label
        text: qsTr("Description")

        font.pixelSize: normalTextFontSize
        font.bold: true

        topPadding: normalSpacing / 2
        opacity: description.text ? 1 : 0
    }

    Flickable {
        id: flickable

        width: parent.width
        height: image.height - (parent.y + label.height)

        clip: true
        contentHeight: description.height
        boundsBehavior: Flickable.OvershootBounds
        rightMargin: normalSpacing

        ScrollIndicator.vertical: ScrollIndicator {active: true}

        Label {
            id: description
            text: descriptionText

            color: textColor
            width: parent.width

            wrapMode: Text.WordWrap
            font.pixelSize: normalTextFontSize
        }

        Column {
            spacing: 5

            // Repeater {
                // model: 3

                LoaderPlaceHolder {
                    width: descriptionData.width - normalSpacing
                    height: 100
                    gradient.width: width - 100
                    interval: 500
                    visible: !description.text
                }
            // }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            propagateComposedEvents: true

            onEntered: {
                if (flickable.contentHeight > flickable.height) {
                    flickableView.interactive = false
                }
            }
        }
    }

    OpacityAnimator {id: opacityAnim; target: descriptionData; from: 0; to: 1; duration: animTime}
    onDescriptionTextChanged: opacityAnim.start()
}