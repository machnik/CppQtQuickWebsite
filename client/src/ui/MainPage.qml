import QtQuick
import QtQuick.Controls

import CppQtQuickWebpage.Backend

Page {
    id: mainPage

    Label {
        id: headerLabel
        text: "Main Page"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "C++ backend is used to implement the button."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: Backend.message
        anchors.centerIn: parent
    }

    Button {
        text: "Change Message"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: Backend.setMessage("Message Changed!")
    }

    Component.onCompleted: {
        Backend.message = "Hello World!"
    }
}
