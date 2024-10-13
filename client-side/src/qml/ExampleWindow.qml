import QtQuick
import QtQuick.Window

import "qrc:/qml/singletons/"

Window {
    visible: true
    width: 500
    height: 350
    title: "Example Window"
    visibility: Window.Windowed
    flags: Qt.Window |
           Qt.WindowTitleHint |
           Qt.WindowSystemMenuHint |
           Qt.WindowMinMaxButtonsHint |
           Qt.WindowCloseButtonHint |
           Qt.WindowResizeBorderHint

    Rectangle {
        anchors.fill: parent
        color: "lightgray"

        Text {
            anchors.centerIn: parent
            text: "This is an example window."
            font.pixelSize: ZoomSettings.hugeFontSize
            font.italic: true
        }
    }
}
