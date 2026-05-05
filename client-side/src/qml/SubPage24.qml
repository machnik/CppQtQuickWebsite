import QtQuick
import QtQuick.Controls
import QtMultimedia

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(24)
    readonly property string subHeaderText: Localization.string("Video playback.")

    property bool isReady: false

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

    Video {
        id: videoPlayer
        width: parent.width * 0.8
        height: parent.height * 0.6
        anchors.top: subHeaderLabel.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        autoPlay: false
        fillMode: VideoOutput.PreserveAspectFit
    }

    Component.onCompleted: {
        if (BrowserJS.browserEnvironment) {
            var b64 = Base64Converter.convertFileToBase64(":/resources/videos/earth.mp4")
            videoPlayer.source = "data:video/mp4;base64," + b64
        } else {
            videoPlayer.source = "qrc:/resources/videos/earth.mp4"
        }
        isReady = true
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: videoPlayer.bottom
        anchors.topMargin: 20

        Button {
            icon.source: "qrc:/resources/icons/play.svg"
            enabled: isReady && videoPlayer.playbackState !== MediaPlayer.PlayingState
            onClicked: videoPlayer.play()
        }

        Button {
            icon.source: "qrc:/resources/icons/pause.svg"
            enabled: isReady && videoPlayer.playbackState === MediaPlayer.PlayingState
            onClicked: videoPlayer.pause()
        }

        Button {
            icon.source: "qrc:/resources/icons/stop.svg"
            enabled: isReady && videoPlayer.playbackState !== MediaPlayer.StoppedState
            onClicked: videoPlayer.stop()
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
