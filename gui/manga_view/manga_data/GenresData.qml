import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    property alias genresData: genresData
    property alias label: label
    property alias flickable: flickable
    property alias categoryRow: categoryRow
    property alias genres: genres

    id: genresData
    width: parent.width

    Label {
        id: label
        text: "Genres"
        font.bold: true
    }

    Flickable {
        id: flickable

        clip: true
        width: parent.width - normalSpacing
        height: categoryRow.height

        contentWidth: categoryRow.width
        boundsBehavior: Flickable.OvershootBounds

        ScrollIndicator.horizontal: ScrollIndicator {active: true}

        Row {
            id: categoryRow

            bottomPadding: normalSpacing / 2
            spacing: normalSpacing / 2

            Repeater {
                id: genres

                Button {
                    text: modelData
                    flat: true
                    highlighted: true

                    onClicked: {
                        stackView.pop()
                        stackView.children[1].searchToolBar.searchLineEdit.searchInput.text = text
                        stackView.children[1].genSearchData(true)
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: parent.height - 10

                        color: "transparent"
                        border.color: primaryColor
                        border.width: 1
                    }
                }
            }
        }
    }
}