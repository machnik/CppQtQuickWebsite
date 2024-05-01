import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 18"
    readonly property string subHeaderText: "WebSocket Server."

    function resetTextFields() {
        bouncedMessageField.text = "";
        errorField.text = "";
    }

    Connections {
        target: WebSocketServer
        function onBouncedMessage(message) {
            bouncedMessageField.text = message;
        }
        function onErrorOccurred(error) {
            errorField.text = error;
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
        placeholderText: "(enter port number here)"
        readOnly: WebSocketServer.isServerRunning
        width: 250
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        text: WebSocketServer.isServerRunning ? "STOP" : "START"
        checkable: true
        anchors.centerIn: parent
        onClicked: {
            if (WebSocketServer.isServerRunning) {
                WebSocketServer.stopServer();
                resetTextFields();
            } else {
                WebSocketServer.startServer(parseInt(portField.text));
            }
        }
    }

    TextField {
        id: bouncedMessageField
        placeholderText: "(last bounced message)"
        readOnly: true
        width: 250
        anchors.top: startButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    TextField {
        id: errorField
        placeholderText: "(last error)"
        readOnly: true
        width: 250
        anchors.top: bouncedMessageField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
