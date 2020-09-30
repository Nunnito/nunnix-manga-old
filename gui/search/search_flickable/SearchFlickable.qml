import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    property alias reloadButton: reloadButton
    property alias container: container

    property alias searchColumn: searchColumn
    property alias smallBusyIndicator: smallBusyIndicator
    property alias smallReloadButton: smallReloadButton
    property alias busyIndicator: busyIndicator

    width: parent.width
    height: parent.height

    topMargin: normalSpacing * 2
    bottomMargin: normalSpacing * 2
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


    BusyIndicator {id: busyIndicator; anchors.centerIn: parent}
    ReloadButton {id: reloadButton; anchors.centerIn: parent}

    Component.onCompleted: {
        genSearchData(true)
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
        var component = Qt.createComponent("../../widgets/MangaTile.qml")

        for (var i=0; i < size; i++) {
            var tile = component.createObject(container)

            tile.label.text = dataSearch[i].title
            tile.thumbnail.source = dataSearch[i].thumbnail
            tile.mangaLink = dataSearch[i].link
        }
    }

    function showReloadButton(isSmall, error) {
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

    function reconnect(isSmall) {
        isNotLoading = true
        genSearchData(false)

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
        var isNearEnd = contentHeight - container.height / (currentPage - 1) <= contentY

        if (isNearEnd) {
            genSearchData(false)
        }
        if (visibleContentHeight >= 0.9) {
            smallBusyIndicator.running = true
        }
        else {
            smallBusyIndicator.running = false
        }
    }
}