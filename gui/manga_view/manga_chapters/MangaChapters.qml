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

        currentIndex += 1
    }

    // Reverse column
    function swap() {
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
}