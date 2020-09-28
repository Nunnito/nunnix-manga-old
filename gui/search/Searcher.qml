import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15


Column {
    property int buttonWidth: 140 * scaleFactor
    property int buttonHeight: 210 * scaleFactor
    property int gridSearchRowSpacing: 75 * scaleFactor
    property int previousColumns: 4
    property int reloadButtonWidth: 100 * scaleFactor
    property int reloadSmallButtonWidth: 75 * scaleFactor
    property int reloadButtonTextSize: 24 * scaleFactor
    property int reloadSmallButtonTextSize: 18 * scaleFactor

    property bool isNotLoading: false
    property bool isStartup: true
    property int currentPage: 1

    width: parent.width
    height: parent.height

    SearchToolBar {}
    SearchFlickable {}
}