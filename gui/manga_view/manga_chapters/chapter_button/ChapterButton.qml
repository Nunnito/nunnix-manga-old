import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15

ItemDelegate {
    property alias chapterButton: chapterButton
    property alias loader: loader

    property string chapterName
    property string chapterDate
    property string chapterLink

    property string queuedText: qsTr("Queued")
    property string downloadingText: qsTr("Downloading...") + " " + count + "/" + total
    property string downloadedText: qsTr("Downloaded")

    property bool queued
    property bool downloaded
    property bool downloading
    property bool read
    property bool bookmarked

    property string buttonColor: textColor
    property string downloadStatus: queued ? queuedText : downloading ? downloadingText : downloaded ? downloadedText : ""

    property bool cached: true
    property int index
    property int total
    property int count

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

        // Queued/downloading/downloaded status
        Label {
            text: downloadStatus
            color: placeHolderColor
            font.pixelSize: smallTextFontSize
            font.capitalization: Font.AllUppercase

            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }
    }

    // Separator
    Rectangle {
        width: parent.width
        height: 1
        color: parent.pressed ? primaryColor : surfaceColor4
        y: parent.height
    }

    Loader {
        id: loader
        active: false
        source: "ContextMenu.qml"
    }

    // Open the context menu
    MouseArea {
        id: mouseArea
    
        width: parent.width
        height: parent.height
        acceptedButtons: Qt.RightButton
        onPressed: {
            if (mouse.button == Qt.RightButton) {
                loader.active = true
                acceptedButtons = Qt.LeftButton | Qt.RightButton
            }
            if (mouse.button == Qt.LeftButton) {
                loader.active = false
            }
        }
    }


    onClicked: {
        stackView.push("../../../reader/Reader.qml")
        MangaDownloader.set_images(chapterLink, title, chapterName, cached, index, downloaded)
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

    onQueuedChanged: {
        if (queued && !downloadInProgress) {
            cached = false
            downloadInProgress = true
            MangaDownloader.set_images(chapterLink, title, chapterName, cached, index, downloaded)
        }
    }

    function markPreviousAsRead(firstIndex) {
        for (var i=firstIndex+1; i < mangaChapters.children.length; i++) {
            mangaChapters.children[i].read = true
        }
    }

    // Download the next chapter in queue
    function refreshDownload() {
        for (var i=0; i < mangaChapters.children.length; i++) {
            if (mangaChapters.children[i].queued == true) {
                mangaChapters.children[i].queued = false
                mangaChapters.children[i].queued = true
            }
        }
    }


    Connections {
        target: MangaDownloader
        function onGet_images(images, buttonIndex, imagesCount, downloadCount) {
            if (buttonIndex == index) {
                queued = false
                downloading = true
                total = imagesCount
                count = downloadCount
            }
        }

        function onDownloaded(buttonIndex) {
            if (buttonIndex == index) {
                downloading = false
                downloaded = true
                downloadInProgress = false
                refreshDownload()
            }
        }
    }
}