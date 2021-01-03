import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: downloader
    property int downloadCount: 0
	property int iconSize: 24

    property int dragTouching
    property int dragIndex

    property string queuedText: qsTr("Queued")
    property string downloadedText: qsTr("Downloaded")

    property bool downloading: false

    visible: swipeView.currentIndex

    height: parent.height
    width: leftBar.visible ? mainWindow.width - leftBar.width - layout.spacing : mainWindow.width - layout.spacing

    DownloaderList {id: downloaderList}

    function downloadManga(url, source, name, chapter) {
        var downloadObject = {
            "Url": url,
            "Source": source,
            "Name": name,
            "Chapter": chapter
        }

        downloaderList.downloads.append(downloadObject)
        downloadCount++

        if (!downloading) {
            downloading = true
            MangaDownloader.download_manga(url, source, name, chapter)
        }
    }
}
