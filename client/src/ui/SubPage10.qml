import QtQuick
import QtQuick.Controls

Page {
    id: subPage10

    Label {
        id: headerLabel
        text: "SubPage 10"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Pulling data from the internet."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
