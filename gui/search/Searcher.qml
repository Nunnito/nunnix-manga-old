import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Flickable {
    property int buttonWidth: 140 * scale_factor
    property int buttonHeight: 210 * scale_factor
    property int previousColumns: 4

    property bool isNotLoading: false
    property int currentPage: 1
    
    anchors.fill: parent
    maximumFlickVelocity: 1000
    contentHeight: gridSearch.children.length == 0? parent.height:gridSearch.height

    onContentYChanged: {
        if ((visibleArea.yPosition >= 0.5 || contentHeight / 2 <= height) && isNotLoading) {
            NunnixManga.search_manga([], currentPage)
            currentPage += 1
            isNotLoading = false
        }
    }

    Grid {
        id: gridSearch
        spacing: 20
        rowSpacing: 75
        columns: previousColumns
        width: parent.width

        onWidthChanged: {
            previousColumns = width / (buttonWidth + spacing - (spacing / previousColumns))
            leftPadding = ((width - columns * (buttonWidth + spacing - (spacing / columns))) / 2) - spacing / 2
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: gridSearch.children.length == 0? true:false
        
    }
    
    Component.onCompleted: {
        NunnixManga.search_manga([], currentPage)
        currentPage += 1
    }

    function spawnTiles(size, dataSearch) {
        var component = Qt.createComponent("../widgets/MangaTile.qml")

        for (var i=0; i < size; i++) {
            var tile = component.createObject(gridSearch)
            tile.children[1].text = dataSearch[i].title
            tile.children[0].source = dataSearch[i].thumbnail
            tile.mangaLink = dataSearch[i].link
        }
    }
    
    Connections {
        target: NunnixManga
        function onSearch_manga_data(dataSearch) {
            spawnTiles(dataSearch.length, dataSearch)
            isNotLoading = true
        }
    }
}