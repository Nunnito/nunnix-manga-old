import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: downloader
    property int downloadCount: 0
	property int iconSize: 24

    property int dragTouching
    property int dragIndex

    visible: swipeView.currentIndex

    height: parent.height
    width: leftBar.visible ? mainWindow.width - leftBar.width - layout.spacing : mainWindow.width - layout.spacing

    ListView {
        id: listView
        width: parent.width
        height: parent.height

        model: downloads

        delegate: DownloadTile {}
        displaced: Transition {
            NumberAnimation {properties: "x, y"; duration: 100}
        }
    }

    ListModel {id: downloads}

    function downloadManga(url, source, name, chapter) {
        var downloadTile = Qt.createComponent("DownloadTile.qml")
        downloads.append(downloadTile)

        console.log(url, source, name, chapter, downloadCount, visible)
        downloadCount++
    }
}
