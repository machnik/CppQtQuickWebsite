import QtQuick
import QtQuick.Controls
import QtQuick.LocalStorage

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 7"
    readonly property string subHeaderText: "Local persistent storage."

    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize

    function getDatabase() {
        return LocalStorage.openDatabaseSync("ExampleDatabase", "1.0", "Example Database", 1000000);
    }

    function saveSetting(key, value) {
        var db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?, ?)', [key, value]);
        });
    }

    function loadSetting(key) {
        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT value FROM settings WHERE key=?', [key]);
            if (rs.rows.length > 0) {
                res = rs.rows.item(0).value;
            }
        });
        return res;
    }

    Component.onCompleted: {
        var db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
        });
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
        id: inputArea
        width: parent.width * 0.8
        height: parent.height * 0.5

        anchors.centerIn: parent

        border.color: "black"
        border.width: 1

        Rectangle {
            width: keyField.width + valueField.width + 20
            height: keyField.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

            TextField {
                id: keyField
                width: inputArea.width * 0.45
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                placeholderText: "Enter key and press ENTER to load entry"
                font.pointSize: bigFontSize
                onAccepted: {
                    if (keyField.text === "") {
                        resultLabel.text = "Key cannot be empty!";
                        return;
                    }
                    var key = keyField.text;
                    var value = loadSetting(key);
                    resultLabel.text = "Loaded value for key: " + key + " is " + (value ? value : "<empty>");
                }
            }

            TextField {
                id: valueField
                width: inputArea.width * 0.45
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                placeholderText: "Enter value and press ENTER to save entry"
                font.pointSize: bigFontSize
                onAccepted: {
                    var key = keyField.text;
                    var value = valueField.text;
                    saveSetting(key, value);
                    resultLabel.text = 
                        "Saved value " + (value ? value : "<empty>") +
                        " for key: " + (key ? key : "<empty>");
                }
            }
        }

        Label {
            id: resultLabel
            width: parent.width * 0.8
            anchors.centerIn: parent
            font.family: "Monospace"
            font.pointSize: bigFontSize
            font.bold: true
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
