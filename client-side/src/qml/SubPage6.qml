import QtQuick
import QtQuick.Controls
import QtMultimedia

Page {
    
    readonly property string headerText: "SubPage 6"
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
        font.pointSize: 15
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
    }

    Text {
        id: playMusic
        text: "Click to Play Music";
        anchors.centerIn: parent;
        width: 200; height: 60;
        font.pointSize: 13;

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
        anchors.top: playMusic.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        width: 200; height: 60;
        font.pointSize: 13;
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
