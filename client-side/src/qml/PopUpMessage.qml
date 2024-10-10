import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

Popup {
    id: popUpMessage
    width: 400; height: 300
    font.pixelSize: ZoomSettings.bigFontSize
    modal: true

    Column {
        anchors.fill: parent
        anchors.margins: 10

        Label {
            width: parent.width
            wrapMode: Label.Wrap
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam."
        }

        DialogButtonBox {
            standardButtons: DialogButtonBox.Ok
            onAccepted: popUpMessage.close()
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
