import QtQuick
import QtQuick.Controls

Page {

    readonly property string headerText: "SubPage 17"
    readonly property string subHeaderText: "Loading and saving/downloading a local file."

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
        id: fileContentsRectangle
        width: parent.width * 0.8
        height: parent.height * 0.5
        color: "white"
        border.color: "black"
        border.width: 1
        anchors.centerIn: parent

        TextArea {
            id: fileContentsTextArea
            text: "This is a long, multi-line text that needs to be displayed in the center."
            width: parent.width * 0.8
            height: parent.height * 0.6
            wrapMode: Text.WordWrap
            anchors.fill: parent
            font.pixelSize: 11
        }
    }

    Rectangle {
        width: openFileButton.width + saveFileButton.width + 30
        height: openFileButton.height + 20
        color: "lightyellow"
        anchors.bottom: toMainPageButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        Button {
            id: openFileButton
            text: "Open Text File"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            onClicked: {
                console.log("Open File button clicked.")
            }
        }

        Button {
            id: saveFileButton
            text: "Save/Download Text File"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            onClicked: {
                console.log("Save File button clicked.")
            }
        }
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
