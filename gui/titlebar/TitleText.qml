import QtQuick 2.15
import QtQuick.Controls 2.15

// Title bar label.
Label {
    property alias titleLabel: titleLabel
    id: titleLabel

	anchors.centerIn: parent
	
	text: mainWindow.title
	color: textColor

	font.pixelSize: normalTextFontSize
	font.bold: true
}