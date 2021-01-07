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
        MangaDownloader.read_manga(chapterLink, mangaSource, title, chapterName, downloaded)
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

    function markPreviousAsRead(firstIndex) {
        markAsReadRecursive = true
        for (var i=firstIndex+1; i < mangaChapters.children.length; i++) {
            mangaChapters.children[i].read = true
        }
        markAsReadRecursive = false
    }

    function deleteManga() {
        MangaViewer.delete_manga(mangaSource, title, chapterName)
        downloaded = false
    }

    Connections {
        target: MangaDownloader

        function onDownload_progress(nImages, nDownloads, mangaID) {
            if (mangaID == chapterLink + mangaSource + mangaView.title + chapterName) {
                queued = false
                downloading = true

                total = nImages
                count = nDownloads

                if (total == count) {
                    downloaded = true
                    downloading = false
                }
            }
        }
    }
}
