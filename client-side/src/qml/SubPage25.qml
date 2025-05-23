import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(25)
    readonly property string subHeaderText: (Localization.string("SubPage %1 description")).arg(25)

    property string base64Video: ""
    property bool isVideoLoaded: false // Video loaded from base64 string of embedded file earth.mp4?
    property bool isVideoPlaying: false // Is the browser's video player active?

    Component.onCompleted: {
        if (BrowserJS.browserEnvironment) {
            base64Video = Base64Converter.convertFileToBase64(":/resources/videos/earth.mp4")
            isVideoLoaded = true
        }
    }

    Component.onDestruction: {
        // Remove the browser's video player when the component is destroyed:
        if (BrowserJS.browserEnvironment) {
            BrowserJS.runJS(`
                var vid = document.getElementById('qml-video-player');
                if (vid) vid.remove();
            `);
        }
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
            text: isVideoLoaded ? Localization.string("Load Video") : Localization.string("Loading Video...")
            enabled: isVideoLoaded
            onClicked: {
                // Remove any previous video element:
                BrowserJS.runJS(`
                    var oldVid = document.getElementById('qml-video-player');
                    if (oldVid) oldVid.remove();
                `);

                // Calculate absolute position of videoContainer:
                var pos = videoContainer.mapToItem(null, 0, 0);

                // Inject the video element at the correct position:
                BrowserJS.runJS(`
                    var video = document.createElement('video');
                    video.id = 'qml-video-player';
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
            BrowserJS.runJS(`
                var vid = document.getElementById('qml-video-player');
                if (vid) vid.remove();
            `);
            isVideoPlaying = false;
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
