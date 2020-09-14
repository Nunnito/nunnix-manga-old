import QtQuick 2.15
import QtQuick.Controls 2.15

Flow {
    id: flow_infinite
    spacing: 50
    width: parent.width

    property int nextPage: 1

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

            component = Qt.createComponent("../reusable-components/MangaTile.qml")

            for (var i=0; i < names.length; i++) {
                manga_tile = component.createObject(flow_infinite)
                manga_tile.canAnimateTile = false

                manga_tile.children[0].source = covers[i]
                manga_tile.children[1].text = names[i]
                manga_tile.children.manga_link = links[i]
            }
        }
    }

    function next() {
        nextPage += 1
        NunnixManga.get_manga_infinite(nextPage)
    }
}