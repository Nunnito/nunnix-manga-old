import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: downloader
    property int downloadCount: 0
    visible: swipeView.currentIndex

    height: parent.height
    width: leftBar.visible ? mainWindow.width - leftBar.width - layout.spacing : mainWindow.width - layout.spacing

    Column {
        id: column
        height: parent.height
        width: parent.width

        DownloadTile {}
    }

    function downloadManga(url, source, name, chapter) {
        var component = Qt.createComponent("DownloadTile.qml")
        var downloadTile = component.createObject(column)

        console.log(url, source, name, chapter, downloadCount, visible)
        downloadCount++
    }
}
