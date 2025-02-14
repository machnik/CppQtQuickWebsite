import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Window {
    visible: true
    width: 500
    height: 300
    title: Localization.string("Example Window")
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
                text: Localization.string("This window can be resized, maximized, and dragged around.")
                font.pointSize: ZoomSettings.regularFontSize
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: Localization.string("A button that does nothing")
                font.pointSize: ZoomSettings.regularFontSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 250
            }

            TextField {
                placeholderText: Localization.string("Enter text here")
                font.pointSize: ZoomSettings.regularFontSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 250
            }
        }
    }
}
