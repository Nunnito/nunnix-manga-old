import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property int chapterIndex
    property string chapterLink
    property int currentIndex
    property int totalPages

    id: reader

    Column {
        height: reader.height
        width: reader.width

        SwipeReader {id: swipeReader}
        ControlsBar {id: controlsBar}
    }

    ScrollBar {
        id: scrollBar
        z: 1
        x: reader.width - width

        policy: ScrollBar.AlwaysOn
        height: reader.height

        background: Rectangle {
            color: surfaceColor2
        }
    }

    Shortcut {
        enabled: stackView.currentItem == reader
        sequence: StandardKey.Cancel

        onActivated: stackView.pop()
    }
    Shortcut {
        enabled: stackView.currentItem == reader
        sequence: StandardKey.ZoomOut

        onActivated: swipeReader.zoomOut()
    }
    Shortcut {
        enabled: stackView.currentItem == reader
        sequence: StandardKey.ZoomIn

        onActivated: swipeReader.zoomIn()
    }

    onCurrentIndexChanged: {
        if (currentIndex == totalPages - 1) {
            stackView.children[StackView.index - 1].mangaChapters.children[chapterIndex].read = true
        }
    }
}