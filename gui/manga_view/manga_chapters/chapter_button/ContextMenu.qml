import QtQuick 2.15
import QtQuick.Controls 2.15

Menu {
    id: menu

    MenuItem {
        id: download
        text: qsTr("Download")
    }
    MenuItem {
        id: bookmark
        text: bookmarked ? qsTr("Unbookmark") : qsTr("Bookmark")

        onTriggered: bookmarked = !bookmarked
    }
    MenuItem {
        id: markAsRead
        text: read ? qsTr("Mark as unread") : qsTr("Mark as read")

        onTriggered: read = !read
    }
    MenuSeparator {}
    MenuItem{text: "Copy chapter link"}
    MenuItem{text: "Mark previous as read"}
    background: Rectangle {
        implicitWidth: markAsRead.width
        color: surfaceColor2
    }

    onClosed: mouseArea.acceptedButtons = Qt.RightButton
}