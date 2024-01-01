import QtQuick
import QtQuick.Controls

Page {
    id: subPage7

    Label {
        id: headerLabel
        text: "SubPage 7"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "3D View."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
