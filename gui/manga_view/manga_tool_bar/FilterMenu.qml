import QtQuick 2.15
import QtQuick.Controls 2.15

// Filters
Menu {
    property alias checkRead: checkRead
    property alias checkUnread: checkUnread
    property alias checkBookmarked: checkBookmarked
    property alias checkDownloaded: checkDownloaded
    property alias checkReverse: checkReverse

    property bool uncheckedFilters: (!checkRead.checked && !checkUnread.checked && !checkBookmarked.checked && !checkDownloaded.checked)

    id: filters
    width: filterMenuWidth

    Column {
        leftPadding: normalSpacing / 2

        Label {
            text: qsTr("Filter by")
            color: placeHolderColor
            font.pixelSize: normalTextFontSize
            leftPadding: normalSpacing / 4
        }

        // Read checkbox
        CheckBox {
            id: checkRead

            text: qsTr("Read")
            width: parent.width

            onCheckedChanged: {
                saveManga()

                if (checked) {
                    checkUnread.checked = false
                    mangaChapters.showRead(checkBookmarked.checked, checkDownloaded.checked)
                }
                else {
                    if (checkBookmarked.checked) {
                        mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked, checkDownloaded.checked)
                    }
                    if (checkDownloaded.checked) {
                        mangaChapters.showDownloaded(checkRead.checked, checkUnread.checked, checkBookmarked.checked)
                    }
                }
            }
        }

        // Unread checkbox
        CheckBox {
            id: checkUnread

            text: qsTr("Unread")
            width: parent.width

            onCheckedChanged: {
                saveManga()

                if (checked) {
                    checkRead.checked = false
                    mangaChapters.showUnread(checkBookmarked.checked, checkDownloaded.checked)
                }
                else {
                    if (checkBookmarked.checked) {
                        mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked, checkDownloaded.checked)
                    }
                    if (checkDownloaded.checked) {
                        mangaChapters.showDownloaded(checkRead.checked, checkUnread.checked, checkBookmarked.checked)
                    }
                }
            }
        }

        // Bookmarked checkbox
        CheckBox {
            id: checkBookmarked

            text: qsTr("Bookmarked")
            width: parent.width

            onCheckedChanged: {
                saveManga()

                if (checked) {
                    mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked, checkDownloaded.checked)
                }
                else {
                    if (checkRead.checked) {
                        mangaChapters.showRead(checkBookmarked.checked, checkDownloaded.checked)
                    }
                    if (checkUnread.checked) {
                        mangaChapters.showUnread(checkBookmarked.checked, checkDownloaded.checked)
                    }
                    if (checkDownloaded.checked) {
                        mangaChapters.showDownloaded(checkRead.checked, checkUnread.checked, checkBookmarked.checked)
                    }
                }
            }
        }
        CheckBox {
            id: checkDownloaded

            text: qsTr("Downloaded")
            width: parent.width

            onCheckedChanged: {
                saveManga()

                if (checked) {
                    mangaChapters.showDownloaded(checkRead.checked, checkUnread.checked, checkBookmarked.checked)
                }
                else {
                    if (checkRead.checked) {
                        mangaChapters.showRead(checkBookmarked.checked, checkDownloaded.checked)
                    }
                    if (checkUnread.checked) {
                        mangaChapters.showUnread(checkBookmarked.checked, checkDownloaded.checked)
                    }
                    if (checkBookmarked.checked) {
                        mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked, checkDownloaded.checked)
                    }
                }
            }
        }
    }

    Column {
        topPadding: normalSpacing
        leftPadding: normalSpacing / 2
        
        Label {
            text: qsTr("Order by")
            color: placeHolderColor
            font.pixelSize: normalTextFontSize
            leftPadding: normalSpacing / 4
        }

        // Reverse the view
        CheckBox {
            id: checkReverse
            text: qsTr("Chapter number")
            width: parent.width

            onCheckedChanged: mangaChapters.swap(), saveManga()
        }
    }

    // If nothing is checked, show all
    onUncheckedFiltersChanged: {
        if (uncheckedFilters) {
            mangaChapters.showAll()
        }
    }
}