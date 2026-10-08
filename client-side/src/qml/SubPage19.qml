import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(19)
    readonly property string subHeaderText: Localization.string("WebSocket Server.")

    property int smallFontSize: ZoomSettings.smallFontSize
    readonly property bool showWasmWarning: BrowserJS.browserEnvironment

    function parsedPort() {
        return parseInt(portField.text, 10)
    }

    function hasValidPort() {
        var port = parsedPort()
        return !isNaN(port) && port >= 1 && port <= 65535
    }

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

    Label {
        // Keep the attempt available in WASM: the platform error is itself
        // useful when comparing Qt networking support across targets.
        text: Localization.string("WebAssembly does not support hosting WebSocket servers with this Qt build. You can still try starting one to see the platform error. Use a native build to host the server.")
        visible: showWasmWarning
        anchors.bottom: portField.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.75
        anchors.margins: 20
        font.pointSize: ZoomSettings.bigFontSize
        color: "red"
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    TextField {
        id: portField
        placeholderText: Localization.string("(enter port number here)")
        font.pointSize: smallFontSize
        readOnly: WebSocketServer.isServerRunning
        inputMethodHints: Qt.ImhDigitsOnly
        maximumLength: 5
        validator: IntValidator { bottom: 1; top: 65535 }
        width: 250
        anchors.bottom: startButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Button {
        id: startButton
        text: WebSocketServer.isServerRunning ? Localization.string("STOP") : Localization.string("START")
        font.pointSize: smallFontSize
        anchors.bottom: bouncedMessageField.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            if (WebSocketServer.isServerRunning) {
                WebSocketServer.stopServer();
                resetTextFields();
            } else {
                errorField.text = "";
                bouncedMessageField.text = "";

                if (!hasValidPort()) {
                    errorField.text = Localization.string("Please enter a valid port number between 1 and 65535.");
                    return;
                }

                WebSocketServer.startServer(parsedPort());
            }
        }
    }

    TextField {
        id: bouncedMessageField
        placeholderText: Localization.string("(last bounced message)")
        font.pointSize: smallFontSize
        readOnly: true
        width: 250
        anchors.centerIn: parent
        anchors.margins: 10
    }

    TextField {
        id: errorField
        placeholderText: Localization.string("(last error)")
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
