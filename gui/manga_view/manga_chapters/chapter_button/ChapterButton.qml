import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15

ItemDelegate {
    property alias chapterButton: chapterButton
    property alias loader: loader
    property alias mouseArea: mouseArea

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
    property bool currentDownload

    property string buttonColor: textColor
    property string downloadStatus: queued ? queuedText : downloading ? downloadingText : downloaded ? downloadedText : ""

    property bool cached: downloaded ? false : downloading ? false : true
    property int index
    property int total
    property int count: 0

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

        onClicked: {
            if (selecting) {
                parent.highlighted = !parent.highlighted
                isDeselectedAll()
                if (parent.highlighted) {
                    mangaToolBar.toolBarStackView.children[1].updateSelectBar(read, bookmarked, downloaded, true)
                }
                else {
                    mangaToolBar.toolBarStackView.children[1].updateSelectBar(read, bookmarked, downloaded, false)
                }
                mangaToolBar.toolBarStackView.children[1].setReadText()
                mangaToolBar.toolBarStackView.children[1].setBookmarkText()
                mangaToolBar.toolBarStackView.children[1].setDownloadText()
            }
        }
    }


    onClicked: {
        stackView.push("../../../reader/Reader.qml", {"chapterLink": chapterLink, "chapterIndex": index})
        MangaDownloader.set_images(chapterLink, mangaSource, title, chapterName, cached, chapterLink, downloaded, downloading)
    }

    onReadChanged: {
        if (!markAsReadRecursive) {
            saveManga()
        }

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
        saveManga()

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
        saveManga()

        if (queued && !downloadInProgress) {
            cached = false
            downloadInProgress = true
            currentDownload = true
            MangaDownloader.set_images(chapterLink, mangaSource, title, chapterName, cached, chapterLink, downloaded, downloading)
            saveManga()
        }
    }

    onDownloadedChanged: {
        saveManga()
    }

    function markPreviousAsRead(firstIndex) {
        markAsReadRecursive = true
        for (var i=firstIndex+1; i < mangaChapters.children.length; i++) {
            mangaChapters.children[i].read = true
        }
        markAsReadRecursive = false
        saveManga()
    }

    function deleteManga() {
        MangaViewer.delete_manga(mangaSource, title, chapterName)
        downloaded = false
    }

    function cancelManga() {
        if (downloading) {
            MangaDownloader.cancel_manga()
            downloadInProgress = false
            queued = false
            refreshDownload()
        }
        queued = false
        downloading = false
        currentDownload = false
        deleteManga()
    }

    // Download the next chapter in queue
    function refreshDownload() {
        for (var i=mangaChapters.children.length - 1; i >= 0; i--) {
            if (mangaChapters.children[i].queued == true) {
                mangaChapters.children[i].queued = false
                mangaChapters.children[i].queued = true
            }
        }
    }


    Connections {
        target: MangaDownloader
        function onGet_images(images, imgWidth, imgHeight, buttonLink, imagesCount, downloadCount) {
            if (buttonLink == chapterLink && downloadCount != -1 && currentDownload) {
                queued = false
                downloading = true
                total = imagesCount
                count = downloadCount
            }
        }

        function onDownloaded(buttonLink) {
            if (buttonLink == chapterLink) {
                downloading = false
                downloaded = true
                downloadInProgress = false
                currentDownload = false
                refreshDownload()
            }
        }
    }
}
