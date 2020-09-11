import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

GridLayout {
    Material.accent: "#2A2A2A"
    width: parent.width
    columns: 3

    Text {
        id: title_slider_text
        color: "white"
        font.pixelSize: slider_title_size_font
        Layout.fillWidth: true
    }
    RoundButton {
        highlighted: true
        icon.source: "../resources/chevron_left.svg"

        width: nav_button_size
        height: nav_button_size
        icon.width: nav_button_size
        icon.height: nav_button_size

        onClicked: parent.children[3].flick(main_window.width, 0)
    }
    RoundButton {
        highlighted: true
        icon.source: "../resources/chevron_right.svg"

        width: nav_button_size
        height: nav_button_size
        icon.width: nav_button_size
        icon.height: nav_button_size

        onClicked: parent.children[3].flick(-main_window.width, 0)
    }
    MangaSlider{}
}