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
        text: qsTr("Bookmark")
    }
    MenuItem {
        id: markAsRead
        text: read ? qsTr("Mark as unread") : qsTr("Mark as read")

        onTriggered: read = !read
    }
    background: Rectangle {
        implicitWidth: markAsRead.width
        color: surfaceColor2
    }

    onClosed: mouseArea.acceptedButtons = Qt.RightButton
}