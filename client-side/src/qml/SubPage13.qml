import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 13"
    readonly property string subHeaderText: "Loading and saving/downloading a local file."

    property string currentFileName: "untitled.txt"

    Connections {
        target: TextFileIO
        function onCurrentFileNameChanged(fileName) {
            currentFileName = fileName
        }
        function onFileContentReady(content) {
            fileContentsTextArea.text = content
        }
    }

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
    }

    Label {
        text: "File name: " + currentFileName
        anchors.bottom: fileContentsScrollView.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
        font.pointSize: 13
    }

    ScrollView {
        id: fileContentsScrollView
        width: parent.width * 0.7
        height: parent.height * 0.4
        anchors.centerIn: parent

        TextArea {
            id: fileContentsTextArea
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            width: parent.width
            height: parent.height
            wrapMode: Text.WordWrap
            font.pixelSize: 10
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
                TextFileIO.loadFileContent()
            }
        }

        Button {
            id: saveFileButton
            text: "Save/Download Text File"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            onClicked: {
                TextFileIO.saveFileContent(currentFileName, fileContentsTextArea.text)
            }
        }
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
