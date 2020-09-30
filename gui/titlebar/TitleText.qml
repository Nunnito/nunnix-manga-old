import QtQuick 2.15
import QtQuick.Controls 2.15

Label {
    property alias titleLabel: titleLabel
    id: titleLabel

	anchors.centerIn: parent
	
	text: "Nunnix Manga"
	color: textColor

	font.pixelSize: normalTextFontSize
	font.bold: true
}