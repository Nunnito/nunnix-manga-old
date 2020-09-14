import QtQuick 2.15
import QtQuick.Controls 2.15

Grid {
    id: flow_infinite
    onWidthChanged: {
        previous_columns = width / (button_width + spacing - (spacing / previous_columns))
        parent.leftPadding = ((width - columns * (button_width + spacing - (spacing / columns))) / 2) - spacing / 2
    }

    Button {
        width: 140
        onClicked: {
            for (var i=0; i < test.length; i++){
                test[i].destroy()
            }
            test = []
            nextPage = 0
        }
    }
    
    spacing: 20
    rowSpacing: 75
    columns: previous_columns
    width: parent.width

    Component.onCompleted: {
        NunnixManga.get_manga_infinite(nextPage)
    }

    Connections {
        target: NunnixManga

        function onInfinite_data(manga_data){
            isNotLoading = true
            var component
            var manga_tile

            var covers = manga_data[0]
            var names = manga_data[1]
            var links = manga_data[2]

            component = Qt.createComponent("MangaTile.qml")
            parent.opacity = 1

            for (var i=0; i < names.length; i++) {
                manga_tile = component.createObject(flow_infinite)
                manga_tile.canAnimateTile = false

                manga_tile.children[0].source = covers[i]
                manga_tile.children[1].text = names[i]
                manga_tile.children.manga_link = links[i]
                test.push(manga_tile)
            }
        }
    }

    function next() {
        nextPage += 1
        NunnixManga.get_manga_infinite(nextPage)
    }
}