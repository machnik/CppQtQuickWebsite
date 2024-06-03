import QtQuick
import QtQuick.Controls

Page {

    readonly property string headerText: "SubPage 17"
    readonly property string subHeaderText: "Loading a file from the local filesystem."

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

    Text {
        id: textFileContents
        text: "This is a long, multi-line text that needs to be displayed in the center."
        width: parent.width * 0.8
        height: parent.height * 0.6
        wrapMode: Text.WordWrap
        anchors.centerIn: parent
        font.pixelSize: 11
    }

    Button {
        id: openFileButton
        text: "Open Text File"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: toMainPageButton.top
        anchors.margins: 20
        onClicked: {
            console.log("Open File button clicked.")
        }
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
