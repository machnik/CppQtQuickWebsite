import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import CppQtQuickWebsite.CppObjects

Page {
    id: root
    title: qsTr("SubPage %1").arg(23)

    property bool browserEnv: BrowserJS.browserEnvironment
    property string statusText: ""
    property color statusColor: "black"

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 20; spacing: 10

        Text {
            text: browserEnv
                ? qsTr("Download & IndexedDB demo")
                : qsTr("This only runs in a browser (WebAssembly).")
            wrapMode: Text.WordWrap
        }

        RowLayout { spacing: 10
            Button { text: qsTr("Download"); enabled: browserEnv; onClicked: download() }
            Button { text: qsTr("Store");    enabled: browserEnv && img.source; onClicked: store() }
            Button { text: qsTr("Load");     enabled: browserEnv; onClicked: load() }
            Button { text: qsTr("Clear");    enabled: browserEnv; onClicked: clearDB() }
        }

        Text {
            text: statusText
            color: statusColor
            wrapMode: Text.WordWrap
        }

        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 300
            color: "#fff"; border.color: "#ccc"; border.width: 1

            Image {
                id: img
                anchors.fill: parent
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

    function setStatus(txt, clr) {
        statusText = txt
        statusColor = clr
    }

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

    function store() {
        setStatus(qsTr("Storing…"), "blue")
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
                    tx.objectStore("i").put({ id: 1, data: "${img.source}" });
                    await new Promise((r, j) => { tx.oncomplete = r; tx.onerror = j; });
                    window._ok = 1;
                } catch (e) { window._err = e; }
            })();
        `);
        poll("_ok", "_err", function(_, err) {
            if (err) setStatus(qsTr("Error storing"), "red");
            else setStatus(qsTr("Stored"), "green");
        });
    }

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

    function clearDB() {
        setStatus(qsTr("Clearing…"), "blue")
        BrowserJS.runVoidJS(`indexedDB.deleteDatabase("DB"); window._ok = 1;`);
        poll("_ok", "", function() {
            img.source = "";
            setStatus(qsTr("Cleared"), "green");
        });
    }

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
}
