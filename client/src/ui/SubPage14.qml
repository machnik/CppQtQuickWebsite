import QtQuick
import QtQuick.Controls

import CppQtQuickWebpage.Backend

Page {
    id: subPage14

    Label {
        id: headerLabel
        text: "SubPage 14"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "C++ backend object (singleton) is used to implement the button."
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
