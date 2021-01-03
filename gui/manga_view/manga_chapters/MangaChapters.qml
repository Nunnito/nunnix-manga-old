import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15

// Chapters columns, with context menu
Column {
    property alias mangaChapters: mangaChapters
    property int currentIndex: 0
    id: mangaChapters
    width: parent.width

    function spawnChapter(data) {
        var chapterButton = Qt.createComponent("chapter_button/ChapterButton.qml")
        var button = chapterButton.createObject(mangaChapters)

        button.chapterName = data.name
        button.chapterDate = data.upload_date
        button.chapterLink = data.link
        button.index = currentIndex

        if (reversed) {
            button.rotation += 180
        }

        currentIndex += 1
    }

    // Reverse column
    function reverse() {
        rotation += 180

        for (var i=0; i < children.length; i++) {
            children[i].rotation += 180
        }
    }

    // Show reads chapters
    function showRead(bookmarked, downloaded) {
        for (var i=0; i < children.length; i++) {
            if (bookmarked) {
                children[i].visible = children[i].read && children[i].bookmarked
            }
            else if (downloaded) {
                children[i].visible = children[i].read && children[i].downloaded
            }
            else {
                children[i].visible = children[i].read
            }
        }
    }

    // Show unread chapters
    function showUnread(bookmarked, downloaded) {
        for (var i=0; i < children.length; i++) {
            if (bookmarked) {
                children[i].visible = !children[i].read && children[i].bookmarked
            }
            else if (downloaded) {
                children[i].visible = !children[i].read && children[i].downloaded
            }
            else {
                children[i].visible = !children[i].read
            }
        }
    }

    // Show bookmarked chapters
    function showBookmarked(read, unread, downloaded) {
        for (var i=0; i < children.length; i++) {
            if (read) {
                children[i].visible = children[i].bookmarked && children[i].read
            }
            else if (unread) {
                children[i].visible = children[i].bookmarked && !children[i].read
            }
            else if (downloaded) {
                children[i].visible = children[i].bookmarked && children[i].downloaded
            }
            else {
                children[i].visible = children[i].bookmarked
            }
        }
    }

    // Show downloaded chapters
    function showDownloaded(read, unread, bookmarked) {
        for (var i=0; i < children.length; i++) {
            if (read) {
                children[i].visible = children[i].downloaded && children[i].read
            }
            else if (unread) {
                children[i].visible = children[i].downloaded && !children[i].read
            }
            else if (bookmarked) {
                children[i].visible = children[i].downloaded && children[i].bookmarked
            }
            else {
                children[i].visible = children[i].downloaded
            }
        }
    }

    // Show all chapters
    function showAll() {
        for (var i=0; i < children.length; i++) {
            children[i].visible = true
        }
    }

    // Downloads chapters
    function downloadChapters(unread) {
        for (var i=0; i < children.length; i++) {
            if (unread) {
                if (!children[i].read) {
                    downloader.downloadManga(children[i].chapterLink, mangaSource, mangaView.title, children[i].chapterName) 
                }
            }
            else {
                downloader.downloadManga(children[i].chapterLink, mangaSource, mangaView.title, children[i].chapterName)
            }
        }
    }

    function markSelectedAsRead(read) {
        for (var i=0; i < children.length; i++) {
            if (children[i].highlighted) {
                children[i].read = read
            }
        }
    }

    function bookmarkSelected(bookmarked) {
        for (var i=0; i < children.length; i++) {
            if (children[i].highlighted) {
                children[i].bookmarked = bookmarked
            }
        }
    }

    function downloadSelected() {
        for (var i=children.length - 1; i >= 0; i--) {
            if (children[i].highlighted) {
                downloader.downloadManga(children[i].chapterLink, mangaSource, mangaView.title, children[i].chapterName)
            }
        }
    }

    function deleteSelected() {
        for (var i=0; i < children.length; i++) {
            if (children[i].highlighted) {
                children[i].deleteManga()
            }
        }
    }

    function deselectAll() {
        for (var i=0; i < children.length; i++) {
            if (children[i].highlighted) {
                children[i].highlighted = false
            }
            children[i].mouseArea.acceptedButtons = Qt.RightButton
        }
        mangaToolBar.toolBarStackView.pop()
        selecting = false
    }

    function selectAll() {
        for (var i=0; i < children.length; i++) {
            children[i].highlighted = true
        }
    }

    function isDeselectedAll() {
        for (var i=0; i < children.length; i++) {
            if (children[i].highlighted) {
                return false
            }
        }
        deselectAll()
    }

    function activeLeftButton() {
        for (var i=0; i < children.length; i++) {
            children[i].mouseArea.acceptedButtons = Qt.LeftButton
        }
    }
}
