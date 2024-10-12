import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

Window {
    id: exampleWindow
    width: 400
    height: 300
    x: 100
    y: 100
    title: "Example Window"
    //icon: "qrc:/resources/icons/windowIcon.svg"

    Label {
        width: parent.width
        anchors.centerIn: parent
        anchors.margins: 20
        wrapMode: Label.Wrap
        text: "This is an example window."
        font.pixelSize: ZoomSettings.hugeFontSize
        font.italic: true
    }

    Button {
        text: "Close"
    }
}
