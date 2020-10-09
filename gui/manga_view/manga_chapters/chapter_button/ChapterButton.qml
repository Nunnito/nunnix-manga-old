import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15

ItemDelegate {
    property alias chapterButton: chapterButton
    property alias contextMenu: contextMenu

    property string chapterName
    property string chapterDate
    property string chapterLink

    property bool downloaded
    property bool downloading
    property bool read
    property bool bookmarked

    property string buttonColor: textColor

    Material.background: surfaceColor

    id: chapterButton
    width: parent.width
    height: normalSpacing * 4 - normalSpacing / 2

    text: chapterName

    contentItem: Label {
        text: chapterButton.text
        color: buttonColor

        font.pixelSize: normalTextFontSize
        elide: Text.ElideRight
        leftPadding: normalSpacing / 4

        // Date
        Label {
            text: chapterButton.chapterDate
            color: buttonColor
            font.pixelSize: smallTextFontSize

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            leftPadding: normalSpacing / 4
        }

        RoundButton {
            enabled: false
            flat: true
            icon.source: "../../../../resources/bookmark.svg"
            icon.color: primaryColor
            icon.width: iconSize
            icon.height: iconSize
            x: parent.contentWidth
            y: -15
        }
    }

    // Separator
    Rectangle {
        width: parent.width
        height: 1
        color: parent.pressed ? primaryColor : surfaceColor4
        y: parent.height
    }

    ContextMenu {id: contextMenu}


    MouseArea {
        id: mouseArea
    
        width: parent.width
        height: parent.height
        acceptedButtons: Qt.RightButton
        onPressed: {
            if (mouse.button == Qt.RightButton) {
                contextMenu.popup()
                acceptedButtons = Qt.LeftButton | Qt.RightButton
            }
            if (mouse.button == Qt.LeftButton) {
                contextMenu.dismiss()
            }
        }
    }


    onClicked: {
        stackView.push("../../reader/Reader.qml")
        MangaReader.set_images(chapterLink, mangaName, chapterName)
    }

    onReadChanged: {
        if (read) {
            buttonColor = surfaceColor4
        }
        else {
            buttonColor = textColor
        }
    }
}