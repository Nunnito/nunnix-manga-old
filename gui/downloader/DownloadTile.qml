import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    property alias dropArea: dropArea
    property alias text: downloadButton.text

    property string url
    property string source
    property string name
    property string chapter

    property bool queued: true
    property bool downloaded: false
    property bool downloading: false

    property int total_images: 0
    property int downloaded_images: 0
    property int mangaIndex

    id: downloadItem

    width: parent != null ? parent.width : 0
    height: normalSpacing * 4 - normalSpacing / 2
    opacity: dragArea.drag.active ? 0.75 : 1

    ItemDelegate {
        id: downloadButton

        width: parent.width
        height: normalSpacing * 4 - normalSpacing / 2
        
        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: height / 2
        Drag.hotSpot.y: height / 2

        Label {
            id: downloadName

            color: textColor
            font.pixelSize: normalTextFontSize

            anchors.top: parent.top
            leftPadding: normalSpacing
            topPadding: normalSpacing / 2

            text: chapter + " - " + name
        }

        Label {
            id: downloadStatus

            color: placeHolderColor
            font.pixelSize: smallTextFontSize

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            rightPadding: normalSpacing
            bottomPadding: normalSpacing / 4

            text: queuedText
        }

        Label {
            id: downloadSource

            color: placeHolderColor
            font.pixelSize: smallTextFontSize

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            leftPadding: normalSpacing
            bottomPadding: normalSpacing / 4

            text: source
        }

        Image {
            id: dragButton

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            source: "../../resources/drag_indicator.svg"
            sourceSize.width: iconSize
            sourceSize.height: iconSize

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: placeHolderColor
            }

            MouseArea {
                id: dragArea

                cursorShape: containsPress ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                anchors.fill: parent

                drag.target: downloadButton
                drag.axis: Drag.YAxis
                drag.maximumY: listView.contentHeight - downloadButton.height - index * downloadButton.height
                drag.minimumY: 0 - index * downloadButton.height

                onReleased: {
                    downloads.move(index, dragTouching, 1)
                    downloadButton.y = 0
                    mangaMoved()
                }
                onPressed: dragIndex = index
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: surfaceColor4
            y: parent.height
        }
    }

    DropArea {
        id: dropArea

        width: parent.width
        height: normalSpacing * 4 - normalSpacing / 2

        onEntered: dragTouching = index
    }

    Connections {
        target: MangaDownloader

        function onDownload_progress(nImages, nDownloads, mangaID) {
            if (mangaID == url + source + name + chapter) {
                queued = false
                downloading = true

                total_images = nImages
                downloaded_images = nDownloads

                downloadStatus.text = downloaded_images + "/" + total_images

                if (total_images == downloaded_images) {
                    downloadStatus.text = downloadedText
                    downloaded = true
                    downloading = false
                    MangaDownloader.set_downloaded(name, source, mangaIndex)
                    mangaDownloaded()
                }
            }
        }
    }

    onQueuedChanged: {
        MangaDownloader.set_queued(name, source, mangaIndex, queued)
    }
    onDownloadingChanged: {
        MangaDownloader.set_downloading(name, source, mangaIndex, downloading)
    }
}
