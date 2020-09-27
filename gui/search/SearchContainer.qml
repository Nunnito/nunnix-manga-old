import QtQuick 2.15
import QtQuick.Controls 2.15

Grid {
    id: gridSearch
    spacing: normalSpacing
    rowSpacing: gridSearchRowSpacing
    columns: previousColumns
    width: parent.width

    onWidthChanged: {
        previousColumns = width / (buttonWidth + spacing - (spacing / previousColumns))
        leftPadding = ((width - columns * (buttonWidth + spacing - (spacing / columns))) / 2) - spacing / 2
    }
}