import QtQuick 2.15
import QtQuick.Controls 2.15
import "../search/search_flickable/"


Column {
    property string name: "library"

    SavedFlickable {id: savedFlickable}

    Component.onCompleted: MangaLibrary.get_saved_mangas()    
}