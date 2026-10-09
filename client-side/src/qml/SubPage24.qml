import QtQuick
import QtQuick.Controls
import QtMultimedia

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    id: root

    readonly property string headerText: (Localization.string("SubPage %1")).arg(24)
    readonly property string subHeaderText: Localization.string("Video playback.")

    property bool isReady: false
    property url videoSource: ""
    property bool browserVideoPlaying: false
    property bool browserVideoHasPosition: false
    readonly property string browserVideoElementId: "subpage24-video-" + Math.round(Math.random() * 1000000)
    readonly property bool playerReady: isReady &&
        (BrowserJS.browserEnvironment || videoLoader.status === Loader.Ready)
    readonly property bool playbackActive: BrowserJS.browserEnvironment
        ? browserVideoPlaying
        : videoLoader.status === Loader.Ready &&
          videoLoader.item.playbackState === MediaPlayer.PlayingState
    readonly property bool hasPlaybackPosition: BrowserJS.browserEnvironment
        ? browserVideoHasPosition
        : videoLoader.status === Loader.Ready && videoLoader.item.position > 0

    color: "transparent"

    function createBrowserVideo(base64Video) {
        const position = videoViewport.mapToItem(null, 0, 0)
        BrowserJS.runVoidJS(`
            (function() {
                var existingVideo = document.getElementById('${browserVideoElementId}');
                if (existingVideo)
                    existingVideo.remove();

                var video = document.createElement('video');
                video.id = '${browserVideoElementId}';
                video.controls = false;
                video.playsInline = true;
                video.preload = 'auto';
                video.style.position = 'absolute';
                video.style.left = '${position.x}px';
                video.style.top = '${position.y}px';
                video.style.objectFit = 'contain';
                video.style.backgroundColor = 'black';
                video.style.zIndex = 1000;
                video.width = ${videoViewport.width};
                video.height = ${videoViewport.height};
                video.addEventListener('error', function() {
                    console.error('SubPage 24 video failed to load:', video.error);
                });
                video.src = 'data:video/mp4;base64,${base64Video}';
                document.body.appendChild(video);
            })();
        `)
    }

    function updateBrowserVideoGeometry() {
        if (!BrowserJS.browserEnvironment)
            return

        const position = videoViewport.mapToItem(null, 0, 0)
        BrowserJS.runVoidJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                if (!video)
                    return;
                video.style.left = '${position.x}px';
                video.style.top = '${position.y}px';
                video.width = ${videoViewport.width};
                video.height = ${videoViewport.height};
            })();
        `)
    }

    function updateBrowserVideoState() {
        if (!BrowserJS.browserEnvironment)
            return

        browserVideoPlaying = BrowserJS.runIntJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                return video && !video.paused && !video.ended ? 1 : 0;
            })();
        `) !== 0
        browserVideoHasPosition = BrowserJS.runIntJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                return video && video.currentTime > 0 ? 1 : 0;
            })();
        `) !== 0
    }

    function playBrowserVideo() {
        BrowserJS.runVoidJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                if (!video) {
                    console.error('SubPage 24 video element is missing.');
                    return;
                }
                var playPromise = video.play();
                if (playPromise && typeof playPromise.catch === 'function') {
                    playPromise.catch(function(error) {
                        console.error('SubPage 24 video playback failed:', error);
                    });
                }
            })();
        `)
        browserVideoPlaying = true
    }

    function pauseBrowserVideo() {
        BrowserJS.runVoidJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                if (video)
                    video.pause();
            })();
        `)
        browserVideoPlaying = false
    }

    function stopBrowserVideo() {
        BrowserJS.runVoidJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                if (!video) {
                    console.error('SubPage 24 video element is missing.');
                    return;
                }
                video.pause();
                video.currentTime = 0;
            })();
        `)
        browserVideoPlaying = false
        browserVideoHasPosition = false
    }

    function removeBrowserVideo() {
        if (!BrowserJS.browserEnvironment)
            return

        BrowserJS.runVoidJS(`
            (function() {
                var video = document.getElementById('${browserVideoElementId}');
                if (video) {
                    video.pause();
                    video.remove();
                }
            })();
        `)
    }

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

    Item {
        id: videoViewport
        width: parent.width * 0.8
        height: parent.height * 0.6
        anchors.top: subHeaderLabel.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        onXChanged: root.updateBrowserVideoGeometry()
        onYChanged: root.updateBrowserVideoGeometry()
        onWidthChanged: root.updateBrowserVideoGeometry()
        onHeightChanged: root.updateBrowserVideoGeometry()
    }

    Loader {
        id: videoLoader
        anchors.fill: videoViewport
        active: !BrowserJS.browserEnvironment
        sourceComponent: videoComponent
    }

    Component {
        id: videoComponent

        Video {
            anchors.fill: parent
            source: root.videoSource
            autoPlay: false
            fillMode: VideoOutput.PreserveAspectFit
        }
    }

    Component.onCompleted: {
        // Qt's WebAssembly stop path removes its backing video element, so use
        // the browser video element directly there and Qt Multimedia natively.
        if (BrowserJS.browserEnvironment) {
            const base64Video = Base64Converter.convertFileToBase64(":/resources/videos/earth.mp4")
            if (base64Video.length > 0) {
                createBrowserVideo(base64Video)
                isReady = true
            }
        } else {
            videoSource = "qrc:/resources/videos/earth.mp4"
            isReady = true
        }
    }

    Component.onDestruction: removeBrowserVideo()

    Timer {
        interval: 250
        repeat: true
        running: BrowserJS.browserEnvironment && isReady
        onTriggered: root.updateBrowserVideoState()
    }

    Row {
        // Track both backends so controls stay synchronized after natural end.
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: videoViewport.bottom
        anchors.topMargin: 20

        Button {
            icon.source: "qrc:/resources/icons/play.svg"
            enabled: playerReady && !playbackActive
            onClicked: {
                if (BrowserJS.browserEnvironment)
                    root.playBrowserVideo()
                else
                    videoLoader.item.play()
            }
        }

        Button {
            icon.source: "qrc:/resources/icons/pause.svg"
            enabled: playerReady && playbackActive
            onClicked: {
                if (BrowserJS.browserEnvironment)
                    root.pauseBrowserVideo()
                else
                    videoLoader.item.pause()
            }
        }

        Button {
            icon.source: "qrc:/resources/icons/stop.svg"
            enabled: playerReady && (playbackActive || hasPlaybackPosition)
            onClicked: {
                if (BrowserJS.browserEnvironment) {
                    root.stopBrowserVideo()
                } else {
                    videoLoader.item.stop()
                }
            }
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
