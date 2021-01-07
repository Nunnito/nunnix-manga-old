import QtQuick 2.15
import QtQuick.Controls 2.15


ListView {
    property alias downloads: downloads

    signal mangaMoved()
    signal mangaDownloaded()

    id: listView
    width: parent.width
    height: parent.height

    model: downloads

    delegate: DownloadTile {url: Url; source: Source; chapter: Chapter; name: Name; mangaIndex: Index}

    displaced: Transition {
        NumberAnimation {properties: "x, y"; duration: 100}
    }

    ListModel {id: downloads}

    onMangaDownloaded: {
        downloads.remove(0)

        sleep(50, function() {
            for (var i = 0; i < downloads.count; i++) {
                if (listView.itemAtIndex(i).queued) {
                    var url = listView.itemAtIndex(i).url
                    var source = listView.itemAtIndex(i).source
                    var name = listView.itemAtIndex(i).name
                    var chapter = listView.itemAtIndex(i).chapter

                    MangaDownloader.download_manga(url, source, name, chapter)
                    return
                }
            }
        })
        downloading = false
    }

    onMangaMoved: {
        // Wait until the mangas moves internally
        sleep(50, function() {
            for (var i = 0; i < downloads.count; i++) {
                if (!listView.itemAtIndex(i).downloaded) {
                    var url = listView.itemAtIndex(i).url
                    var source = listView.itemAtIndex(i).source
                    var name = listView.itemAtIndex(i).name
                    var chapter = listView.itemAtIndex(i).chapter

                    if (listView.itemAtIndex(i).downloading) {
                        return
                    }
                    for (var i = 0; i < downloads.count; i++) {
                        if (listView.itemAtIndex(i).downloading) {
                            listView.itemAtIndex(i).downloading = false
                            listView.itemAtIndex(i).queued = true
                            break
                        }
                    }
                    MangaDownloader.cancel_manga()
                    MangaDownloader.download_manga(url, source, name, chapter)
                    return
                }
            }
        })
    }
}

