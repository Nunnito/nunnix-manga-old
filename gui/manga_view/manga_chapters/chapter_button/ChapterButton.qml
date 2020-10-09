import QtQuick 2.15
import QtGraphicalEffects 1.15
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
    property int index

    id: chapterButton
    width: parent.width
    height: normalSpacing * 4 - normalSpacing / 2

    text: chapterName

    contentItem: Item {

        Row {
            // Bookmark icon
            Image {
                visible: bookmarked

                sourceSize.width: iconSize
                sourceSize.height: iconSize
                source: "../../../../resources/bookmark.svg"

                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: primaryColor
                }
            }
            // Chapter name
            Label {
                id: name
                text: chapterButton.text
                color: buttonColor

                font.pixelSize: normalTextFontSize
                elide: Text.ElideRight
                leftPadding: normalSpacing / 4
            }
        }

        // Date
        Label {
            text: chapterButton.chapterDate
            color: buttonColor
            font.pixelSize: smallTextFontSize

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            leftPadding: normalSpacing / 4
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
        print(index)
        // stackView.push("../../../reader/Reader.qml")
        // MangaReader.set_images(chapterLink, mangaName, chapterName)
    }

    onReadChanged: {
        if (read) {
            buttonColor = surfaceColor4
        }
        else {
            if (bookmarked) {
                buttonColor = primaryColor
            }
            else {
                buttonColor = textColor
            }
        }
    }

    onBookmarkedChanged: {
        if (bookmarked) {
            if (!read) {
                buttonColor = primaryColor
            }
        }
        else {
            if (read) {
                buttonColor = surfaceColor4
            }
            else {
                buttonColor = textColor
            }
        }
    }

    function markPreviousAsRead(firstIndex) {
        
    }
}