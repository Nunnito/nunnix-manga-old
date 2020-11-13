import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: reader
    Column {
        SwipeReader {id: swipeReader}
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
}