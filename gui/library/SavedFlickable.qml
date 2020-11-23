import QtQuick 2.15
import QtQuick.Controls 2.15
import "../search/search_flickable/"

Flickable {
    property alias savedFlickable: savedFlickable
    property alias savedColumn: savedColumn
    property alias container: container

    property int buttonWidth: 140
    property int buttonHeight: 210
    property int previousColumns: 4

    id: savedFlickable

    width: parent.width
    height: parent.height

    topMargin: normalSpacing * 2
    bottomMargin: normalSpacing * 2
    leftMargin: normalSpacing

    contentHeight: savedColumn.height
    boundsMovement: Flickable.StopAtBounds
    interactive: false

    Column {
        id: savedColumn

        width: parent.width
        spacing: normalSpacing * 2

        SearchContainer {id: container}
    }

    Connections {
        target: MangaLibrary
        
        function onSet_save_manga(thumbnail, title, link) {
            var component = Qt.createComponent("../mangatile/MangaTile.qml")
            var tile = component.createObject(container)

            tile.title = title                 // Tile title.
            tile.thumbnail.source = thumbnail  // Tile thumbnail.
            tile.mangaLink = link              // Tile link.
        }
    }
}