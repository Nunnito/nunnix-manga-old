import QtQuick 2.15
import QtQuick.Controls 2.15
import "manga_data"
import "manga_chapters"
import "manga_tool_bar"

Item {
    // MangaView alias
    property alias mangaView: mangaView
    property alias mangaToolBar: mangaToolBar
    property alias dataManga: dataManga
    property alias mangaChapters: mangaChapters

    property alias flickableView: flickableView
    property alias mouseArea: mouseArea

    // Properties for MangaToolBar
    property int toolbarHeight: 48
    property int iconSize: 24 

    // Properties for DataManga
    property int imageWidth: 210
    property int imageHeight: 315
    property int animTime: 500
    property int genresBorderWidth: 1

    property string previousThumbnail
    property string mangaLink

    id: mangaView
    
    Column {
        width: parent.width
        height: parent.height

        MangaToolBar {id: mangaToolBar}

        Flickable {
            id: flickableView

            width: parent.width
            height: parent.height
            contentHeight: dataManga.row.height + mangaChapters.height + mangaToolBar.height

            maximumFlickVelocity: normalMaximumFlickVelocity
            flickDeceleration: normalFlickDeceleration
            boundsBehavior: Flickable.OvershootBounds

            Column {
                anchors.fill: parent

                MangaData {id: dataManga}
                MangaChapters {id: mangaChapters}
            }
        }

        Connections {
            target: MangaViewer
            function onManga_data(mangaData, error) {
                var title = mangaData.title
                var author = mangaData.author
                var description = mangaData.description
                var thumbnail = mangaData.thumbnail
                var genres = mangaData.genres
                var total_chapters = mangaData.total_chapters
                var status = mangaData.current_status

                dataManga.image.source = previousThumbnail
                dataManga.title.text = title
                dataManga.author.authorText = author
                dataManga.status.statusText = status
                dataManga.genres.model = genres
                dataManga.description.descriptionText = description

                for (var i=0; i < total_chapters; i++) {
                    mangaChapters.spawnChapter(mangaData["chapters"]["chapter_" + (i + 1)])
                }
            }
        }

        Component.onDestruction: leftBar.visible = true
        Component.onCompleted: leftBar.visible = false
        
    }

    Keys.onEscapePressed: stackView.pop() // To exit.

    // To force focus.
    MouseArea {
        id: mouseArea
        z: -1

        width: parent.width
        height: parent.height

        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: parent.forceActiveFocus(), flickableView.interactive = true
    }
}