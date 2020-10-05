import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    // Search flickable alias
    property alias searchFlickable: searchFlickable
    property alias reloadButton: reloadButton
    property alias infoIcon: infoIcon
    property alias container: container

    property alias searchColumn: searchColumn
    property alias smallBusyIndicator: smallBusyIndicator
    property alias smallReloadButton: smallReloadButton
    property alias busyIndicator: busyIndicator

    id: searchFlickable

    // Search flickable properties
    width: parent.width
    height: parent.height - (searchToolBar.height + footer.height)

    topMargin: normalSpacing * 2
    bottomMargin: normalSpacing * 2
    leftMargin: normalSpacing

    maximumFlickVelocity: normalMaximumFlickVelocity
    flickDeceleration: normalFlickDeceleration
    boundsBehavior: Flickable.OvershootBounds
    interactive: (!reloadButton.visible && !busyIndicator.visible && !infoIcon.visible)
    contentHeight: container.children.length == 0 ? parent.height : searchColumn.height
    contentWidth: width - normalSpacing

    Column {
        id: searchColumn

        width: parent.width
        spacing: normalSpacing * 2

        SearchContainer {id: container}  // Here are all the tiles.

        // Load at the end.
        BusyIndicator {
            id: smallBusyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }

        // Load at the end in an error.
        ReloadButton {
            id: smallReloadButton
            isSmall: true
            anchors.horizontalCenter: parent.horizontalCenter

            visible: isSmallError
            label.text: errorText
        }
    }

    // Appears in an error.
    ReloadButton {
        id: reloadButton

        visible: isError
        label.text: errorText
    }
    InfoIcon {
        id: infoIcon

        visible: isInfo
        label.text: errorText
        icon.source: infoIconUrl
    }

    // Appears in a new search.
    BusyIndicator {
        id: busyIndicator
        x: reloadButton.x + 60
        y: reloadButton.y + 20

        visible: !reloadButton.visible && !infoIcon.visible && container.children.length == 0
    }

    Component.onCompleted: {
        genSearchData(true)
    }

    Connections {
        target: MangaSearcher
        function onSearch_manga_data(dataSearch, error) {
            smallBusyIndicator.visible = false
            isLoading = false

            // If dataSearch is not empty
            if (dataSearch[0] != null) {
                isNewSearch = false
                canFlickableSearch = true

                // Create dataSearch.length tiles
                spawnTiles(dataSearch.length, dataSearch)
            }
            // If there is an error.
            if (error != "") {
                isEnd = true
                canFlickableSearch = false

                if (error == "HTTP error 404") {
                    isInfo = isNewSearch
                    infoIconUrl = "../../../resources/search_off.svg"
                    errorText = qsTr("No results found!")
                }
                else {
                    errorText = error
                    isError = isNewSearch        // Show reload button
                    isSmallError = !isNewSearch  // Show small reload button
                }
            }
        }
    }

    // Dynamically creates new tiles.
    function spawnTiles(size, dataSearch) {
        var component = Qt.createComponent("../../mangatile/MangaTile.qml")

        for (var i=0; i < size; i++) {
            var tile = component.createObject(container)

            tile.label.text = dataSearch[i].title            // Tile title.
            tile.thumbnail.source = dataSearch[i].thumbnail  // Tile thumbnail.
            tile.mangaLink = dataSearch[i].link              // Tile link.
        }
    }

    onContentYChanged: {
        var visibleContentHeight = (contentY + height - topMargin) / contentHeight
        var isNearEnd = contentHeight - container.height / (currentPage - 1) <= contentY

        if (visibleContentHeight >= 0.9 && !isEnd && canFlickableSearch) {
            genSearchData(false)
        }
    }
}