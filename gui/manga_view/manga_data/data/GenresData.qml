import QtQuick 2.15
import QtQuick.Controls 2.15

// Genres data
Column {
    property alias genresData: genresData
    property alias label: label
    property alias flickable: flickable
    property alias categoryRow: categoryRow
    property alias genres: genres

    property var model: genres.model

    id: genresData
    width: parent.width

    // Genres label
    Label {
        id: label
        text: qsTr("Genres")
        font.bold: true
        opacity: genres.model != null
    }

    // Flickable, if there is no space available
    Flickable {
        id: flickable

        clip: true
        width: parent.width - normalSpacing
        height: categoryRow.height

        contentWidth: categoryRow.width
        boundsBehavior: Flickable.OvershootBounds

        // Scroll indicator
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
                        leftBar.visible = true
                        stackView.children[1].searchToolBar.searchLineEdit.searchInput.text = text
                        stackView.children[1].genSearchData(true)
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: parent.height - 10

                        color: "transparent"
                        border.color: primaryColor
                        border.width: genresBorderWidth
                    }
                }
            }

            // Loader placeholder
            LoaderPlaceHolder {
                width: genresData.width - normalSpacing
                height: 50
                visible: genres.model == null
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            propagateComposedEvents: true

            onEntered: {
                if (flickable.contentWidth > flickable.width) {
                    flickableView.interactive = false
                }
            }
        }
    }

    OpacityAnimator {id: opacityAnim; target: genresData; from: 0; to: 1; duration: animTime}
    onModelChanged: {
        if (model != null) {
            opacityAnim.start()
        }
    }
}