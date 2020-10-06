import QtQuick 2.15
import QtQuick.Controls 2.15

Label {
    property alias title: title
    id: title

    width: parent.width
    font.pixelSize: bigTextFontSize
    font.bold: true

    color: textColor
    elide: Text.ElideRight

    bottomPadding: normalSpacing
    rightPadding: normalSpacing

    LoaderPlaceHolder {
        width: 250
        gradient.width: 200
        visible: !text
        interval: 1000
    }

    OpacityAnimator {id: opacityAnim; target: title; from: 0; to: 1; duration: animTime}
    onTextChanged: opacityAnim.start()
}