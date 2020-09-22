import QtQuick 2.15
import QtQuick.Controls 2.15

Grid {
    id: flow_infinite
    onWidthChanged: {
        previous_columns = width / (button_width + spacing - (spacing / previous_columns))
        parent.leftPadding = ((width - columns * (button_width + spacing - (spacing / columns))) / 2) - spacing / 2
    }
    
    spacing: 20
    rowSpacing: 75
    columns: previous_columns
    width: parent.width

    Repeater {
        id: explore_infinite_repeater

        MangaTile{canAnimateTile: false}
    }

    Component.onCompleted: {
        NunnixManga.get_manga_infinite(nextPage)
    }

    Connections {
        target: NunnixManga

        function onInfinite_data(manga_data){
            isNotLoading = true

            var covers = manga_data[0]
            var names = manga_data[1]
            var links = manga_data[2]

            explore_infinite_repeater.model = names.length
            parent.opacity = 1

            for (var i=0; i < names.length; i++) {

                explore_infinite_repeater.itemAt(i).children[0].source = covers[i]
                explore_infinite_repeater.itemAt(i).children[1].text = names[i]
                explore_infinite_repeater.itemAt(i).manga_link = links[i]
            }
        }
    }

    function next() {
        nextPage += 1
        NunnixManga.get_manga_infinite(nextPage)

        for (var i=0; i < explore_infinite_repeater.model; i++) {
            explore_infinite_repeater.itemAt(i).resetTile()
        }
    }
}