import QtQuick
import QtQuick.Controls
import QtMultimedia

import "qrc:/qml/singletons/"

Rectangle {
    
    readonly property string headerText: "SubPage 17"
    readonly property string subHeaderText: "Music Playback"

    MediaPlayer {
        id: mediaPlayer
        source: "qrc:/resources/audio/sound.wav"
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
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

    Button {
        id: playMusic
        text: "Click to Play Music"
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopMusic.top
        anchors.bottomMargin: 20
        enabled: mediaPlayer.playbackState !== MediaPlayer.PlayingState
        onClicked: {
            mediaPlayer.play()
        }
    }

    Button {
        id: stopMusic
        text: "Click to Stop Music"
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.centerIn: parent
        enabled: mediaPlayer.playbackState === MediaPlayer.PlayingState
        onClicked: {
            mediaPlayer.stop()
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
