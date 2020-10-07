import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15

Column {
    property alias mangaChapters: mangaChapters
    id: mangaChapters

    width: parent.width - rightPadding * 2
    rightPadding: normalSpacing
    leftPadding: normalSpacing

    function spawnChapter(data) {
        var chapterButton = Qt.createComponent("ChapterButton.qml")
        var button = chapterButton.createObject(mangaChapters)

        button.chapterName = data.name
        button.chapterDate = data.upload_date
        button.chapterLink = data.link
    }
}