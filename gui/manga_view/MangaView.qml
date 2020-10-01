import QtQuick 2.15
import QtQuick.Controls 2.15

Column {

    Button {
        onClicked: stackView.pop()
    }
    
    Connections {
        target: NunnixManga
        function onManga_data(mangaData, error) {
            print(mangaData.title)
        }
    }
}