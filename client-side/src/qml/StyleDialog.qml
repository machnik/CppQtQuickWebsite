import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

Dialog {
    id: styleDialog
    width: 400
    height: 300
    anchors.centerIn: parent
    title: "Style Dialog"
    font.pixelSize: ZoomSettings.hugeFontSize
    modal: true
    closePolicy: Dialog.CloseOnEscape

    Label {
        width: parent.width
        anchors.centerIn: parent
        anchors.margins: 10
        wrapMode: Label.Wrap
        text: "This dialog is a placeholder for a future feature that will allow the user to change the visual style of the application."
        font.pixelSize: ZoomSettings.bigFontSize
        font.italic: true
    }

    Button {
        text: "Close"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
        font.pointSize: ZoomSettings.bigFontSize
        onClicked: styleDialog.close()
    }
}
