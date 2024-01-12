import QtQuick
import QtQuick.Controls

Page {
    id: subPage9

    Label {
        id: headerLabel
        text: "SubPage 11"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Qt Quick 3D Physics."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
