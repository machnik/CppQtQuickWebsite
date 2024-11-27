import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 1"
    readonly property string subHeaderText: "Static webpage with much scrollable text."

    color: "transparent"

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        id: titleLabel
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    ScrollView {
        anchors.top: titleLabel.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: toMainPageButton.top
        anchors.margins: 10

        TextArea {
            readOnly: true
            text: "lorem ipsum dolor sit amet ".repeat(1000)
            font.pointSize: ZoomSettings.regularFontSize
            wrapMode: Text.WordWrap
        }
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
