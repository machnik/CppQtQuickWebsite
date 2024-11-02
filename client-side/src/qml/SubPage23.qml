import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 23"
    readonly property string subHeaderText: "Placeholder for future content."

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
        text: "This page is a placeholder for future content."
        anchors.centerIn: parent
        font.pointSize: ZoomSettings.bigFontSize
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
