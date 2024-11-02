import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: "SubPage 21"
    readonly property string subHeaderText: "Music playback using the browser's Web Audio API."

    readonly property string base64Audio: "data:audio/wav;base64,..." // TODO: Replace with base64 string.

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

    // Button {
    //     id: playMusic
    //     text: "Click to Play Music"
    //     font.pointSize: ZoomSettings.hugeFontSize
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     anchors.bottom: stopMusic.top
    //     anchors.bottomMargin: 20
    //     onClicked: {
    //         BrowserJS.runJS(`
    //             var audioContext = new (window.AudioContext || window.webkitAudioContext)();
    //             var audioBuffer;
    //             var source;

    //             function loadAudio(base64) {
    //                 var binaryString = window.atob(base64.split(',')[1]);
    //                 var len = binaryString.length;
    //                 var bytes = new Uint8Array(len);
    //                 for (var i = 0; i < len; i++) {
    //                     bytes[i] = binaryString.charCodeAt(i);
    //                 }
    //                 audioContext.decodeAudioData(bytes.buffer, function(buffer) {
    //                     audioBuffer = buffer;
    //                 });
    //             }

    //             function playAudio() {
    //                 if (audioBuffer) {
    //                     source = audioContext.createBufferSource();
    //                     source.buffer = audioBuffer;
    //                     source.connect(audioContext.destination);
    //                     source.start(0);
    //                 }
    //             }

    //             function stopAudio() {
    //                 if (source) {
    //                     source.stop(0);
    //                 }
    //             }

    //             loadAudio('${base64Audio}');
    //             playAudio();
    //         `);
    //     }
    // }

    // Button {
    //     id: stopMusic
    //     text: "Click to Stop Music"
    //     font.pointSize: ZoomSettings.hugeFontSize
    //     anchors.centerIn: parent
    //     onClicked: {
    //         BrowserJS.runJS("stopAudio();");
    //     }
    // }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
