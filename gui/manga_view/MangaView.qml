import QtQuick 2.15
import QtQuick.Controls 2.15
import "manga_data"
import "manga_chapters"
import "manga_tool_bar"

Item {
    // MangaView alias
    property alias mangaView: mangaView
    property alias mangaToolBar: mangaToolBar
    property alias dataManga: dataManga
    property alias mangaChapters: mangaChapters

    property alias flickableView: flickableView
    property alias mouseArea: mouseArea

    // Properties for MangaToolBar
    property int toolbarHeight: 48
    property int iconSize: 24
    property int filterMenuWidth: 250

    // Properties for DataManga
    property int imageWidth: 210
    property int imageHeight: 315
    property int animTime: 500
    property int genresBorderWidth: 1

    // Properties for MangaView
    property string previousThumbnail
    property string mangaLink
    property string mangaSource

    property string title
    property string author
    property string description
    property string thumbnail
    property string status
    property var genres
    property int total_chapters

    property bool bookmarked
    property bool downloadInProgress

    id: mangaView
    
    Column {
        Button {onClicked: saveManga()}
        width: parent.width
        height: parent.height

        MangaToolBar {id: mangaToolBar}

        Flickable {
            id: flickableView

            width: parent.width
            height: parent.height - mangaToolBar.height
            contentHeight: dataManga.row.height + mangaChapters.height + mangaToolBar.height

            maximumFlickVelocity: normalMaximumFlickVelocity
            flickDeceleration: normalFlickDeceleration
            boundsMovement: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { }

            Column {
                anchors.fill: parent

                MangaData {id: dataManga}              // Manga data
                TotalChaptersData {id: totalChapters}  // Chapters data
                MangaChapters {id: mangaChapters}      // Chapters data
            }
        }

        Connections {
            target: MangaViewer
            // Set the data
            function onManga_data(mangaData, source, error) {
                author = mangaData.author
                description = mangaData.description
                thumbnail = mangaData.thumbnail
                genres = mangaData.genres
                total_chapters = mangaData.total_chapters
                status = mangaData.current_status

                dataManga.image.source = previousThumbnail
                dataManga.title.text = title
                dataManga.author.authorText = author
                dataManga.status.statusText = status
                dataManga.genres.model = genres
                dataManga.description.descriptionText = description

                totalChapters.chapters = total_chapters
                mangaSource = source

                for (var i=0; i < total_chapters; i++) {
                    mangaChapters.spawnChapter(mangaData["chapters"]["chapter_" + (i)])
                }
            }
        }

        Component.onCompleted: leftBar.visible = false
        
    }

    Keys.onEscapePressed: stackView.pop(), leftBar.visible = true // To exit.

    // To force focus.
    MouseArea {
        id: mouseArea
        z: -1

        width: parent.width
        height: parent.height

        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: parent.forceActiveFocus(), flickableView.interactive = true
    }

    function saveManga() {
        var mangaDict = {}
        var chaptersDict = {}
        var filters = mangaToolBar.menuButton.filters
        var chapters = mangaChapters.children

        mangaDict.title = title
        mangaDict.author = author
        mangaDict.description = description
        mangaDict.thumbnail = previousThumbnail
        mangaDict.genres = genres
        mangaDict.total_chapters = total_chapters
        mangaDict.current_status = status
        mangaDict.link = mangaLink
        mangaDict.bookmarked = bookmarked
        mangaDict.source = mangaSource

        mangaDict.filters = {
            read: filters.checkRead.checked,
            unread: filters.checkUnread.checked,
            bookmarked: filters.checkBookmarked.checked,
            downloaded: filters.checkDownloaded.checked,
            reverse: filters.checkReverse.checked
        }

        for (var i=0; i < chapters.length; i++) {
            var chapterName = chapters[i].chapterName
            var chapterLink = chapters[i].chapterLink
            var chapterUploadDate = chapters[i].chapterDate
            var chapterBookmarked = chapters[i].bookmarked
            var chapterRead = chapters[i].read
            var chapterQueued = chapters[i].queued
            var chapterDownloading = chapters[i].downloading
            var chapterDownloaded = chapters[i].downloaded

            chaptersDict["chapter_" + i] = {
                name: chapterName,
                link: chapterLink,
                upload_date: chapterUploadDate,
                bookmarked: chapterBookmarked,
                read: chapterRead,
                queued: chapterQueued,
                downloading: chapterDownloading,
                downloaded: chapterDownloaded
            }
            
        }
        mangaDict.chapters = chaptersDict
        MangaViewer.save_manga(JSON.stringify(mangaDict), mangaSource, title)
    }
}