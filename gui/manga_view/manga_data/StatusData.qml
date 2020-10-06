import QtQuick 2.15
import QtQuick.Controls 2.15

Label {
    property alias status: status
    property string statusText: statusText

    id: status
    text: " "
    
    font.pixelSize: normalTextFontSize
    color: textColor
    bottomPadding: normalSpacing

    LoaderPlaceHolder {
        width: 100
        height: font.pixelSize
        gradient.width: 75
        interval: 500
        visible: !statusText
    }

    OpacityAnimator {id: opacityAnim; target: status; from: 0; to: 1; duration: animTime}

    onStatusTextChanged: text = "<b>" + qsTr("Status: ") + "</b>" + statusText, opacityAnim.start()
}