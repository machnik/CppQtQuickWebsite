import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 2"
    readonly property string subHeaderText: "An image."

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

    Image {
        source: "qrc:/resources/images/picture.jpg"
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
