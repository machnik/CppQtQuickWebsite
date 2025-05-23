import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(25)
    readonly property string subHeaderText: (Localization.string("SubPage %1 description")).arg(25)

    property string base64Video: ""
    property bool isVideoLoaded: false

    Component.onCompleted: {
        if (BrowserJS.browserEnvironment) {
            base64Video = Base64Converter.convertFileToBase64(":/resources/videos/earth.mp4")
            isVideoLoaded = true
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

    Rectangle {
        id: videoContainer
        width: parent.width * 0.8
        height: parent.height * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: headerLabel.bottom
        anchors.topMargin: 80
        color: "black"
        border.color: "#888"
        border.width: 1

        // Only show the button if in browser environment
        Button {
            id: showVideoButton
            visible: BrowserJS.browserEnvironment
            anchors.centerIn: parent
            text: isVideoLoaded ? Localization.string("Show Video Player") : Localization.string("Loading video...")
            enabled: isVideoLoaded
            onClicked: {
                // Remove any previous video element
                BrowserJS.runJS(`
                    var oldVid = document.getElementById('qml-video-player');
                    if (oldVid) oldVid.remove();
                `);

                // Inject the video element
                BrowserJS.runJS(`
                    var video = document.createElement('video');
                    video.id = 'qml-video-player';
                    video.controls = true;
                    video.style.position = 'absolute';
                    video.style.left = '${videoContainer.x + videoContainer.parent.x}px';
                    video.style.top = '${videoContainer.y + videoContainer.parent.y}px';
                    video.width = ${videoContainer.width};
                    video.height = ${videoContainer.height};
                    video.src = 'data:video/mp4;base64,${base64Video}';
                    video.style.zIndex = 1000;
                    document.body.appendChild(video);
                `);
            }
        }
    }

    Button {
        id: hideVideoButton
        visible: BrowserJS.browserEnvironment
        anchors.top: videoContainer.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        text: Localization.string("Hide Video Player")
        onClicked: {
            BrowserJS.runJS(`
                var vid = document.getElementById('qml-video-player');
                if (vid) vid.remove();
            `);
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
