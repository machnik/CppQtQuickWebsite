import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: "SubPage 8"
    readonly property string subHeaderText: "C++ backend object (singleton) is used to implement the button."

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

    Label {
        id: messageLabel
        text: Backend.message
        font.pointSize: ZoomSettings.bigFontSize
        anchors.centerIn: parent
    }

    Button {
        text: "Change Message"
        font.pointSize: ZoomSettings.bigFontSize
        anchors.top: messageLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: Backend.setMessage("Message Changed!")
    }

    Component.onCompleted: {
        Backend.message = "Hello World!"
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
