import QtQuick
import QtQuick.Controls

Page {
    id: subPage2

    Label {
        id: headerLabel
        text: "SubPage 2"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Showing an image."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Image {
        source: "qrc:/resources/images/picture.jpg"
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6
    }
}
