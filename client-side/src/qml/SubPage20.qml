import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(20)
    readonly property string subHeaderText: Localization.string("WebSocket Client.")

    property int smallFontSize: ZoomSettings.smallFontSize

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

    TextField {
        id: urlField
        // A full URL supports remote hosts and secure wss:// connections,
        // unlike a hard-coded localhost + port combination.
        text: "ws://localhost:1234"
        placeholderText: Localization.string("WebSocket URL (e.g. ws://localhost:1234)")
        font.pointSize: smallFontSize
        readOnly: WebSocketClient.isClientActive
        maximumLength: 2048
        width: 400
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        // The client exposes its socket state so an in-progress connection can
        // be cancelled before it becomes connected.
        text: WebSocketClient.isClientActive
              ? (WebSocketClient.isClientConnecting ? Localization.string("CANCEL") : Localization.string("STOP"))
              : Localization.string("START")
        font.pointSize: smallFontSize
        anchors.bottom: messageToSendField.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            if (WebSocketClient.isClientActive) {
                WebSocketClient.stopClient();
                resetTextFields();
            } else {
                errorField.text = ""
                receivedMessageField.text = ""
                WebSocketClient.startClient(urlField.text.trim());
            }
        }
    }

    TextField {
        id: messageToSendField
        placeholderText: Localization.string("(enter message to send here)")
        font.pointSize: smallFontSize
        width: 250
        anchors.centerIn: parent
        anchors.margins: 10
    }

    Button {
        id: sendButton
        text: Localization.string("SEND")
        font.pointSize: smallFontSize
        enabled: WebSocketClient.isClientRunning && messageToSendField.text.length > 0
        anchors.top: messageToSendField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            WebSocketClient.sendMessage(messageToSendField.text);
        }
    }

    TextField {
        id: receivedMessageField
        placeholderText: Localization.string("(last received message)")
        font.pointSize: smallFontSize
        readOnly: true
        width: 250
        anchors.top: sendButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    TextField {
        id: errorField
        placeholderText: Localization.string("(last error)")
        font.pointSize: smallFontSize
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
