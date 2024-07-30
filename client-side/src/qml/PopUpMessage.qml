import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

Dialog {
    id: popUpDialog
    width: 400; height: 300
    title: "Pop-up Window"
    font.pixelSize: ZoomSettings.bigFontSize
    modal: true
    closePolicy: Dialog.CloseOnEscape

    Label {
        anchors.fill: parent
        anchors.margins: 10
        width: parent.width
        wrapMode: Label.Wrap
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi."
    }

    footer: DialogButtonBox {
        standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel
        onAccepted: console.log("Accepted")
        onRejected: console.log("Rejected")
    }
}
