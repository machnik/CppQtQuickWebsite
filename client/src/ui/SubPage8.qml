import QtQuick
import QtQuick.Controls

Page {
    id: subPage8

    Label {
        id: headerLabel
        text: "SubPage 8"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Floating pop-up window."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
