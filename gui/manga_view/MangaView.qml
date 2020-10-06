import QtQuick 2.15
import QtQuick.Controls 2.15
import "manga_data"

Column {
    property int imageWidth: 210
    property int imageHeight: 315
    property int animTime: 500
    property int genresBorderWidth: 1
    property string previousThumbnail

    MangaData {id: dataManga}

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
        }
    }

    
    MouseArea {
        width: parent.width
        height: parent.height
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: parent.forceActiveFocus()
    }
    

    Keys.onPressed: {
        if (event.key == Qt.Key_Escape) {
            stackView.pop()
        }
    }

    Component.onDestruction: leftBar.visible = true
    
    Component.onCompleted: leftBar.visible = false
    
}