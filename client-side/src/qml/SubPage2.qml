import QtQuick
import QtQuick.Controls

Page {

    readonly property string headerText: "SubPage 2"
    readonly property string subHeaderText: "An image."

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
