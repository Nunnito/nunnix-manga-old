import QtQuick 2.15
import QtQuick.Controls 2.15
Column {
    property alias descriptionData: descriptionData
    property alias label: label
    property alias flickable: flickable
    property alias description: description

    id: descriptionData
    width: parent.width

    Label {
        id: label
        text: qsTr("Description")
        font.pixelSize: normalTextFontSize
        font.bold: true
        topPadding: normalSpacing / 2
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

            color: textColor
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: normalTextFontSize
        }
    }
}
