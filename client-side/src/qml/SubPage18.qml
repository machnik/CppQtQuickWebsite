import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(18)
    readonly property string subHeaderText: Localization.string("Avatar generator using DiceBear API.")

    readonly property string avatarPlaceholder: "qrc:/resources/images/avatar_placeholder.png"

    property int bigFontSize: ZoomSettings.bigFontSize

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
        }
    }

    Button {
        text: Localization.string("New Avatar")
        font.pointSize: bigFontSize
        anchors.top: avatarArea.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            var xhr = new XMLHttpRequest();
            var url =
                "https://api.dicebear.com/8.x/" + styleComboBox.currentText +
                "/svg?seed=" + Math.random();
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        avatarImage.source = url;
                    } else {
                        console.log("Error: " + xhr.status);
                        avatarImage.source = avatarPlaceholder;
                    }
                }
            }
            xhr.send();
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
