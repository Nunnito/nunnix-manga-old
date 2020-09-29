import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    width: parent.width
    height: parent.height
    maximumFlickVelocity: 1000
    topMargin: normalSpacing * 2
    bottomMargin: normalSpacing * 2
    leftMargin: normalSpacing
    interactive: !reloadButton.visible
    contentHeight: gridSearch.children.length == 0? parent.height:searchColumn.height
    contentWidth: width - normalSpacing

    Column {
        id: searchColumn
        width: parent.width
        spacing: normalSpacing * 2

        SearchContainer {id: gridSearch}

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

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: true
    }

    ReloadButton {id: reloadButton; anchors.centerIn: parent}

    Component.onCompleted: {
        advancedSearch.genSearchData(true)
    }

    Connections {
        target: NunnixManga
        function onSearch_manga_data(dataSearch, error) {
            if (dataSearch[0] != null) {
                spawnTiles(dataSearch.length, dataSearch)
                isNotLoading = true
                isStartup = false
                busyIndicator.running = false
                smallBusyIndicator.visible = true
            }
            if (error != "") {
                if (isStartup) {
                    showReloadButton(false, error)
                }
                else {
                    showReloadButton(true, error)
                }
            }
        }
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

    function showReloadButton(isSmall, error) {
        if (isSmall) {
            smallReloadButton.visible = true
            smallReloadButton.children[1].text = error
            smallBusyIndicator.visible = false
        }
        else {
            reloadButton.visible = true
            reloadButton.children[1].text = error
            busyIndicator.running = false
        }
    }

    function reconnect(isSmall) {
        advancedSearch.genSearchData(false)

        if (isSmall) {
            smallReloadButton.visible = false
            smallBusyIndicator.visible = true
        }
        else {
            reloadButton.visible = false
            busyIndicator.running = true
        }
    }

    onContentYChanged: {
        var visibleContentHeight = (contentY + height - topMargin) / contentHeight
        var isNearEnd = contentHeight - gridSearch.height / (currentPage - 1) <= contentY

        if (isNearEnd && isNotLoading) {
            advancedSearch.genSearchData(false)
            isNotLoading = false
        }
        if (visibleContentHeight >= 0.9) {
            smallBusyIndicator.running = true
        }
        else {
            smallBusyIndicator.running = false
        }
    }
}