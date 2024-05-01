import QtQuick
import QtQuick.Controls

Page {

    readonly property string headerText: "SubPage 10"
    readonly property string subHeaderText: "Avatar generator using DiceBear API."

    readonly property string avatarPlaceholder: "qrc:/resources/images/avatar_placeholder.png"

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Rectangle {
        id: avatarArea
        width: 256; height: 256
        anchors.centerIn: parent

        Image {
            id: avatarImage
            anchors.fill: parent
            source: avatarPlaceholder
        }
    }

    Button {
        id: newAvatarButton
        text: "Make New Avatar"
        anchors.top: avatarArea.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            var xhr = new XMLHttpRequest();
            var url = "https://api.dicebear.com/8.x/rings/svg?seed=" + Math.random();
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
