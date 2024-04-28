import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 14"
    readonly property string subHeaderText: "C++ backend object (singleton) is used to implement the button."

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        id: messageLabel
        text: Backend.message
        anchors.centerIn: parent
    }

    Button {
        text: "Change Message"
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
