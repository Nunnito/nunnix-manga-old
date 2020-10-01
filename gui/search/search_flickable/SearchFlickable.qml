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
    height: parent.height

    topMargin: normalSpacing * 2
    bottomMargin: normalSpacing * 3
    leftMargin: normalSpacing

    maximumFlickVelocity: normalMaximumFlickVelocity
    flickDeceleration: normalFlickDeceleration
    boundsBehavior: Flickable.OvershootBounds
    interactive: (!reloadButton.visible && !busyIndicator.running)
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
            running: false
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Load at the end in an error.
        ReloadButton {
            id: smallReloadButton
            isSmall: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Appears in an error.
    ReloadButton {id: reloadButton}
    InfoIcon {id: infoIcon}

    // Appears in a new search.
    BusyIndicator {
        id: busyIndicator
        x: reloadButton.x + 60
        y: reloadButton.y + 20
    }

    Component.onCompleted: {
        print(maximumFlickVelocity)
        genSearchData(true)
    }

    Connections {
        target: NunnixManga
        function onSearch_manga_data(dataSearch, error) {
            // If dataSearch is not empty
            if (dataSearch[0] != null) {
                // Create dataSearch.length tiles
                spawnTiles(dataSearch.length, dataSearch)

                isLoading = false
                canFlickableSearch = true
                isNewSearch = false
                busyIndicator.running = false
                smallBusyIndicator.visible = true
            }
            // If there is an error.
            if (error != "") {
                if (error == "HTTP error 404") {
                    if (isNewSearch) {
                        showInfoIcon("../../../resources/search_off.svg", qsTr("No results found!"))
                    }
                    else {
                        smallBusyIndicator.running = false
                        isLoading = false
                        isEnd = true
                    }
                }
                else {
                    if (isNewSearch) {
                        // Show reload button
                        showReloadButton(false, error)
                    }
                    else {
                        // Show small reload button
                        showReloadButton(true, error)
                    }
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

    // Show reload button.
    function showReloadButton(isSmall, error) {
        canFlickableSearch = false
        isLoading = false

        // Show small reload button.
        if (isSmall) {
            smallReloadButton.visible = true
            smallReloadButton.label.text = error
            smallBusyIndicator.visible = false
        }

        // Show normal reload button.
        else {
            reloadButton.visible = true
            reloadButton.label.text = error
            busyIndicator.running = false
        }
    }

    // Show information icon.
    function showInfoIcon(iconUrl, textInfo) {
            isLoading = false
            busyIndicator.running = false

            infoIcon.visible = true
            infoIcon.label.text = textInfo
            infoIcon.icon.source = Qt.resolvedUrl(iconUrl)
    }

    // Reconnect function.
    function reconnect(isSmall) {
        isLoading = false
        currentPage -= 1
        genSearchData(false)

        if (isSmall) {
            smallReloadButton.visible = false
            smallBusyIndicator.visible = true
        }
        else {
            reloadButton.visible = false
            infoIcon.visible = false
            busyIndicator.running = true
        }
    }

    onContentYChanged: {
        var visibleContentHeight = (contentY + height - topMargin) / contentHeight
        var isNearEnd = contentHeight - container.height / (currentPage - 1) <= contentY

        if (isNearEnd && !isEnd && canFlickableSearch) {
            genSearchData(false)
        }
        if (visibleContentHeight >= 0.9 && !isEnd) {
            smallBusyIndicator.running = true
        }
        else {
            smallBusyIndicator.running = false
        }
    }
}