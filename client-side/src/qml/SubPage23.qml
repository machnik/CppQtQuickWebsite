import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(23)
    readonly property string subHeaderText: Localization.string("Using IndexedDB to store files.")

    property color selectedColor: "blue"
    property bool imageDownloaded: false
    property string imageDataUrl: ""
    property bool isDownloading: false

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

    ScrollView {
        anchors.top: subHeaderLabel.bottom
        anchors.topMargin: 100
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.margins: 20

        ColumnLayout {
            width: parent.width
            spacing: 20

            Label {
                text: BrowserJS.browserEnvironment ? 
                      "This demo shows how to download an image from the internet and store it in IndexedDB." :
                      "This demo only works in a browser environment (WebAssembly)."
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                font.pointSize: ZoomSettings.regularFontSize
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    text: "Download Image"
                    enabled: BrowserJS.browserEnvironment && !isDownloading
                    onClicked: downloadImage()
                }

                Button {
                    text: "Load from IndexedDB"
                    enabled: BrowserJS.browserEnvironment && !isDownloading
                    onClicked: loadImageFromDB()
                }

                Button {
                    text: "Clear Storage"
                    enabled: BrowserJS.browserEnvironment && !isDownloading
                    onClicked: clearStorage()
                }
            }

            Label {
                text: isDownloading ? "Downloading..." : 
                      imageDownloaded ? "Image downloaded and stored in IndexedDB!" : 
                      "No image downloaded yet."
                font.pointSize: ZoomSettings.regularFontSize
                color: imageDownloaded ? "green" : "black"
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                border.color: "lightgray"
                border.width: 1
                color: "white"

                Image {
                    id: displayImage
                    anchors.centerIn: parent
                    source: imageDataUrl
                    fillMode: Image.PreserveAspectFit
                    width: Math.min(parent.width - 20, sourceSize.width)
                    height: Math.min(parent.height - 20, sourceSize.height)
                    visible: imageDataUrl !== ""
                }

                Label {
                    anchors.centerIn: parent
                    text: "Image will appear here"
                    visible: imageDataUrl === ""
                    color: "gray"
                }
            }
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function downloadImage() {
        if (!BrowserJS.browserEnvironment) return;
        
        isDownloading = true;
        imageDownloaded = false;
        imageDataUrl = "";

        // JavaScript code to download image and store in IndexedDB
        const jsCode = `
            (async function() {
                try {
                    // Open IndexedDB
                    const dbRequest = indexedDB.open('ImageStorageDB', 1);
                    
                    dbRequest.onupgradeneeded = function(event) {
                        const db = event.target.result;
                        if (!db.objectStoreNames.contains('images')) {
                            db.createObjectStore('images', { keyPath: 'id' });
                        }
                    };
                    
                    dbRequest.onsuccess = async function(event) {
                        const db = event.target.result;
                        
                        // Download example image (using a public image URL)
                        const imageUrl = 'https://picsum.photos/400/300';
                        const response = await fetch(imageUrl);
                        const blob = await response.blob();
                        
                        // Convert blob to base64
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const dataUrl = e.target.result;
                            
                            // Store in IndexedDB
                            const transaction = db.transaction(['images'], 'readwrite');
                            const store = transaction.objectStore('images');
                            
                            const imageData = {
                                id: 'example-image',
                                dataUrl: dataUrl,
                                timestamp: Date.now()
                            };
                            
                            store.put(imageData);
                            
                            transaction.oncomplete = function() {
                                // Signal QML that download is complete
                                window.qmlImageDownloaded = dataUrl;
                            };
                        };
                        reader.readAsDataURL(blob);
                    };
                    
                    dbRequest.onerror = function() {
                        console.error('Error opening IndexedDB');
                        window.qmlImageDownloaded = 'error';
                    };
                    
                } catch (error) {
                    console.error('Error downloading image:', error);
                    window.qmlImageDownloaded = 'error';
                }
            })();
            0; // Return value for emscripten_run_script_int
        `;

        BrowserJS.runJS(jsCode);
        
        // Check for completion
        checkDownloadComplete();
    }

    function loadImageFromDB() {
        if (!BrowserJS.browserEnvironment) return;
        
        isDownloading = true;
        
        const jsCode = `
            (async function() {
                try {
                    const dbRequest = indexedDB.open('ImageStorageDB', 1);
                    
                    dbRequest.onsuccess = function(event) {
                        const db = event.target.result;
                        const transaction = db.transaction(['images'], 'readonly');
                        const store = transaction.objectStore('images');
                        const request = store.get('example-image');
                        
                        request.onsuccess = function() {
                            if (request.result) {
                                window.qmlImageLoaded = 'success';
                                window.qmlImageLoadedData = request.result.dataUrl;
                            } else {
                                window.qmlImageLoaded = 'not-found';
                            }
                        };
                        
                        request.onerror = function() {
                            window.qmlImageLoaded = 'error';
                        };
                    };
                    
                    dbRequest.onerror = function() {
                        window.qmlImageLoaded = 'error';
                    };
                } catch (error) {
                    window.qmlImageLoaded = 'error';
                }
            })();
            0;
        `;

        BrowserJS.runJS(jsCode);
        checkLoadComplete();
    }

    function clearStorage() {
        if (!BrowserJS.browserEnvironment) return;
        
        const jsCode = `
            (async function() {
                try {
                    const dbRequest = indexedDB.open('ImageStorageDB', 1);
                    
                    dbRequest.onsuccess = function(event) {
                        const db = event.target.result;
                        const transaction = db.transaction(['images'], 'readwrite');
                        const store = transaction.objectStore('images');
                        
                        store.clear();
                        
                        transaction.oncomplete = function() {
                            window.qmlStorageCleared = 'true';
                        };
                    };
                } catch (error) {
                    window.qmlStorageCleared = 'error';
                }
            })();
            0;
        `;

        BrowserJS.runJS(jsCode);
        checkClearComplete();
    }

    function checkDownloadComplete() {
        const jsCode = `
            if (typeof window.qmlImageDownloaded !== 'undefined') {
                1;
            } else {
                0;
            }
        `;
        
        const result = BrowserJS.runJS(jsCode);
        if (result === 1) {
            // Get the actual data URL using the new string method
            const getDataUrlCode = `
                (function() {
                    const result = window.qmlImageDownloaded;
                    window.qmlImageDownloaded = undefined;
                    return result === 'error' ? 'error' : result;
                })();
            `;
            
            const dataUrl = BrowserJS.runJSString(getDataUrlCode);
            if (dataUrl !== 'error' && dataUrl !== '') {
                imageDownloaded = true;
                imageDataUrl = dataUrl;
            } else {
                console.log("Error downloading image");
            }
            isDownloading = false;
        } else {
            // Continue checking
            Qt.callLater(checkDownloadComplete);
        }
    }

    function checkLoadComplete() {
        const jsCode = `
            if (typeof window.qmlImageLoaded !== 'undefined') {
                const result = window.qmlImageLoaded;
                window.qmlImageLoaded = undefined;
                result === 'not-found' ? 2 : (result === 'error' ? 0 : (result === 'success' ? 1 : 0));
            } else {
                -1;
            }
        `;
        
        const result = BrowserJS.runJS(jsCode);
        if (result >= 0) {
            if (result === 1) {
                // Get the actual data URL from the stored result
                const getDataUrlCode = `
                    (function() {
                        const data = window.qmlImageLoadedData || 'error';
                        window.qmlImageLoadedData = undefined;
                        return data;
                    })();
                `;
                
                const dataUrl = BrowserJS.runJSString(getDataUrlCode);
                if (dataUrl !== 'error' && dataUrl !== '') {
                    imageDownloaded = true;
                    imageDataUrl = dataUrl;
                } else {
                    console.log("Error loading image from IndexedDB");
                }
            } else if (result === 2) {
                console.log("No image found in IndexedDB");
            }
            isDownloading = false;
        } else {
            Qt.callLater(checkLoadComplete);
        }
    }

    function checkClearComplete() {
        const jsCode = `
            if (typeof window.qmlStorageCleared !== 'undefined') {
                window.qmlStorageCleared = undefined;
                1;
            } else {
                0;
            }
        `;
        
        const result = BrowserJS.runJS(jsCode);
        if (result === 1) {
            imageDownloaded = false;
            imageDataUrl = "";
            console.log("Storage cleared");
        } else {
            Qt.callLater(checkClearComplete);
        }
    }
}
