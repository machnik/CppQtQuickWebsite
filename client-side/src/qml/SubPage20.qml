import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 20"
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
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    TextField {
        id: portField
        placeholderText: "(enter port number here)"
        readOnly: WebSocketClient.isClientRunning
        width: 250
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        text: WebSocketClient.isClientRunning ? "STOP" : "START"
        checkable: true
        anchors.bottom: messageToSendField.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
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
        placeholderText: "(enter message to send here)"
        width: 250
        anchors.centerIn: parent
        anchors.margins: 10
    }

    Button {
        id: sendButton
        text: "SEND"
        enabled: messageToSendField.text.length > 0
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
        readOnly: true
        width: 250
        anchors.top: sendButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    TextField {
        id: errorField
        placeholderText: "(last error)"
        readOnly: true
        width: 250
        anchors.top: receivedMessageField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
