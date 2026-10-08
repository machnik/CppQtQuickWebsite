import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(25)
    readonly property string subHeaderText: (Localization.string("Video playback using the browser's built-in player."))

    property string base64Video: ""
    property bool videoLoadFailed: false
    property bool isVideoLoaded: false // Video loaded from base64 string of embedded file earth.mp4?
    property bool isVideoPlaying: false // Is the browser's video player active?
    readonly property string videoElementId: "qml-video-player-" + Math.round(Math.random() * 1000000)

    function removeBrowserVideo() {
        if (!BrowserJS.browserEnvironment) {
            return
        }

        // This video is a DOM element layered over the Qt canvas, not a QML
        // item, so remove it explicitly when stopped or when the page is left.
        BrowserJS.runVoidJS(`
            (function() {
                var vid = document.getElementById('${videoElementId}');
                if (vid) {
                    vid.remove();
                }
            })();
        `)
    }

    Component.onCompleted: {
        if (BrowserJS.browserEnvironment) {
            base64Video = Base64Converter.convertFileToBase64(":/resources/videos/earth.mp4")
            videoLoadFailed = base64Video.length === 0
            isVideoLoaded = base64Video.length > 0
        }
    }

    Component.onDestruction: {
        // Remove the browser's video player when the component is destroyed:
        if (BrowserJS.browserEnvironment) {
            removeBrowserVideo()
        }

        isVideoPlaying = false
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

    // Container for the video player:
    Rectangle {
        id: videoContainer
        width: parent.width * 0.8
        height: parent.height * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: headerLabel.bottom
        anchors.topMargin: 80
        color: "black"
        border.color: "black"
        border.width: 1

        Button {
            visible: BrowserJS.browserEnvironment
            anchors.centerIn: parent
            text: videoLoadFailed
                ? Localization.string("Embedded video failed to load.")
                : isVideoLoaded
                    ? Localization.string("Load Video")
                    : Localization.string("Loading video...")
            enabled: isVideoLoaded
            onClicked: {
                removeBrowserVideo()

                // A DOM overlay needs page coordinates rather than QML-local
                // coordinates, hence mapToItem(null, ...) before creation.
                // Calculate absolute position of videoContainer:
                var pos = videoContainer.mapToItem(null, 0, 0);

                // Inject the video element at the correct position:
                BrowserJS.runVoidJS(`
                    var video = document.createElement('video');
                    video.id = '${videoElementId}';
                    video.controls = true;
                    video.style.position = 'absolute';
                    video.style.left = '${pos.x}px';
                    video.style.top = '${pos.y}px';
                    video.width = ${videoContainer.width};
                    video.height = ${videoContainer.height};
                    video.src = 'data:video/mp4;base64,${base64Video}';
                    video.style.zIndex = 1000;
                    document.body.appendChild(video);
                `);

                isVideoPlaying = true;
            }
        }

        // Show this label if not in browser environment:
        Label {
            visible: !BrowserJS.browserEnvironment
            anchors.centerIn: parent
            text: Localization.string("Playback not available in this environment!")
            color: "red"
            font.pointSize: ZoomSettings.bigFontSize
        }
    }

    Button {
        visible: true
        enabled: BrowserJS.browserEnvironment && isVideoPlaying
        anchors.top: videoContainer.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        text: Localization.string("Close Video")
        onClicked: {
            removeBrowserVideo()
            isVideoPlaying = false;
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
