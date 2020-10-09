import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15

Column {
    property alias mangaChapters: mangaChapters
    property int currentIndex: 0
    id: mangaChapters
    width: parent.width

    function spawnChapter(data) {
        var chapterButton = Qt.createComponent("chapter_button/ChapterButton.qml")
        var button = chapterButton.createObject(mangaChapters)

        button.chapterName = data.name
        button.chapterDate = data.upload_date
        button.chapterLink = data.link
        button.index = currentIndex

        currentIndex += 1
    }

    function swap() {
        rotation += 180

        for (var i=0; i < children.length; i++) {
            children[i].rotation += 180
        }
    }
}