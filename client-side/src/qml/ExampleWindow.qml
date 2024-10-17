import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import "qrc:/qml/singletons/"

Window {
    visible: true
    width: 500
    height: 300
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

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Label {
                text: "This window can be resized, maximized, and dragged around."
                font.pointSize: ZoomSettings.regularFontSize
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "A button that does nothing"
                font.pointSize: ZoomSettings.regularFontSize
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                placeholderText: "Enter text here"
                font.pointSize: ZoomSettings.regularFontSize
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
