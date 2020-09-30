import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "search_tool_bar"
import "advanced_search"
import "search_flickable"


Column {
    property int buttonWidth: 140
    property int buttonHeight: 210
    property int previousColumns: 4
    property int reloadButtonWidth: 100
    property int reloadSmallButtonWidth: 75
    property int reloadButtonTextSize: 24
    property int reloadSmallButtonTextSize: 18

    property int currentPage
    property bool isNewSearch
    property bool isLoading: false
    property bool isEnd: false
    property bool canFlickableSearch: true

    property int advancedSearchWidth: 250 + normalSpacing
    property int advancedSearchStartX: mainWindow.width - advancedSearchWidth - leftBar.width
    property int advancedSearchEndX: mainWindow.width - leftBar.width

    property string name: "searcher"
    property var searchData: {}

    SearchToolBar {id: searchToolBar}
    AdvancedSearch {id: advancedSearch}
    SearchFlickable {id: searcherFlickable}

    function genSearchData(initPage) {
        if (!isLoading) {
            isLoading = true

            if (initPage) {
                isNewSearch = true
                isEnd = false
                currentPage = 1
                
                for (var i=0; i < searcherFlickable.container.children.length; i++){
                    searcherFlickable.container.children[i].destroy()
                }
                searcherFlickable.busyIndicator.running = true
            }

            searchData = {}
            for (var i=0; i < advancedSearch.columnControls.children.length; i++) {
                var key = advancedSearch.columnControls.children[i].searchParameter
                var value = advancedSearch.columnControls.children[i].currentValue

                searchData[key] = value
            }
            NunnixManga.search_manga(JSON.stringify(searchData), currentPage)
            currentPage += 1

            searcherFlickable.reloadButton.visible = false
            searcherFlickable.infoIcon.visible = false
            searcherFlickable.busyIndicator.running = true
            searcherFlickable.smallReloadButton.visible = false
            searcherFlickable.smallBusyIndicator.running = false
            searcherFlickable.infoIcon.visible = false
        }
    }

    function resetFilters() {
        for (var i=0; i < advancedSearch.columnControls.children.length; i++) {
            var defaultValue = advancedSearch.columnControls.children[i].defaultValue
            advancedSearch.columnControls.children[i].setDefault()
        }
    }
}