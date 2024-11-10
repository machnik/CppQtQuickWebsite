import QtQuick
import QtQuick.Controls
import QtMultimedia

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 24"
    readonly property string subHeaderText: "Video player."

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
        text: "Does not work in WebAssembly with Qt 6.8!"
        anchors.top: subHeaderLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        font.pointSize: ZoomSettings.bigFontSize
        color: "red"
    }

    Video {
        id: videoPlayer
        width: parent.width * 0.8
        height: parent.height * 0.6
        anchors.centerIn: parent
        source: "qrc:/earth.mp4"
        autoPlay: false
        fillMode: VideoOutput.PreserveAspectFit
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: videoPlayer.bottom
        anchors.topMargin: 20

        Button {
            icon.source: "qrc:/resources/icons/play.svg"
            enabled: videoPlayer.playbackState !== MediaPlayer.PlayingState
            onClicked: videoPlayer.play()
        }

        Button {
            icon.source: "qrc:/resources/icons/pause.svg"
            enabled: videoPlayer.playbackState === MediaPlayer.PlayingState
            onClicked: videoPlayer.pause()
        }

        Button {
            icon.source: "qrc:/resources/icons/stop.svg"
            enabled: videoPlayer.playbackState !== MediaPlayer.StoppedState
            onClicked: videoPlayer.stop()
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
