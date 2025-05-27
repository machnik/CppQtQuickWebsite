import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(18)
    readonly property string subHeaderText: Localization.string("Music playback using the browser's Web Audio API.")

    property string base64Audio: ""
    property bool isAudioLoaded: false

    Component.onCompleted: {
        // Data embedded within the application with the Qt resource system
        // is not directly accessible in the browser's JS environment.
        // However, we can work around this limitation by passing any data
        // we need to the browser's JS environment using the Base64 encoding.
        // Another idea worth considering would be to use the virtual file system
        // provided by Emscripten.
        if (BrowserJS.browserEnvironment) {
            base64Audio = Base64Converter.convertFileToBase64(":/resources/audio/sound.ogg")
            isAudioLoaded = true
        }
    }

    Component.onDestruction: {
        // Stop audio playback when the component is destroyed:
        if (BrowserJS.browserEnvironment) {
            BrowserJS.runJS("stopAudio();");
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

    Button {
        id: playMusic
        text: isAudioLoaded ? Localization.string("Click to Play Music") : (BrowserJS.browserEnvironment ? Localization.string("Loading audio...") : Localization.string("Playback not available in this environment!"))
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopMusic.top
        anchors.bottomMargin: 20
        enabled: isAudioLoaded
        onClicked: {
            enabled = false;
            stopMusic.enabled = true;
            BrowserJS.runJS(`
                var audioContext = new (window.AudioContext || window.webkitAudioContext)();
                var audioBuffer;
                var source;

                function loadAudio(base64) {
                    var binaryString = window.atob(base64);
                    var length = binaryString.length;
                    var bytes = new Uint8Array(length);
                    for (var i = 0; i < length; i++) {
                        bytes[i] = binaryString.charCodeAt(i);
                    }
                    audioContext.decodeAudioData(bytes.buffer, function(buffer) {
                        audioBuffer = buffer;
                        playAudio();
                    }, function(e) {
                        console.error('Error decoding audio data:', e);
                    });
                }

                function playAudio() {
                    if (audioBuffer) {
                        source = audioContext.createBufferSource();
                        source.buffer = audioBuffer;
                        source.loop = true;
                        source.connect(audioContext.destination);
                        source.start(0);
                    }
                }

                window.stopAudio = function() {
                    if (source) {
                        source.stop(0);
                    }
                }

                loadAudio('${base64Audio}');
            `);
        }
    }

    Button {
        id: stopMusic
        text: Localization.string("Click to Stop Music")
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.centerIn: parent
        enabled: false
        onClicked: {
            enabled = false;
            playMusic.enabled = true;
            BrowserJS.runJS("stopAudio();");
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
