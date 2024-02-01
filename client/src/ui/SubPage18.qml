import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 18"
    readonly property string subHeaderText: "WebSocket Server."

    Connections {
        target: WebSocketServer
        function onBouncedMessage(message) {
            bouncedMessageField.text = message;
        }
        function onErrorOccurred(error) {
            console.log(error);
        }
    }

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

    TextField {
        id: portField
        placeholderText: "enter port number"
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        text: "START"
        checkable: true
        anchors.centerIn: parent
        onClicked: {
            WebSocketServer.startServer(parseInt(portField.text));
        }
    }

    TextField {
        id: bouncedMessageField
        placeholderText: "(last bounced message)"
        anchors.top: startButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
