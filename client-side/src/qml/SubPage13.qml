import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(13)
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

    Label {
        text: Localization.string("File name: %1").arg(currentFileName)
        anchors.bottom: fileContentsScrollView.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
        font.pointSize: ZoomSettings.bigFontSize
    }

    ScrollView {
        id: fileContentsScrollView
        width: parent.width * 0.7
        height: parent.height * 0.4
        anchors.centerIn: parent

        Rectangle {
            width: parent.width
            height: parent.height
            border.color: "black"
            color: "white"

            TextArea {
                id: fileContentsTextArea
                text: Backend.textResource("long_text.txt")
                width: parent.width
                height: parent.height
                wrapMode: Text.WordWrap
                font.pixelSize: ZoomSettings.smallFontSize
            }
        }
    }

    Rectangle {
        width: openFileButton.width + saveFileButton.width + 30
        height: openFileButton.height + 20
        color: "transparent"
        border.color: "black"
        border.width: 1
        radius: 8
        anchors.bottom: toMainPageButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        Button {
            id: openFileButton
            text: Localization.string("Open Text File")
            font.pointSize: ZoomSettings.bigFontSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            onClicked: {
                TextFileIO.loadFileContent()
            }
        }

        Button {
            id: saveFileButton
            text: Localization.string("Save/Download Text File")
            font.pointSize: ZoomSettings.bigFontSize
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
