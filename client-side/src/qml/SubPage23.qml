import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    id: root
    color: "transparent"

    readonly property string headerText: Localization.string("SubPage %1").arg(23)
    readonly property string subHeaderText: Localization.string("Using Qt Settings to store files.")

    property bool browserEnvironment: BrowserJS.browserEnvironment
    property string statusText: ""
    property color statusColor: "black"

    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize

    Settings {
        id: imageCache
        property string storedImage: ""
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

    ColumnLayout {
        anchors.top: subHeaderLabel.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: browserEnvironment
                ? qsTr("On this page the Qt Settings module is used for local binary data storage on WebAssembly builds.\nWARNING: This solution currently is not reliable!")
                : qsTr("This example is only applicable when the application is running in a browser.")
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            font.pointSize: regularFontSize
            font.bold: true
            color: "red"
        }

        RowLayout { spacing: 10
            Button { text: qsTr("Download Picture"); enabled: browserEnvironment; font.pointSize: regularFontSize; onClicked: download() }
            Button { text: qsTr("Store to Settings"); enabled: browserEnvironment && img.source !== ""; font.pointSize: regularFontSize; onClicked: store() }
            Button { text: qsTr("Load from Settings"); enabled: browserEnvironment; font.pointSize: regularFontSize; onClicked: load() }
            Button { text: qsTr("Clear Settings"); enabled: browserEnvironment; font.pointSize: regularFontSize; onClicked: clearStorage() }
        }

        Text {
            text: statusText
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: bigFontSize
            color: statusColor
            wrapMode: Text.WordWrap
        }

        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 300
            radius: 18
            border.color: "#7a7a7a"; border.width: 1.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#f0f0f0" }
                GradientStop { position: 1.0; color: "#b0b0b0" }
            }

            Image {
                id: img
                anchors.fill: parent
                anchors.margins: 15
                fillMode: Image.PreserveAspectFit
            }
            Label {
                anchors.centerIn: parent
                visible: img.source === ""
                text: qsTr("No Image")
                color: "gray"
            }
        }
    }

    // Updates the status label text and color
    function setStatus(txt, clr) {
        statusText = txt
        statusColor = clr
    }
    
    // Initiates an HTTP fetch to download an image, converts it to data URL
    function download() {
        setStatus(qsTr("Downloading…"), "blue")
        
        // Stop any existing download timer and clean up previous state
        downloadTimer.stop()
        BrowserJS.runVoidJS("delete window._downloadedImage; delete window._downloadComplete; delete window._downloadError;")
        
        BrowserJS.runVoidJS(`
            (async () => {
                try {
                    const r = await fetch("https://picsum.photos/400/300");
                    if (!r.ok) throw r.status;
                    const b = await r.blob();
                    const u = await new Promise(r => {
                        const fr = new FileReader();
                        fr.onload = () => r(fr.result);
                        fr.readAsDataURL(b);
                    });
                    window._downloadedImage = u;
                    window._downloadComplete = true;
                } catch (e) { 
                    window._downloadError = e.toString();
                    window._downloadComplete = true;
                }
            })();
        `);
        
        // Start polling for download completion
        downloadTimer.start()
    }

    Timer {
        id: downloadTimer
        interval: 100
        repeat: true
        onTriggered: {
            var complete = BrowserJS.runIntJS("window._downloadComplete ? 1 : 0")
            if (complete) {
                stop()
                var error = BrowserJS.runStringJS("window._downloadError || ''")
                if (error) {
                    setStatus(qsTr("Error downloading"), "red")
                } else {
                    var imageData = BrowserJS.runStringJS("window._downloadedImage")
                    img.source = imageData
                    setStatus(qsTr("Downloaded"), "green")
                }
                // Clean up
                BrowserJS.runVoidJS("delete window._downloadedImage; delete window._downloadComplete; delete window._downloadError;")
            }
        }
    }

    // Stores the current image source to Qt Settings
    function store() {
        if (!img.source) {
            setStatus(qsTr("No image to store"), "red")
            return
        }
        
        imageCache.storedImage = img.source
        setStatus(qsTr("Stored to Settings"), "green")
    }

    // Loads the stored image from Qt Settings
    function load() {
        if (imageCache.storedImage && imageCache.storedImage !== "") {
            img.source = imageCache.storedImage
            setStatus(qsTr("Loaded from Settings"), "green")
        } else {
            setStatus(qsTr("No stored image found"), "orange")
        }
    }

    // Clears the stored image from Qt Settings
    function clearStorage() {
        imageCache.storedImage = ""
        img.source = ""
        setStatus(qsTr("Settings cleared"), "green")
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
    }
}
