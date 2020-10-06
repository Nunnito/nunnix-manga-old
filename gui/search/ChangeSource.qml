import QtQuick 2.15
import QtQuick.Controls 2.15

// TEMPORAL CODE, FOR TESTING
ComboBox {
    property string currentSource: scraperData[currentText]
    property var sourceAlias: []
    property var sourceNames: []

    id: changeSource

    height: parent.height
    flat: true

    onActivated: {
        MangaSearcher.change_manga_source(currentSource, currentText)
        isLoading = false
        genSearchData(true)
    }
    
    Component.onCompleted: {
        for (var scraperAlias in scraperData) {
            sourceAlias.push(scraperAlias)
            sourceNames.push(scraperData[scraperAlias])
        }
        changeSource.model = sourceAlias
        changeSource.currentIndex = indexOfValue(configFile.scrapers.current_alias)
        MangaSearcher.emit_controls()
    }
}