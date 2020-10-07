import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    // MangaData alias
    property alias mangaData: mangaData
    property alias image: image
    property alias column: column
    property alias title: title
    property alias author: author
    property alias status: status
    property alias genres: genresData.genres
    property alias description: descriptionData
    property alias background: background
    property alias row: row
    id: mangaData

    width: parent.width
    height: row.height

    Background {id: background}

    Row {
        id: row

        width: parent.width
        padding: normalSpacing * 2
        spacing: normalSpacing
        
        ImageData {id: image}

        Column {
            id: column
            width: parent.width - (image.width + parent.spacing + parent.padding)

            TitleData {id: title}
            AuthorData {id: author}
            StatusData {id: status}
            GenresData {id: genresData}
            DescriptionData {id: descriptionData}
        }
    }
}