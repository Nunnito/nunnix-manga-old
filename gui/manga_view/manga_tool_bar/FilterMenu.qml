import QtQuick 2.15
import QtQuick.Controls 2.15

// Filters
Menu {
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
                if (checked) {
                    checkUnread.checked = false
                    mangaChapters.showRead(checkBookmarked.checked)
                }
                else {
                    if (checkBookmarked.checked) {
                        mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked)
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
                if (checked) {
                    checkRead.checked = false
                    mangaChapters.showUnread(checkBookmarked.checked)
                }
                else {
                    if (checkBookmarked.checked) {
                        mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked)
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
                if (checked) {
                    mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked)
                }
                else {
                    if (checkRead.checked) {
                        mangaChapters.showRead(checkBookmarked.checked)
                    }
                    if (checkUnread.checked) {
                        mangaChapters.showUnread(checkBookmarked.checked)
                    }
                }
            }
        }
        CheckBox {
            id: checkDownloaded

            text: qsTr("Downloaded")
            width: parent.width
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
            text: qsTr("Chapter number")
            width: parent.width

            onCheckedChanged: mangaChapters.swap()
        }
    }

    // If nothing is checked, show all
    onUncheckedFiltersChanged: {
        if (uncheckedFilters) {
            mangaChapters.showAll()
        }
    }
}