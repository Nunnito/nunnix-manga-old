import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../../wheel_area"

// Description data
Column {
    property alias descriptionData: descriptionData
    property alias label: label
    property alias flickable: flickable
    property alias description: description

    property string descriptionText: descriptionText

    id: descriptionData
    width: parent.width

    // Title
    Label {
        id: label
        text: qsTr("Description")

        font.pixelSize: normalTextFontSize
        font.bold: true

        topPadding: normalSpacing / 2
        opacity: description.text ? 1 : 0
    }

    // Flickable, if there is no space available
    Flickable {
        id: flickable

        width: parent.width
        height: image.height - (parent.y + label.height)

        clip: true
        rightMargin: normalSpacing
        contentHeight: description.height

        boundsMovement: Flickable.StopAtBounds
        interactive: false

        ScrollIndicator.vertical: ScrollIndicator {active: true}

        // Description
        Label {
            id: description
            text: descriptionText

            color: textColor
            width: parent.width

            wrapMode: Text.WordWrap
            font.pixelSize: normalTextFontSize
        }

        LoaderPlaceHolder {
            width: descriptionData.width - normalSpacing
            height: 100
            visible: !description.text
        }
        WheelArea {
            enabled: flickable.contentHeight >= flickable.height ? true : false
            parent: flickable

            moveHalfMouse: true
            propagateComposedEvents: true
        }
    }

    OpacityAnimator {id: opacityAnim; target: descriptionData; from: 0; to: 1; duration: animTime}
    onDescriptionTextChanged: opacityAnim.start()
}
