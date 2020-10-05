import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "search_tool_bar"
import "advanced_search"
import "search_flickable"


Column {
    // Searcher alias.
    property alias searcher: searcher
    property alias searchToolBar: searchToolBar
    property alias advancedSearch: advancedSearch
    property alias searcherFlickable: searcherFlickable

    // Properties for SearchFlickable.
    property int buttonWidth: 140
    property int buttonHeight: 210
    property int previousColumns: 4
    property int reloadButtonWidth: 100
    property int reloadSmallButtonWidth: 75
    property int reloadButtonTextSize: 24
    property int reloadSmallButtonTextSize: 18
    property bool isInfo: false
    property bool isError: false
    property bool isSmallError: false
    property string errorText
    property string infoIconUrl

    // Properties for AdvancedSearch.
    property int advancedSearchWidth: 250 + normalSpacing
    property int advancedSearchStartX: mainWindow.width - advancedSearchWidth - leftBar.width
    property int advancedSearchEndX: mainWindow.width - leftBar.width
    property int controlWidth: 200
    property int searchTextInputHeight: 32
    property int rectSearchTextRadius: 5
    property int startBottomRectSearchTextHeight: 2
    property int endBottomRectSearchTextHeight: 3

    // Properties for SearchToolBar.
    property int toolbarHeight: 48
    property int searchInputRadius: 5
    property int iconSize: 24

    property int currentPage
    property bool isNewSearch
    property bool isLoading: false
    property bool isEnd: false
    property bool canFlickableSearch: true


    property string name: "searcher"
    property var searchData: {}  // Search data is stored here

    id: searcher

    SearchToolBar {id: searchToolBar}
    AdvancedSearch {id: advancedSearch}
    SearchFlickable {id: searcherFlickable}
    Footer {id: footer}

    // Function that generates the search data and stores it in searchData.
    function genSearchData(initPage) {
        // If the page is not loading.
        if (!isLoading) {
            isLoading = true
            isError = false
            isSmallError = false
            isInfo = false
            isEnd = false
 
            // If is a new search.
            if (initPage) {
                isNewSearch = true
                currentPage = 1
                
                // Destroy all the tiles.
                for (var i=0; i < searcherFlickable.container.children.length; i++){
                    searcherFlickable.container.children[i].destroy()
                }
                searcherFlickable.container.children.length = 0
            }

            // Create a new search.
            searchData = {}
            for (var i=0; i < advancedSearch.columnControls.children.length; i++) {
                var key = advancedSearch.columnControls.children[i].searchParameter
                var value = advancedSearch.columnControls.children[i].currentValue

                searchData[key] = value
            }
            searcherFlickable.smallBusyIndicator.visible = searcherFlickable.container.children.length != 0

            MangaSearcher.search_manga(JSON.stringify(searchData), currentPage)
            currentPage += 1
        }
    }

    // Function that resets search filters.
    function resetFilters() {
        for (var i=0; i < advancedSearch.columnControls.children.length; i++) {
            var defaultValue = advancedSearch.columnControls.children[i].defaultValue
            advancedSearch.columnControls.children[i].setDefault()
        }
    }
}