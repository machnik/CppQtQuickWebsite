import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(21)
    readonly property string subHeaderText: Localization.string("Avatar generator using DiceBear API.")

    readonly property string avatarPlaceholder: "qrc:/resources/images/avatar_placeholder.png"

    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize
    property var currentRequest: null
    property bool requestInProgress: false
    property string statusText: ""
    property color statusColor: "black"

    color: "transparent"

    function setStatus(text, color) {
        statusText = text
        statusColor = color
    }

    Component.onDestruction: {
        if (currentRequest) {
            currentRequest.abort()
            currentRequest = null
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
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    ComboBox {
        id: styleComboBox
        width: 200
        model: [
            "adventurer", "avataaars", "bottts", "croodles",
            "fun-emoji", "icons", "identicon", "lorelei",
            "micah", "miniavs", "notionists", "open-peeps",
            "personas", "shapes", "rings", "thumbs"
        ]
        currentIndex: 0
        font.pointSize: bigFontSize
        anchors.bottom: avatarArea.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
    }

    Rectangle {
        id: avatarArea
        width: 200; height: 200
        anchors.centerIn: parent

        Image {
            id: avatarImage
            anchors.fill: parent
            source: avatarPlaceholder
            fillMode: Image.PreserveAspectFit
        }
    }

    Button {
        text: requestInProgress ? Localization.string("Loading avatar...") : Localization.string("New Avatar")
        font.pointSize: bigFontSize
        enabled: !requestInProgress
        anchors.top: avatarArea.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            requestInProgress = true
            setStatus(Localization.string("Loading avatar..."), "blue")

            // This page intentionally uses the browser networking API directly
            // so learners can compare a JS-side fetch with the Qt networking
            // approach demonstrated on other pages.
            var xhr = new XMLHttpRequest();
            var url =
                "https://api.dicebear.com/8.x/" + styleComboBox.currentText +
                "/svg?seed=" + Math.random();
            currentRequest = xhr
            xhr.timeout = 10000;
            xhr.open('GET', url, true);
            // XHR callbacks run later. Comparing identities prevents an
            // obsolete request from updating this page after cancellation.
            xhr.onreadystatechange = function() {
                if (currentRequest !== xhr) {
                    return
                }

                if (xhr.readyState === XMLHttpRequest.DONE) {
                    currentRequest = null
                    requestInProgress = false

                    if (xhr.status === 200) {
                        avatarImage.source = url
                        setStatus(Localization.string("Avatar loaded"), "green")
                    } else {
                        avatarImage.source = avatarPlaceholder
                        setStatus(Localization.string("Avatar request failed: HTTP %1").arg(xhr.status), "red")
                    }
                }
            }
            xhr.onerror = function() {
                if (currentRequest !== xhr) {
                    return
                }

                currentRequest = null
                requestInProgress = false
                avatarImage.source = avatarPlaceholder
                setStatus(Localization.string("Avatar request failed."), "red")
            }
            xhr.ontimeout = function() {
                if (currentRequest !== xhr) {
                    return
                }

                currentRequest = null
                requestInProgress = false
                avatarImage.source = avatarPlaceholder
                setStatus(Localization.string("Avatar request failed."), "red")
            }
            xhr.send();
        }
    }

    Label {
        width: parent.width * 0.7
        anchors.top: avatarArea.bottom
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        text: statusText
        color: statusColor
        font.pointSize: regularFontSize
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
