import QtQuick
import QtQuick.Controls

import Qt.labs.platform

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 23"
    readonly property string subHeaderText: "Using ColorDialog in QML."

    property color selectedColor: "blue"

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
        text: "Select Color"
        font.pointSize: ZoomSettings.bigFontSize
        anchors.top: colorPreview.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        onClicked: colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        currentColor: selectedColor
        onAccepted: selectedColor = colorDialog.currentColor
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
