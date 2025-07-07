import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    id: root
    color: "transparent"

    readonly property string headerText: Localization.string("SubPage %1").arg(23)
    readonly property string subHeaderText: Localization.string("Using IndexedDB to store files.")

    property bool browserEnv: BrowserJS.browserEnvironment
    property string statusText: ""
    property color statusColor: "black"

    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize

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
            text: browserEnv
                ? qsTr("Attempting to use IndexedDB to cache data to avoid re-downloading on repeated visits.\nUnfortunately, a quite unstable solution yet.")
                : qsTr("This example is only applicable when the application is running in a browser.")
            wrapMode: Text.WordWrap
            font.pointSize: regularFontSize
        }

        RowLayout { spacing: 10
            Button { text: qsTr("Download Picture"); enabled: browserEnv; font.pointSize: regularFontSize; onClicked: download() }
            Button { text: qsTr("Store as IndexedDB record");    enabled: browserEnv && img.source; font.pointSize: regularFontSize; onClicked: store() }
            Button { text: qsTr("Load from IndexedDB record");     enabled: browserEnv; font.pointSize: regularFontSize; onClicked: load() }
            Button { text: qsTr("Clear IndexedDB record");    enabled: browserEnv; font.pointSize: regularFontSize; onClicked: clearDB() }
        }

        Text {
            text: statusText
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
                    window._img = u;
                } catch (e) { window._err = e; }
            })();
        `);
        poll("_img", "_err", function(v, err) {
            if (err) setStatus(qsTr("Error downloading"), "red");
            else {
                img.source = v;
                setStatus(qsTr("Downloaded"), "green");
            }
        });
    }

    // Stores the current image source into IndexedDB under a fixed record
    function store() {
        console.log("store() called, img.source:", img.source ? "has data" : "empty", "length:", img.source ? img.source.length : "undefined")
        
        if (!img.source) {
            setStatus(qsTr("No image to store"), "red")
            return
        }
        
        setStatus(qsTr("Storing…"), "blue")
        
        console.log("About to pass image data to JavaScript")
        // Pass the image data to JavaScript safely
        BrowserJS.runVoidJS("window._imageData = " + JSON.stringify(img.source) + ";");
        
        console.log("About to execute IndexedDB storage JavaScript")
        BrowserJS.runVoidJS(`
            (async () => {
                try {
                    console.log("JS: Starting IndexedDB operation");
                    console.log("JS: Checking IndexedDB availability...");
                    console.log("JS: typeof indexedDB:", typeof indexedDB);
                    console.log("JS: indexedDB:", indexedDB);
                    
                    if (!indexedDB) {
                        throw new Error("IndexedDB not available");
                    }
                    
                    console.log("JS: IndexedDB available, opening database...");
                    const db = await new Promise((res, rej) => {
                        // First, try to open without specifying version to check current version
                        const versionCheck = indexedDB.open("DB");
                        versionCheck.onsuccess = () => {
                            const currentDb = versionCheck.result;
                            const currentVersion = currentDb.version;
                            console.log("JS: Current DB version:", currentVersion);
                            currentDb.close();
                            
                            // Now open with appropriate version
                            const targetVersion = Math.max(currentVersion, 1);
                            console.log("JS: Opening DB with version:", targetVersion);
                            const o = indexedDB.open("DB", targetVersion);
                            
                            o.onupgradeneeded = (event) => {
                                console.log("JS: DB upgrade needed - creating object store");
                                const db = event.target.result;
                                if (!db.objectStoreNames.contains("i")) {
                                    db.createObjectStore("i", { keyPath: "id" });
                                    console.log("JS: Object store 'i' created during upgrade");
                                }
                            };
                            o.onsuccess = () => {
                                console.log("JS: DB opened successfully");
                                const db = o.result;
                                console.log("JS: Final DB version:", db.version);
                                console.log("JS: Available object stores:", Array.from(db.objectStoreNames));
                                
                                // Check if we need to create object store after opening
                                if (!db.objectStoreNames.contains("i")) {
                                    console.log("JS: Object store 'i' missing, need to upgrade DB");
                                    // Close and reopen with higher version to trigger upgrade
                                    db.close();
                                    const upgradeReq = indexedDB.open("DB", db.version + 1);
                                    upgradeReq.onupgradeneeded = (event) => {
                                        console.log("JS: Creating object store in forced upgrade");
                                        const upgradeDb = event.target.result;
                                        upgradeDb.createObjectStore("i", { keyPath: "id" });
                                    };
                                    upgradeReq.onsuccess = () => {
                                        console.log("JS: Upgrade completed, resolving with new DB");
                                        res(upgradeReq.result);
                                    };
                                    upgradeReq.onerror = (event) => {
                                        console.log("JS: Upgrade error:", event);
                                        rej(event);
                                    };
                                } else {
                                    console.log("JS: Object store 'i' exists, proceeding");
                                    res(db);
                                }
                            };
                            o.onerror = (event) => {
                                console.log("JS: DB open error:", event);
                                console.log("JS: DB open error name:", event.target.error?.name);
                                console.log("JS: DB open error message:", event.target.error?.message);
                                console.log("JS: DB open error code:", event.target.error?.code);
                                console.log("JS: Event type:", event.type);
                                console.log("JS: Event target:", event.target);
                                rej(event.target.error || "Database open failed");
                            };
                        };
                        versionCheck.onerror = (event) => {
                            console.log("JS: Version check failed, trying version 1");
                            // If version check fails, try with version 1
                            const o = indexedDB.open("DB", 1);
                            o.onupgradeneeded = (event) => {
                                console.log("JS: DB upgrade needed - creating object store");
                                const db = event.target.result;
                                if (!db.objectStoreNames.contains("i")) {
                                    db.createObjectStore("i", { keyPath: "id" });
                                    console.log("JS: Object store 'i' created during upgrade");
                                }
                            };
                            o.onsuccess = () => {
                                console.log("JS: DB opened successfully");
                                const db = o.result;
                                // Check if we need to create object store after opening
                                if (!db.objectStoreNames.contains("i")) {
                                    console.log("JS: Object store 'i' missing, need to upgrade DB");
                                    // Close and reopen with higher version to trigger upgrade
                                    db.close();
                                    const upgradeReq = indexedDB.open("DB", db.version + 1);
                                    upgradeReq.onupgradeneeded = (event) => {
                                        console.log("JS: Creating object store in forced upgrade");
                                        const upgradeDb = event.target.result;
                                        upgradeDb.createObjectStore("i", { keyPath: "id" });
                                    };
                                    upgradeReq.onsuccess = () => {
                                        console.log("JS: Upgrade completed, resolving with new DB");
                                        res(upgradeReq.result);
                                    };
                                    upgradeReq.onerror = (event) => {
                                        console.log("JS: Upgrade error:", event);
                                        rej(event);
                                    };
                                } else {
                                    console.log("JS: Object store 'i' exists, proceeding");
                                    res(db);
                                }
                            };
                            o.onerror = (event) => {
                                console.log("JS: DB open error:", event);
                                console.log("JS: DB open error name:", event.target.error?.name);
                                console.log("JS: DB open error message:", event.target.error?.message);
                                console.log("JS: DB open error code:", event.target.error?.code);
                                console.log("JS: Event type:", event.type);
                                console.log("JS: Event target:", event.target);
                                rej(event.target.error || "Database open failed");
                            };
                        };
                    });
                    
                    console.log("JS: Creating transaction");
                    const tx = db.transaction("i", "readwrite");
                    const store = tx.objectStore("i");
                    console.log("JS: Putting data into store");
                    store.put({ id: 1, data: window._imageData });
                    
                    await new Promise((r, j) => { 
                        tx.oncomplete = () => {
                            console.log("JS: Transaction completed successfully");
                            r();
                        };
                        tx.onerror = (e) => {
                            console.log("JS: Transaction error:", e);
                            j(e);
                        };
                    });
                    delete window._imageData;
                    console.log("JS: Setting success flag");
                    window._ok = 1;
                } catch (e) { 
                    console.log("JS: Exception caught:", e);
                    console.log("JS: Exception name:", e.name);
                    console.log("JS: Exception message:", e.message);
                    console.log("JS: Exception stack:", e.stack);
                    console.log("JS: Exception toString:", e.toString());
                    window._err = e.toString(); 
                }
            })();
        `);
        console.log("Starting poll for store operation")
        poll("_ok", "_err", function(_, err) {
            console.log("store poll callback called, err:", err)
            if (err) setStatus(qsTr("Error storing"), "red");
            else setStatus(qsTr("Stored"), "green");
        });
    }

    // Loads the stored image from IndexedDB into the Image element
    function load() {
        console.log("load() called")
        setStatus(qsTr("Loading…"), "blue")
        
        console.log("About to execute IndexedDB load JavaScript")
        BrowserJS.runVoidJS(`
            (async () => {
                try {
                    console.log("JS: Starting load from IndexedDB");
                    console.log("JS: Attempting to open database 'DB'");
                    
                    const db = await new Promise((res, rej) => {
                        console.log("JS: Creating indexedDB.open request");
                        // First, try to open without specifying version to check current version
                        const versionCheck = indexedDB.open("DB");
                        versionCheck.onsuccess = () => {
                            const currentDb = versionCheck.result;
                            const currentVersion = currentDb.version;
                            console.log("JS: Current DB version for load:", currentVersion);
                            currentDb.close();
                            
                            // Now open with appropriate version
                            const targetVersion = Math.max(currentVersion, 1);
                            console.log("JS: Opening DB for load with version:", targetVersion);
                            const o = indexedDB.open("DB", targetVersion);
                            o.onupgradeneeded = (event) => {
                                console.log("JS: onupgradeneeded triggered during load fallback");
                                const db = event.target.result;
                                if (!db.objectStoreNames.contains("i")) {
                                    console.log("JS: Creating object store 'i' during load fallback");
                                    db.createObjectStore("i", { keyPath: "id" });
                                }
                            };
                            o.onsuccess = () => {
                                console.log("JS: DB opened successfully for load (fallback)");
                                const db = o.result;
                                if (!db.objectStoreNames.contains("i")) {
                                    console.log("JS: No object store found during load fallback");
                                    window._noData = 1;
                                    res(null);
                                    return;
                                }
                                res(db);
                            };
                            o.onerror = (event) => {
                                console.log("JS: DB open error during load fallback:", event);
                                rej(event.target.error);
                            };
                        };
                        versionCheck.onerror = (event) => {
                            console.log("JS: Version check failed during load, trying version 1");
                            // If version check fails, try with version 1
                            const o = indexedDB.open("DB", 1);
                            o.onupgradeneeded = (event) => {
                                console.log("JS: onupgradeneeded triggered during load fallback");
                                const db = event.target.result;
                                if (!db.objectStoreNames.contains("i")) {
                                    console.log("JS: Creating object store 'i' during load fallback");
                                    db.createObjectStore("i", { keyPath: "id" });
                                }
                            };
                            o.onsuccess = () => {
                                console.log("JS: DB opened successfully for load (fallback)");
                                const db = o.result;
                                if (!db.objectStoreNames.contains("i")) {
                                    console.log("JS: No object store found during load fallback");
                                    window._noData = 1;
                                    res(null);
                                    return;
                                }
                                res(db);
                            };
                            o.onerror = (event) => {
                                console.log("JS: DB open error during load fallback:", event);
                                rej(event.target.error);
                            };
                        };
                    });
                    
                    if (!db) {
                        console.log("JS: No database available for load");
                        window._err = "Database unavailable";
                        return;
                    }
                    
                    console.log("JS: Creating readonly transaction for load");
                    const tx = db.transaction("i", "readonly");
                    
                    tx.onerror = (event) => {
                        console.log("JS: Transaction error during load:", event);
                    };
                    
                    console.log("JS: Getting object store 'i'");
                    const store = tx.objectStore("i");
                    console.log("JS: Object store obtained, requesting record with id=1");
                    
                    const result = await new Promise((r, j) => {
                        const req = store.get(1);
                        req.onsuccess = () => {
                            console.log("JS: Get request completed successfully");
                            console.log("JS: Result:", req.result);
                            console.log("JS: Result type:", typeof req.result);
                            if (req.result) {
                                console.log("JS: Result has data property:", !!req.result.data);
                                console.log("JS: Data type:", typeof req.result.data);
                                console.log("JS: Data length:", req.result.data ? req.result.data.length : "undefined");
                            }
                            r(req.result);
                        };
                        req.onerror = (event) => {
                            console.log("JS: Get request error:", event);
                            console.log("JS: Error details:", event.target.error);
                            j(event.target.error);
                        };
                    });
                    
                    console.log("JS: Processing load result");
                    if (result && result.data) {
                        console.log("JS: Data found! Setting to window._img");
                        console.log("JS: Data preview:", result.data.substring(0, 50) + "...");
                        window._img = result.data;
                    } else if (result) {
                        console.log("JS: Record exists but no data property");
                        window._err = "Record exists but no data";
                    } else {
                        console.log("JS: No record found with id=1");
                        window._noData = 1;
                    }
                } catch (e) { 
                    console.log("JS: Exception caught during load:", e);
                    console.log("JS: Exception stack:", e.stack);
                    window._err = e.toString(); 
                }
            })();
        `);
        
        console.log("Starting poll for load operation")
        poll("_img", "_err", function(v, err) {
            console.log("load poll callback called, value:", v ? "has data (length: " + v.length + ")" : "null", "err:", err)
            if (err) {
                console.log("Load failed with error:", err)
                setStatus(qsTr("Error loading: ") + err, "red");
            } else if (v) {
                console.log("Load successful, setting image source")
                img.source = v;
                setStatus(qsTr("Loaded"), "green");
            } else {
                console.log("No data found during load")
                var noData = BrowserJS.runJS("window._noData");
                if (noData) {
                    console.log("Confirmed: no data exists in database")
                    setStatus(qsTr("No stored image"), "orange");
                } else {
                    console.log("Unknown load failure")
                    setStatus(qsTr("Load failed"), "red");
                }
            }
        });
    }

    // Clears the IndexedDB database and resets the image source
    function clearDB() {
        setStatus(qsTr("Clearing…"), "blue")
        BrowserJS.runVoidJS(`indexedDB.deleteDatabase("DB"); window._ok = 1;`);
        poll("_ok", "", function() {
            img.source = "";
            setStatus(qsTr("Cleared"), "green");
        });
    }

    // Polls for JavaScript-side globals (_img, _err, _ok) and invokes callback when set
    function poll(okKey, errKey, cb) {
        console.log("poll() called with okKey:", okKey, "errKey:", errKey)
        var ok  = BrowserJS.runIntJS(`typeof window.${okKey} !== 'undefined' ? 1 : 0`);
        var err = errKey
            ? BrowserJS.runIntJS(`typeof window.${errKey} !== 'undefined' ? 1 : 0`)
            : 0;
        console.log("poll results - ok:", ok, "err:", err)
        if (ok || err) {
            var v = ok ? BrowserJS.runStringJS(`window.${okKey}`) : null;
            console.log("poll found result, value:", v, "isError:", !!err)
            BrowserJS.runVoidJS(
                `delete window.${okKey}` +
                (errKey ? `; delete window.${errKey}` : ``)
            );
            cb(v, !!err);
        } else {
            console.log("poll continuing...")
            Qt.callLater(function() { poll(okKey, errKey, cb) });
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
    }
}
