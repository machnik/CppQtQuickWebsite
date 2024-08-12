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

    Text {
        id: playMusic
        text: "Click to Play Music";
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopMusic.top

        MouseArea {
            anchors.fill: parent
            onPressed:  {
                playMusic.color = "gray";
                stopMusic.color = "black";
                mediaPlayer.play();
            }
        }
    }

    Text {
        id: stopMusic
        text: "Click to Stop Music";
        font.pointSize: ZoomSettings.hugeFontSize
        anchors.centerIn: parent;
        color: "gray";

        MouseArea {
            anchors.fill: parent
            onPressed:  {
                playMusic.color = "black"
                stopMusic.color = "gray"
                mediaPlayer.stop()
            }
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
