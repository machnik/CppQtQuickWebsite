import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

Dialog {
    id: messageDialog
    width: 400; height: 300
    font.pixelSize: ZoomSettings.bigFontSize
    modal: true
    title: "Message"
    spacing: 10

    Text {
        text: "This is a message dialog."
        font.pixelSize: ZoomSettings.bigFontSize
        anchors.centerIn: parent
    }

    Button {
        text: "OK"
        onClicked: messageDialog.close()
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }
}
