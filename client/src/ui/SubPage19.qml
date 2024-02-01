import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 19"
    readonly property string subHeaderText: "WebSocket Client."

    Connections {
        target: WebSocketClient
        function onMessageReceived(message) {
            receivedMessageField.text = message
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
            WebSocketClient.startClient("ws://localhost:" + portField.text);
        }
    }

    TextField {
        id: messageToSendField
        placeholderText: "enter message to send"
        anchors.top: startButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: sendButton
        text: "SEND"
        anchors.top: messageToSendField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            WebSocketClient.sendMessage(messageToSendField.text);
        }
    }

    TextField {
        id: receivedMessageField
        placeholderText: "(last received message)"
        anchors.top: sendButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
