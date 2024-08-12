import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: "SubPage 19"
    readonly property string subHeaderText: "WebSocket Server."

    property int smallFontSize: ZoomSettings.smallFontSize

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
        font.pointSize: smallFontSize
        readOnly: WebSocketServer.isServerRunning
        width: 250
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        text: WebSocketServer.isServerRunning ? "STOP" : "START"
        font.pointSize: smallFontSize
        checkable: true
        anchors.bottom: bouncedMessageField.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
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
        font.pointSize: smallFontSize
        readOnly: true
        width: 250
        anchors.centerIn: parent
        anchors.margins: 10
    }

    TextField {
        id: errorField
        placeholderText: "(last error)"
        font.pointSize: smallFontSize
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
