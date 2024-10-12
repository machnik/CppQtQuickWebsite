import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

Dialog {
    id: messageDialog
    width: 400; height: 300
    font.pixelSize: ZoomSettings.bigFontSize
    modal: true
    title: "Message"

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        spacing: 10

        Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: "This is a message dialog."
        }

        Button {
            text: "OK"
            onClicked: messageDialog.close()
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
