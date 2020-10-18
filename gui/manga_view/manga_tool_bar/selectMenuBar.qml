import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    property alias row: row

    property var readList: []
    property var bookmarkedList: []
    property var downloadedList: []
    
    property string downloadText: qsTr("Download")
    property string bookmarkText: qsTr("Bookmark")
    property string readText: qsTr("Mark as read")

    id: row

    spacing: normalSpacing / 2

    Button {
        id: downloadButton

        Layout.leftMargin: normalSpacing / 2

        text: downloadText
        highlighted: true

        contentItem: Text {
            text: parent.text  
            color: backgroundColor
            font.bold: true
            font.capitalization: Font.AllUppercase
        }

        onClicked: (text == downloadText ? mangaChapters.downloadSelected() : mangaChapters.deleteSelected()), mangaChapters.deselectAll()
    }
    Button {
        id: bookmarkButton

        text: bookmarkText
        highlighted: true

        contentItem: Text {
            text: parent.text  
            color: backgroundColor
            font.bold: true
            font.capitalization: Font.AllUppercase
        }

        onClicked: mangaChapters.bookmarkSelected(text == bookmarkText), mangaChapters.deselectAll()
    }
    Button {
        id: readButton

        text: readText
        highlighted: true

        contentItem: Text {
            text: parent.text  
            color: backgroundColor
            font.bold: true
            font.capitalization: Font.AllUppercase
        }

        onClicked: mangaChapters.markSelectedAsRead(text == readText), mangaChapters.deselectAll()
    }

    
    Rectangle {
        Layout.fillWidth: true
        color: "transparent"
    }
    
    Button {
        id: cancelButton

        Layout.rightMargin: normalSpacing / 2

        text: qsTr("Cancel")
        flat: true
        highlighted: true

        contentItem: Text {
            text: parent.text  
            color: primaryColor
            font.bold: true
            font.capitalization: Font.AllUppercase
        }

        onClicked: mangaChapters.deselectAll()
    }

    function updateSelectBar(read, bookmarked, downloaded, add) {
        if (add) {
            readList.push(read)
            bookmarkedList.push(bookmarked)
            downloadedList.push(downloaded)
        }
        else {
            readList.splice(readList.indexOf(read), 1)
            bookmarkedList.splice(bookmarkedList.indexOf(bookmarked), 1)
            downloadedList.splice(downloadedList.indexOf(downloaded), 1)
        }
    }

    function setReadText() {
        for (var i=0; i < readList.length; i++) {
            if (!readList[i]) {
                readButton.text = readText

                return true
            }
            else {
                readButton.text = qsTr("Mark as unread")
            }
        }
    }

    function setBookmarkText() {
        for (var i=0; i < readList.length; i++) {
            if (!bookmarkedList[i]) {
                bookmarkButton.text = bookmarkText

                return true
            }
            else {
                bookmarkButton.text = qsTr("Unbookmark")
            }
        }
    }

    function setDownloadText() {
        for (var i=0; i < readList.length; i++) {
            if (!downloadedList[i]) {
                downloadButton.text = downloadText

                return true
            }
            else {
                downloadButton.text = qsTr("Delete")
            }
        }
    }
}