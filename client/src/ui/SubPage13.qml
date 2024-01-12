import QtQuick
import QtQuick.Controls

Page {
    id: subPage9

    Label {
        id: headerLabel
        text: "SubPage 13"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Static webpage with much scrollable text."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
