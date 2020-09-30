import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property alias searchFlickable: searchFlickable
    property alias reloadButton: reloadButton
    property alias infoIcon: infoIcon
    property alias container: container

    property alias searchColumn: searchColumn
    property alias smallBusyIndicator: smallBusyIndicator
    property alias smallReloadButton: smallReloadButton
    property alias busyIndicator: busyIndicator

    id: searchFlickable
    width: parent.width
    height: parent.height

    topMargin: normalSpacing * 2
    bottomMargin: normalSpacing * 3
    leftMargin: normalSpacing

    maximumFlickVelocity: 1000
    interactive: !reloadButton.visible
    contentHeight: container.children.length == 0 ? parent.height : searchColumn.height
    contentWidth: width - normalSpacing

    Column {
        id: searchColumn

        width: parent.width
        spacing: normalSpacing * 2

        SearchContainer {id: container}
        BusyIndicator {
            id: smallBusyIndicator
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ReloadButton {
            id: smallReloadButton
            isSmall: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


    ReloadButton {id: reloadButton}
    InfoIcon {id: infoIcon}
    BusyIndicator {
        id: busyIndicator
        x: reloadButton.x + 60
        y: reloadButton.y + 20
    }

    Component.onCompleted: {
        genSearchData(true)
    }

    Connections {
        target: NunnixManga
        function onSearch_manga_data(dataSearch, error) {
            if (dataSearch[0] != null) {
                spawnTiles(dataSearch.length, dataSearch)

                isLoading = false
                canFlickableSearch = true
                isNewSearch = false
                busyIndicator.running = false
                smallBusyIndicator.visible = true
            }
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
                        showReloadButton(false, error)
                    }
                    else {
                        showReloadButton(true, error)
                    }
                }
            }
        }
    }

    function spawnTiles(size, dataSearch) {
        var component = Qt.createComponent("../../mangatile/MangaTile.qml")

        for (var i=0; i < size; i++) {
            var tile = component.createObject(container)

            tile.label.text = dataSearch[i].title
            tile.thumbnail.source = dataSearch[i].thumbnail
            tile.mangaLink = dataSearch[i].link
        }
    }

    function showReloadButton(isSmall, error) {
        canFlickableSearch = false
        isLoading = false

        if (isSmall) {
            smallReloadButton.visible = true
            smallReloadButton.label.text = error
            smallBusyIndicator.visible = false
        }
        else {
            reloadButton.visible = true
            reloadButton.label.text = error
            busyIndicator.running = false
        }
    }

    function showInfoIcon(iconUrl, textInfo) {
            isLoading = false
            busyIndicator.running = false

            infoIcon.visible = true
            infoIcon.label.text = textInfo
            infoIcon.icon.source = Qt.resolvedUrl(iconUrl)
    }

    function reconnect(isSmall) {
        isLoading = false
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
        if (isNearEnd && !isEnd) {
            smallBusyIndicator.running = true
        }
        else {
            smallBusyIndicator.running = false
        }
    }
}