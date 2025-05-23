import QtQuick
import QtQuick.Controls
import QtMultimedia

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    
    readonly property string headerText: (Localization.string("SubPage %1")).arg(17)
    readonly property string subHeaderText: Localization.string("Music Playback")

    MediaPlayer {
        id: mediaPlayer
        source: "qrc:/sound.ogg"
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
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

    Label {
        text: Localization.string("Does not work in WebAssembly with Qt 6.9!")
        anchors.top: subHeaderLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        font.pointSize: ZoomSettings.bigFontSize
        color: "red"
    }

    Button {
        id: playMusic
        text: Localization.string("Click to Play Music")
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
        text: Localization.string("Click to Stop Music")
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
