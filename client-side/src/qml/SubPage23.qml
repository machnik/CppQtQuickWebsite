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
    property bool isStoring: false
    property bool isStoredInDB: false
    property string lastError: ""
    property string lastSuccessMessage: ""
    property int pollCount: 0
    property int maxPollAttempts: 50  // Maximum number of polling attempts

    color: "transparent"
    
    // Timer for polling instead of Qt.callLater
    Timer {
        id: pollTimer
        interval: 100
        repeat: false
        property string operation: ""
        onTriggered: {
            if (operation === "download") {
                checkDownloadComplete();
            } else if (operation === "store") {
                checkStoreComplete();
            } else if (operation === "load") {
                checkLoadComplete();
            } else if (operation === "clear") {
                checkClearComplete();
            }
        }
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
                    enabled: BrowserJS.browserEnvironment && !isDownloading && !isStoring
                    onClicked: downloadImage()
                }

                Button {
                    text: "Store in IndexedDB"
                    enabled: BrowserJS.browserEnvironment && !isDownloading && !isStoring && imageDownloaded && !isStoredInDB
                    onClicked: storeImageInDB()
                }

                Button {
                    text: "Load from IndexedDB"
                    enabled: BrowserJS.browserEnvironment && !isDownloading && !isStoring
                    onClicked: loadImageFromDB()
                }

                Button {
                    text: "Clear Storage"
                    enabled: BrowserJS.browserEnvironment && !isDownloading && !isStoring && isStoredInDB
                    onClicked: clearStorage()
                }
            }

            Label {
                text: {
                    if (isDownloading) return "Downloading image...";
                    if (isStoring) return "Storing image in IndexedDB...";
                    if (lastError !== "") return "Error: " + lastError;
                    if (lastSuccessMessage !== "") return lastSuccessMessage;
                    if (isStoredInDB && imageDownloaded) return "Image downloaded and stored in IndexedDB!";
                    if (imageDownloaded) return "Image downloaded (not yet stored in IndexedDB)";
                    return "No image downloaded yet.";
                }
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                font.pointSize: ZoomSettings.regularFontSize
                color: {
                    if (lastError !== "") return "red";
                    if (lastSuccessMessage !== "") return "green";
                    if (isStoredInDB && imageDownloaded) return "green";
                    if (imageDownloaded) return "orange";
                    return "black";
                }
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
        isStoredInDB = false;
        lastError = "";
        lastSuccessMessage = "";
        pollCount = 0;

        // JavaScript code to download image only (no IndexedDB storage)
        const jsCode = `
            (async function() {
                try {
                    // Download example image (using a public image URL)
                    const imageUrl = 'https://picsum.photos/400/300';
                    const response = await fetch(imageUrl);
                    
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    
                    const blob = await response.blob();
                    
                    // Convert blob to base64
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const dataUrl = e.target.result;
                        
                        // Signal QML that download is complete
                        window.qmlImageDownloaded = dataUrl;
                    };
                    
                    reader.onerror = function(error) {
                        window.qmlImageDownloaded = 'error';
                    };
                    
                    reader.readAsDataURL(blob);
                } catch (error) {
                    window.qmlImageDownloaded = 'error';
                }
            })();
            0; // Return value for emscripten_run_script_int
        `;

        BrowserJS.runIntJS(jsCode);
        
        // Check for completion
        checkDownloadComplete();
    }

    function storeImageInDB() {
        if (!BrowserJS.browserEnvironment || !imageDownloaded || imageDataUrl === "") return;
        
        isStoring = true;
        lastError = "";
        lastSuccessMessage = "";
        pollCount = 0;

        // JavaScript code to store the downloaded image in IndexedDB
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
                    
                    dbRequest.onsuccess = function(event) {
                        const db = event.target.result;
                        
                        try {
                            // Store in IndexedDB
                            const transaction = db.transaction(['images'], 'readwrite');
                            const store = transaction.objectStore('images');
                            
                            // Get the image data from QML (we'll pass it via a global variable)
                            const dataUrl = window.qmlImageDataToStore;
                            if (!dataUrl) {
                                throw new Error('No image data available to store');
                            }
                            
                            const imageData = {
                                id: 'example-image',
                                dataUrl: dataUrl,
                                timestamp: Date.now()
                            };
                            
                            const putRequest = store.put(imageData);
                            
                            putRequest.onsuccess = function() {
                                // Image data successfully stored
                            };
                            
                            putRequest.onerror = function(error) {
                                window.qmlImageStored = 'error';
                                return;
                            };
                            
                            transaction.oncomplete = function() {
                                // Signal QML that storage is complete
                                window.qmlImageStored = 'success';
                            };
                            
                            transaction.onerror = function(error) {
                                window.qmlImageStored = 'error';
                            };
                        } catch (txError) {
                            window.qmlImageStored = 'error';
                        }
                    };
                    
                    dbRequest.onerror = function(error) {
                        window.qmlImageStored = 'error';
                    };
                    
                    dbRequest.onblocked = function() {
                        window.qmlImageStored = 'error';
                    };
                    
                } catch (error) {
                    window.qmlImageStored = 'error';
                }
            })();
            0; // Return value for emscripten_run_script_int
        `;

        // Pass the image data to JavaScript
        BrowserJS.runIntJS("window.qmlImageDataToStore = '" + imageDataUrl + "';");
        
        BrowserJS.runIntJS(jsCode);
        
        // Check for completion
        checkStoreComplete();
    }

    function loadImageFromDB() {
        if (!BrowserJS.browserEnvironment) return;
        
        isDownloading = true;
        lastError = "";
        lastSuccessMessage = "";
        pollCount = 0;
        
        const jsCode = `
            (async function() {
                try {
                    const dbRequest = indexedDB.open('ImageStorageDB', 1);
                    
                    dbRequest.onsuccess = function(event) {
                        const db = event.target.result;
                        
                        try {
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
                            
                            request.onerror = function(error) {
                                window.qmlImageLoaded = 'error';
                            };
                            
                            transaction.onerror = function(error) {
                                window.qmlImageLoaded = 'error';
                            };
                        } catch (txError) {
                            window.qmlImageLoaded = 'error';
                        }
                    };
                    
                    dbRequest.onerror = function(error) {
                        window.qmlImageLoaded = 'error';
                    };
                    
                    dbRequest.onblocked = function() {
                        window.qmlImageLoaded = 'error';
                    };
                } catch (error) {
                    window.qmlImageLoaded = 'error';
                }
            })();
            0;
        `;

        BrowserJS.runIntJS(jsCode);
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
                        
                        try {
                            const transaction = db.transaction(['images'], 'readwrite');
                            const store = transaction.objectStore('images');
                            
                            const clearRequest = store.clear();
                            
                            clearRequest.onsuccess = function() {
                                // Clear request successful
                            };
                            
                            clearRequest.onerror = function(error) {
                                window.qmlStorageCleared = 'error';
                            };
                            
                            transaction.oncomplete = function() {
                                window.qmlStorageCleared = 'true';
                            };
                            
                            transaction.onerror = function(error) {
                                window.qmlStorageCleared = 'error';
                            };
                        } catch (txError) {
                            window.qmlStorageCleared = 'error';
                        }
                    };
                    
                    dbRequest.onerror = function(error) {
                        window.qmlStorageCleared = 'error';
                    };
                    
                    dbRequest.onblocked = function() {
                        window.qmlStorageCleared = 'error';
                    };
                } catch (error) {
                    window.qmlStorageCleared = 'error';
                }
            })();
            0;
        `;

        BrowserJS.runIntJS(jsCode);
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
        
        const result = BrowserJS.runIntJS(jsCode);
        
        pollCount++;
        
        if (result === 1) {
            // Get the actual data URL using the new string method
            const getDataUrlCode = `
                (function() {
                    const result = window.qmlImageDownloaded;
                    window.qmlImageDownloaded = undefined;
                    return result === 'error' ? 'error' : result;
                })();
            `;
            
            const dataUrl = BrowserJS.runStringJS(getDataUrlCode);
            
            if (dataUrl !== 'error' && dataUrl !== '') {
                imageDownloaded = true;
                imageDataUrl = dataUrl;
                lastError = "";
                lastSuccessMessage = "Image downloaded from internet!";
            } else {
                lastError = "Failed to download image";
            }
            isDownloading = false;
        } else if (pollCount >= maxPollAttempts) {
            lastError = "Download timeout";
            isDownloading = false;
        } else {
            // Continue checking with timer
            pollTimer.operation = "download";
            pollTimer.start();
        }
    }

    function checkStoreComplete() {
        const jsCode = `
            if (typeof window.qmlImageStored !== 'undefined') {
                const result = window.qmlImageStored;
                window.qmlImageStored = undefined;
                result === 'success' ? 1 : 0;
            } else {
                -1;
            }
        `;
        
        const result = BrowserJS.runIntJS(jsCode);
        
        pollCount++;
        
        if (result >= 0) {
            if (result === 1) {
                isStoredInDB = true;
                lastError = "";
                lastSuccessMessage = "Image stored to IndexedDB!";
            } else {
                lastError = "Failed to store image in IndexedDB";
            }
            isStoring = false;
            
            // Clean up the temporary data
            BrowserJS.runIntJS("if (typeof window.qmlImageDataToStore !== 'undefined') { delete window.qmlImageDataToStore; }");
        } else if (pollCount >= maxPollAttempts) {
            lastError = "Store timeout";
            isStoring = false;
            BrowserJS.runIntJS("if (typeof window.qmlImageDataToStore !== 'undefined') { delete window.qmlImageDataToStore; }");
        } else {
            pollTimer.operation = "store";
            pollTimer.start();
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
        
        const result = BrowserJS.runIntJS(jsCode);
        
        pollCount++;
        
        if (result >= 0) {
            if (result === 1) {
                // Check if we already have the image loaded to avoid memory issues
                if (imageDataUrl !== "" && imageDownloaded) {
                    // Image is already loaded, just confirm the state
                    imageDownloaded = true;
                    isStoredInDB = true;  // If we're loading from IndexedDB, it must be stored there
                    lastSuccessMessage = "Image loaded from IndexedDB!";
                    
                    // Clean up the JavaScript side
                    BrowserJS.runIntJS("if (typeof window.qmlImageLoadedData !== 'undefined') { window.qmlImageLoadedData = undefined; }");
                } else {
                    // Use a safer approach - get length first, then decide how to get data
                    const getLengthCode = `
                        (function() {
                            if (typeof window.qmlImageLoadedData !== 'undefined') {
                                const data = window.qmlImageLoadedData;
                                return data ? data.length : 0;
                            } else {
                                return 0;
                            }
                        })();
                    `;
                    
                    const dataLength = BrowserJS.runIntJS(getLengthCode);
                    
                    if (dataLength > 0) {
                        try {
                            // Try to get the data URL, with error handling
                            const getDataUrlCode = `
                                (function() {
                                    if (typeof window.qmlImageLoadedData !== 'undefined') {
                                        const data = window.qmlImageLoadedData;
                                        window.qmlImageLoadedData = undefined;
                                        return data || 'error';
                                    } else {
                                        return 'error';
                                    }
                                })();
                            `;
                            
                            const dataUrl = BrowserJS.runStringJS(getDataUrlCode);
                            
                            if (dataUrl !== 'error' && dataUrl !== '') {
                                imageDownloaded = true;
                                imageDataUrl = dataUrl;
                                isStoredInDB = true;  // Image was loaded from IndexedDB, so it's stored there
                                lastSuccessMessage = "Image loaded from IndexedDB!";
                            }
                        } catch (e) {
                            // Clean up even if there was an error
                            BrowserJS.runIntJS("if (typeof window.qmlImageLoadedData !== 'undefined') { window.qmlImageLoadedData = undefined; }");
                        }
                    }
                }
            } else if (result === 2) {
                lastError = "No image found in IndexedDB";
            } else {
                lastError = "Error loading image from IndexedDB";
            }
            isDownloading = false;
        } else if (pollCount >= maxPollAttempts) {
            lastError = "Load timeout";
            isDownloading = false;
        } else {
            pollTimer.operation = "load";
            pollTimer.start();
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
        
        const result = BrowserJS.runIntJS(jsCode);
        
        if (result === 1) {
            imageDownloaded = false;
            imageDataUrl = "";
            isStoredInDB = false;
            lastError = "";
            lastSuccessMessage = "IndexedDB storage cleared!";
        } else {
            pollTimer.operation = "clear";
            pollTimer.start();
        }
    }
}
