import QtQuick 2.15
import QtQuick.Controls 2.15

// Author data
Label {
    property alias author: author
    property string authorText

    id: author
    text: " "
    font.pixelSize: normalTextFontSize
    color: textColor

    LoaderPlaceHolder {
        width: 150
        visible: !authorText
    }

    OpacityAnimator {id: opacityAnim; target: author; from: 0; to: 1; duration: animTime}

    onAuthorTextChanged: text = "<b>" + qsTr("Author: ") + "</b>" + authorText, opacityAnim.start()
}