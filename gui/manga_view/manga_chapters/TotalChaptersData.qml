import QtQuick 2.15
import QtQuick.Controls 2.15
import "../manga_data"

Label {
    property alias totalChapters: totalChapters
    property string chapters
    id: totalChapters

    width: parent.width
    font.pixelSize: bigTextFontSize
    font.bold: true

    text: chapters == "" ? "" : chapters + qsTr(" chapters")
    color: textColor
    elide: Text.ElideRight

    bottomPadding: normalSpacing
    leftPadding: normalSpacing

    LoaderPlaceHolder {
        x: parent.leftPadding
        width: 150
        visible: chapters == ""
    }

    OpacityAnimator {id: opacityAnim; target: totalChapters; from: 0; to: 1; duration: animTime}
    onTextChanged: opacityAnim.start()
}