import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "search_tool_bar"


Column {
    property int buttonWidth: 140
    property int buttonHeight: 210
    property int gridSearchRowSpacing: 75
    property int previousColumns: 4
    property int reloadButtonWidth: 100
    property int reloadSmallButtonWidth: 75
    property int reloadButtonTextSize: 24
    property int reloadSmallButtonTextSize: 18

    property int currentPage: 1
    property bool isNotLoading: false
    property bool isStartup: true

    property int advancedSearchStartX: mainWindow.width / 2 - leftBar.width
    property int advancedSearchEndX: mainWindow.width - leftBar.width

    property string name: "searcher"

    SearchToolBar {}
    SearchFlickable {}
    AdvancedSearch {id: advancedSearch}
}