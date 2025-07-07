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
                    const db = await new Promise((res, rej) => {
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
                            rej(event);
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
        setStatus(qsTr("Loading…"), "blue")
        BrowserJS.runVoidJS(`
            (async () => {
                try {
                    console.log("JS: Loading from IndexedDB");
                    const db = await new Promise((res, rej) => {
                        const o = indexedDB.open("DB", 1);
                        o.onupgradeneeded = (event) => {
                            console.log("JS: DB upgrade needed during load");
                            const db = event.target.result;
                            if (!db.objectStoreNames.contains("i")) {
                                db.createObjectStore("i", { keyPath: "id" });
                            }
                        };
                        o.onsuccess = () => {
                            console.log("JS: DB opened for load");
                            const db = o.result;
                            if (!db.objectStoreNames.contains("i")) {
                                console.log("JS: No object store found during load");
                                window._noData = 1;
                                res(null);
                                return;
                            }
                            res(db);
                        };
                        o.onerror = rej;
                    });
                    
                    if (!db) {
                        console.log("JS: No database available");
                        return;
                    }
                    
                    const tx = db.transaction("i", "readonly");
                    const store = tx.objectStore("i");
                    const result = await new Promise((r, j) => {
                        const req = store.get(1);
                        req.onsuccess = () => {
                            console.log("JS: Load request completed");
                            r(req.result);
                        };
                        req.onerror = j;
                    });
                    
                    if (result && result.data) {
                        console.log("JS: Data found, setting to window");
                        window._img = result.data;
                    } else {
                        console.log("JS: No data found");
                        window._noData = 1;
                    }
                } catch (e) { 
                    console.log("JS: Load exception:", e);
                    window._err = e.toString(); 
                }
            })();
        `);
        poll("_img", "_err", function(v, err) {
            if (err) setStatus(qsTr("Error loading"), "red");
            else if (v) {
                img.source = v;
                setStatus(qsTr("Loaded"), "green");
            } else setStatus(qsTr("Not found"), "orange");
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
