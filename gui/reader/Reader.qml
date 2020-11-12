import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: reader
    Column {
        SwipeReader {id: swipeReader}
    }


    Shortcut {
        enabled: stackView.currentItem == reader
        sequence: StandardKey.Cancel

        onActivated: stackView.pop()
    }
}