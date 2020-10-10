import QtQuick 2.15
import QtQuick.Controls 2.15

Menu {
    id: filters
    width: 250
    Column {
        leftPadding: normalSpacing / 2

        Label {
            text: qsTr("Filter by")
            color: placeHolderColor
            font.pixelSize: normalTextFontSize
            leftPadding: normalSpacing / 4
        }
        CheckBox {
            text: qsTr("All")
            width: parent.width
        }
        CheckBox {
            id: checkRead

            text: qsTr("Read")
            width: parent.width

            onCheckedChanged: {
                if (checked) {
                    checkUnread.checked = false
                    mangaChapters.showRead(checkBookmarked.checked)
                }
            }
        }
        CheckBox {
            id: checkUnread

            text: qsTr("Unread")
            width: parent.width

            onCheckedChanged: {
                if (checked) {
                    checkRead.checked = false
                    mangaChapters.showUnread(checkBookmarked.checked)
                }
            }
        }
        CheckBox {
            id: checkBookmarked

            text: qsTr("Bookmarked")
            width: parent.width

            onCheckedChanged: {
                if (checked) {
                    mangaChapters.showBookmarked(checkRead.checked, checkUnread.checked)
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
        CheckBox {
            text: qsTr("Chapter number")
            width: parent.width
        }
    }
}