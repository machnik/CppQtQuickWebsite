import QtQuick
import QtQuick.Controls
import QtMultimedia

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    
    readonly property string headerText: (Localization.string("SubPage %1")).arg(17)
    readonly property string subHeaderText: Localization.string("Music playback")

    property bool isReady: false

    MediaPlayer {
        id: mediaPlayer
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
    }

    Component.onCompleted: {
        if (BrowserJS.browserEnvironment) {
            // Browser APIs cannot open qrc:/ URLs, so expose the embedded
            // resource as a data URL; native Qt can load the resource directly.
            var b64 = Base64Converter.convertFileToBase64(":/resources/audio/sound.ogg")
            mediaPlayer.source = "data:audio/ogg;base64," + b64
        } else {
            mediaPlayer.source = "qrc:/resources/audio/sound.ogg"
        }
        isReady = true
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
        id: subHeaderLabel
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    Button {
        id: playMusic
        text: Localization.string("Click to Play Music")
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopMusic.top
        anchors.bottomMargin: 20
        enabled: isReady && mediaPlayer.playbackState !== MediaPlayer.PlayingState
        onClicked: {
            mediaPlayer.play()
        }
    }

    Button {
        id: stopMusic
        text: Localization.string("Click to Stop Music")
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.centerIn: parent
        enabled: isReady && mediaPlayer.playbackState === MediaPlayer.PlayingState
        onClicked: {
            mediaPlayer.stop()
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
