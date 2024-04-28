import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 19"
    readonly property string subHeaderText: "WebSocket Client."

    function resetTextFields() {
        messageToSendField.text = ""
        receivedMessageField.text = ""
        errorField.text = ""
    }

    Connections {
        target: WebSocketClient
        function onMessageReceived(message) {
            receivedMessageField.text = message
        }
        function onErrorOccurred(error) {
            errorField.text = error
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
        text: "12345"
        placeholderText: "enter port number"
        readOnly: WebSocketClient.isClientRunning
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        text: WebSocketClient.isClientRunning ? "STOP" : "START"
        checkable: true
        anchors.centerIn: parent
        onClicked: {
            if (WebSocketClient.isClientRunning) {
                WebSocketClient.stopClient();
                resetTextFields();
            } else {
                WebSocketClient.startClient("ws://localhost:" + portField.text);
            }
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

    TextField {
        id: errorField
        placeholderText: "(last error)"
        anchors.top: receivedMessageField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
