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
    property bool markAsReadRecursive
    property bool forced
    property bool selecting
    property bool chaptersFinished

    id: mangaView
    
    Column {
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
            function onManga_data(mangaData, mangaDataSaved, source, error, saved) {
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

                if (saved) {
                    mangaLink = mangaData.link
                    bookmarked = mangaData.bookmarked
                }

                if (mangaChapters.children.length != 0) {
                    for (var i=0; i < mangaChapters.children.length; i++) {
                        mangaChapters.children[i].destroy()
                    }
                }

                sleep(250, function() {
                    for (var i=0; i < total_chapters; i++) {
                        mangaChapters.spawnChapter(mangaData["chapters"]["chapter_" + i])

                        if (saved) {
                            var chapters = mangaChapters.children
                            var chaptersData = mangaData.chapters["chapter_" + i]

                            chapters[i].bookmarked = chaptersData.bookmarked
                            chapters[i].read = chaptersData.read
                            chapters[i].queued = chaptersData.queued
                            chapters[i].downloading = chaptersData.downloading
                            chapters[i].downloaded = chaptersData.downloaded
                        }
                    }

                    if (saved) {
                        var filters = mangaToolBar.menuButton.filters
                        var dataFilters = mangaData.filters

                        filters.checkRead.checked = dataFilters.read
                        filters.checkUnread.checked = dataFilters.unread
                        filters.checkBookmarked.checked = dataFilters.bookmarked
                        filters.checkDownloaded.checked = dataFilters.downloaded
                        filters.checkReverse.checked = dataFilters.reverse
                    }

                    if (Object.keys(mangaDataSaved).length != 0) {
                        var addSaved = 0
                        var chapted_saved_name = ""
                        var chapters = mangaChapters.children

                        
                        for (var i=0; i < mangaChapters.children.length; i++) {
                            var chapter_name = JSON.stringify(mangaData.chapters["chapter_" + i].name)
                            var chaptersData = mangaDataSaved.chapters["chapter_" + (i - addSaved)]

                            if (mangaDataSaved.chapters["chapter_" + ((mangaChapters.children.length - 1) - i)] == null) {
                                addSaved += 1
                            }
                            else {
                                var chaptersSaved = mangaDataSaved.chapters["chapter_" + (i - addSaved)]
                                chapted_saved_name = JSON.stringify(chaptersSaved.name)

                            }

                            if (chapter_name == chapted_saved_name) {
                                chapters[i].bookmarked = chaptersData.bookmarked
                                chapters[i].read = chaptersData.read
                                chapters[i].queued = chaptersData.queued
                                chapters[i].downloading = chaptersData.downloading
                                chapters[i].downloaded = chaptersData.downloaded
                            }
                        }
                    }
                    chaptersFinished = true
                })
            }
        }

        Component.onCompleted: leftBar.visible = false
        
    }

    Keys.onEscapePressed: {
        if (selecting) {
            mangaChapters.deselectAll()
        }
        else {
            stackView.pop(), leftBar.visible = true // To exit.
        }
    }

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

    // Sleep function, to wait.
    function sleep(delayTime, callBack) {
        var timer = Qt.createQmlObject("import QtQuick 2.15; Timer {}", parent)
        timer.interval = delayTime
        timer.triggered.connect(callBack)
        timer.start()
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
        mangaDict.source = mangaSource
        mangaDict.link = mangaLink
        mangaDict.bookmarked = bookmarked

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
        if (chaptersFinished) {
            MangaViewer.save_manga(JSON.stringify(mangaDict), mangaSource, title)
        }
    }
}