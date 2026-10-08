import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(18)
    readonly property string subHeaderText: Localization.string("Music playback using the browser's Web Audio API.")

    property string base64Audio: ""
    property bool audioPlaybackSupported: false
    property bool audioLoadFailed: false
    property bool isAudioLoaded: false
    property bool audioSessionActive: false
    readonly property string audioStateKey: "qmlAudioState_" + Math.round(Math.random() * 1000000)

    function stopBrowserAudio() {
        if (!BrowserJS.browserEnvironment) {
            return
        }

        // Keep browser-owned AudioContext/AudioBufferSourceNode objects in
        // JavaScript, then explicitly tear them down when the QML page leaves.
        BrowserJS.runVoidJS(`
            (function() {
                var stateKey = '${audioStateKey}';
                var state = window[stateKey];
                if (!state) {
                    return;
                }

                if (state.source) {
                    try {
                        state.source.stop(0);
                    } catch (error) {
                        console.debug('Audio source already stopped.', error);
                    }
                }

                if (state.audioContext && state.audioContext.state !== 'closed') {
                    state.audioContext.close();
                }

                delete window[stateKey];
            })();
        `)
    }

    Component.onCompleted: {
        // Data embedded within the application with the Qt resource system
        // is not directly accessible in the browser's JS environment.
        // However, we can work around this limitation by passing any data
        // we need to the browser's JS environment using the Base64 encoding.
        // Another idea worth considering would be to use the virtual file system
        // provided by Emscripten.
        if (BrowserJS.browserEnvironment) {
            audioPlaybackSupported = BrowserJS.runIntJS("(window.AudioContext || window.webkitAudioContext) ? 1 : 0") === 1
            base64Audio = Base64Converter.convertFileToBase64(":/resources/audio/sound.ogg")
            audioLoadFailed = base64Audio.length === 0
            isAudioLoaded = base64Audio.length > 0
        }
    }

    Component.onDestruction: {
        // Stop audio playback when the component is destroyed:
        if (BrowserJS.browserEnvironment) {
            stopBrowserAudio()
        }

        audioSessionActive = false
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
        text: !BrowserJS.browserEnvironment || !audioPlaybackSupported
                            ? Localization.string("Playback not available in this environment!")
                            : audioLoadFailed
                                ? Localization.string("Embedded audio failed to load.")
                                : isAudioLoaded
                                    ? Localization.string("Click to Play Music")
                                    : Localization.string("Loading audio...")
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopMusic.top
        anchors.bottomMargin: 20
        enabled: isAudioLoaded && audioPlaybackSupported && !audioSessionActive
        onClicked: {
            if (!audioPlaybackSupported) {
                return
            }

            stopBrowserAudio()
            audioSessionActive = true

            // Create/resume audio from the click handler because browsers
            // generally require Web Audio playback to follow user activation.
            BrowserJS.runVoidJS(`
                (function() {
                    var AudioContextCtor = window.AudioContext || window.webkitAudioContext;
                    if (!AudioContextCtor) {
                        return;
                    }

                    var stateKey = '${audioStateKey}';
                    var audioContext = new AudioContextCtor();
                    var state = {
                        audioContext: audioContext,
                        source: null
                    };
                    window[stateKey] = state;

                    var binaryString = window.atob('${base64Audio}');
                    var length = binaryString.length;
                    var bytes = new Uint8Array(length);
                    for (var i = 0; i < length; i++) {
                        bytes[i] = binaryString.charCodeAt(i);
                    }

                    audioContext.decodeAudioData(bytes.buffer.slice(0), function(buffer) {
                        if (!window[stateKey]) {
                            return;
                        }

                        var source = audioContext.createBufferSource();
                        source.buffer = buffer;
                        source.loop = true;
                        source.connect(audioContext.destination);
                        source.start(0);
                        state.source = source;
                    }, function(error) {
                        console.error('Error decoding audio data:', error);
                    });
                })();
            `);
        }
    }

    Button {
        id: stopMusic
        text: Localization.string("Click to Stop Music")
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.centerIn: parent
        enabled: audioSessionActive
        onClicked: {
            stopBrowserAudio()
            audioSessionActive = false
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
