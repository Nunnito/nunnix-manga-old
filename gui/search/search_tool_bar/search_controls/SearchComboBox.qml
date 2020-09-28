import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick 2.15

Column {
    Material.background: surfaceColor
    topPadding: text.text ? normalSpacing : 0

    Text {
        id: text

        font.pixelSize: normalTextFontSize
        color: textColor
    }

    ComboBox {
        id: comboBox
        property string searchParameter
    }
}