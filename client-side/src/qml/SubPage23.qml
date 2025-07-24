import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    id: root
    color: "transparent"

    readonly property string headerText: Localization.string("SubPage %1").arg(23)
    readonly property string subHeaderText: Localization.string("Using QSettings to store files.")

    property bool browserEnvironment: BrowserJS.browserEnvironment
    property string statusText: ""
    property color statusColor: "black"

    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize

    readonly property string imageFileName: "cached_image.dataurl"

    Component.onCompleted: {

        // Try to load any previously stored image
        if (BinaryStorage.hasFile(imageFileName)) {
            var storedImage = BinaryStorage.fileAsString(imageFileName)
            if (storedImage && storedImage !== "") {
                img.source = storedImage
                setStatus(Localization.string("Previously stored image loaded"), "green")
            }
        }
        
        // Connect to ImageDownloader signals
        ImageDownloader.downloadStarted.connect(function() {
            setStatus(Localization.string("Downloading…"), "blue")
        })
        
        ImageDownloader.downloadProgress.connect(function(bytesReceived, bytesTotal) {
            if (bytesTotal > 0) {
                var percent = Math.round((bytesReceived / bytesTotal) * 100)
                setStatus(Localization.string("Downloading… %1%").arg(percent), "blue")
            }
        })
        
        ImageDownloader.downloadFinished.connect(function(dataUrl) {
            img.source = dataUrl
            setStatus(Localization.string("Downloaded"), "green")
        })
        
        ImageDownloader.downloadError.connect(function(errorString) {
            setStatus(Localization.string("Error downloading: %1").arg(errorString), "red")
        })
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
            text: Localization.string("On this page QSettings is used for local binary data storage.\nThis uses LocalStorage or IndexedDB on WebAssembly builds and falls back to .ini files on desktop.")
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: regularFontSize
            font.bold: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            
            Text {
                text: Localization.string("Storage Mode:")
                font.pointSize: regularFontSize
                font.bold: true
            }
            
            Text {
                text: Localization.string("WebLocalStorage")
                font.pointSize: regularFontSize
                color: storageSwitch.checked ? "gray" : "black"
            }
            
            Switch {
                id: storageSwitch
                checked: false  // Default to WebLocalStorage (unchecked)
                onToggled: {
                    if (checked) {
                        BinaryStorage.switchToWebIndexedDB()
                        setStatus(Localization.string("Switched to WebIndexedDB"), "blue")
                    } else {
                        BinaryStorage.switchToWebLocalStorage()
                        setStatus(Localization.string("Switched to WebLocalStorage"), "blue")
                    }
                }
            }
            
            Text {
                text: Localization.string("WebIndexedDB")
                font.pointSize: regularFontSize
                color: storageSwitch.checked ? "black" : "gray"
            }
        }

        RowLayout { spacing: 10
            Button { text: Localization.string("Download Picture"); font.pointSize: regularFontSize; onClicked: download() }
            Button { text: Localization.string("Store to QSettings"); font.pointSize: regularFontSize; onClicked: store() }
            Button { text: Localization.string("Load from QSettings"); font.pointSize: regularFontSize; onClicked: load() }
            Button { text: Localization.string("Clear QSettings"); font.pointSize: regularFontSize; onClicked: clearStorage() }
        }

        Text {
            text: statusText
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: bigFontSize
            font.bold: true
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
                text: Localization.string("No Image")
                color: "gray"
            }
        }
    }

    // Updates the status label text and color
    function setStatus(txt, clr) {
        statusText = txt
        statusColor = clr
    }
    
    // Initiates image download using the reliable C++ ImageDownloader
    function download() {
        if (browserEnvironment) {
            // Use Qt networking for reliable download
            ImageDownloader.downloadImage("https://picsum.photos/400/300")
        } else {
            // For desktop, use a placeholder data URL
            img.source = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjQwMHgzMDA8L3RleHQ+PC9zdmc+"
            setStatus(Localization.string("Demo image loaded"), "green")
        }
    }

    // Stores the current image source to BinaryStorage
    function store() {
        var sourceStr = img.source ? img.source.toString() : ""
        if (!sourceStr || sourceStr.trim() === "") {
            setStatus(Localization.string("No image to store"), "red")
            return
        }
        
        BinaryStorage.setFileAsString(imageFileName, sourceStr)
        setStatus(Localization.string("Stored to QSettings"), "green")
    }

    // Loads the stored image from BinaryStorage
    function load() {
        if (BinaryStorage.hasFile(imageFileName)) {
            var storedImage = BinaryStorage.fileAsString(imageFileName)
            if (storedImage && storedImage !== "") {
                img.source = storedImage
                setStatus(Localization.string("Loaded from QSettings"), "green")
            } else {
                setStatus(Localization.string("No stored image found"), "orange")
            }
        } else {
            setStatus(Localization.string("No stored image found"), "orange")
        }
    }

    // Clears the stored image from BinaryStorage
    function clearStorage() {
        BinaryStorage.removeFile(imageFileName)
        img.source = ""
        setStatus(Localization.string("QSettings cleared"), "green")
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
    }
}
