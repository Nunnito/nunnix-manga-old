import QtQuick 2.15
import QtQuick.Controls 2.15

Label {
    property alias status: status

    id: status
    font.pixelSize: normalTextFontSize
    color: textColor
    bottomPadding: normalSpacing
}