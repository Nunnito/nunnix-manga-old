import QtQuick 2.15
import QtQuick.Controls 2.15

Column {

    Button {
        onClicked: stackView.pop()
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
            var current_state = mangaData.current_state
        }
    }
}