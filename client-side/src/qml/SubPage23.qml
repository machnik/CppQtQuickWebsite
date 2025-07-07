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
        setStatus(qsTr("Storing…"), "blue")
        
        // Pass the image data to JavaScript safely
        BrowserJS.runVoidJS("window._imageData = " + JSON.stringify(img.source) + ";");
        
        BrowserJS.runVoidJS(`
            (async () => {
                try {
                    const db = await new Promise((res, rej) => {
                        const o = indexedDB.open("DB", 1);
                        o.onupgradeneeded = () => o.result.createObjectStore("i", { keyPath: "id" });
                        o.onsuccess = () => res(o.result);
                        o.onerror = () => rej();
                    });
                    const tx = db.transaction("i", "readwrite");
                    tx.objectStore("i").put({ id: 1, data: window._imageData });
                    await new Promise((r, j) => { tx.oncomplete = r; tx.onerror = j; });
                    delete window._imageData;
                    window._ok = 1;
                } catch (e) { window._err = e; }
            })();
        `);
        poll("_ok", "_err", function(_, err) {
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
                    const db = await new Promise((res, rej) => {
                        const o = indexedDB.open("DB", 1);
                        o.onsuccess = () => res(o.result);
                        o.onerror = () => rej();
                    });
                    const rec = await new Promise(r => {
                        const q = db.transaction("i").objectStore("i").get(1);
                        q.onsuccess = () => r(q.result && q.result.data);
                    });
                    window._img = rec;
                } catch (e) { window._err = e; }
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
        var ok  = BrowserJS.runIntJS(`typeof window.${okKey} !== 'undefined' ? 1 : 0`);
        var err = errKey
            ? BrowserJS.runIntJS(`typeof window.${errKey} !== 'undefined' ? 1 : 0`)
            : 0;
        if (ok || err) {
            var v = ok ? BrowserJS.runStringJS(`window.${okKey}`) : null;
            BrowserJS.runVoidJS(
                `delete window.${okKey}` +
                (errKey ? `; delete window.${errKey}` : ``)
            );
            cb(v, !!err);
        } else {
            Qt.callLater(function() { poll(okKey, errKey, cb) });
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
    }
}
