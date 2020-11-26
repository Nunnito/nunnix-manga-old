import QtQuick 2.15
import QtQuick.Controls 2.15

Menu {
    id: menu

    // Download chapter
    MenuItem {
        id: download
        text: downloaded ? qsTr("Delete") : downloading || queued ? qsTr("Cancel") : qsTr("Download")

        onTriggered: downloaded ? deleteManga() : downloading || queued ? cancelManga() : queued = true
    }
    // Bookmark/unbookmark chapter
    MenuItem {
        id: bookmark
        text: bookmarked ? qsTr("Unbookmark") : qsTr("Bookmark")

        onTriggered: bookmarked = !bookmarked
    }
    // Mark chapter as read/unread
    MenuItem {
        id: markAsRead
        text: read ? qsTr("Mark as unread") : qsTr("Mark as read")

        onTriggered: read = !read
    }

    MenuSeparator {}

    MenuItem {
        id: select
        text: chapterButton.highlighted ? qsTr("Deselect") : qsTr("Select")

        onTriggered: {
            chapterButton.highlighted = !chapterButton.highlighted

            if (!selecting) {
                mangaToolBar.toolBarStackView.push("../../manga_tool_bar/selectMenuBar.qml")
                mangaToolBar.toolBarStackView.children[1].updateSelectBar(read, bookmarked, downloaded, true)
                mangaToolBar.toolBarStackView.children[1].setReadText()
                mangaToolBar.toolBarStackView.children[1].setBookmarkText()
                mangaToolBar.toolBarStackView.children[1].setDownloadText()
                selecting = true
                activeLeftButton()
            }
        }
    }

    // Copy chapter link
    MenuItem {
        id: copyLink
        text: qsTr("Copy chapter link")

        onTriggered: copy(chapterLink)
    }
    // Mark all previous chapters as read
    MenuItem {
        id: previousAsRead
        text: qsTr("Mark previous as read")

        onTriggered: markPreviousAsRead(index)
    }

    onClosed: parent.active = false
    Component.onCompleted: popup()
    Component.onDestruction: {
        if (!selecting) {
            mouseArea.acceptedButtons = Qt.RightButton, parent.active = false
        }
    }
}