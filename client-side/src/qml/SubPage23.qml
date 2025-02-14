import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(23)
    readonly property string subHeaderText: Localization.string("Using ColorDialog in QML.")

    property color selectedColor: "blue"

    color: "transparent"

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    Rectangle {
        id: colorPreview
        width: 160
        height: 160
        color: selectedColor
        anchors.centerIn: parent
        border.width: 3
        radius: 12
    }

    Button {
        text: Localization.string("Select Color")
        font.pointSize: ZoomSettings.bigFontSize
        anchors.top: colorPreview.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        onClicked: colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        selectedColor: selectedColor
        onAccepted: selectedColor = colorDialog.selectedColor
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
