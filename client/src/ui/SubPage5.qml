import QtQuick
import QtQuick.Controls

Page {
    id: subPage5

    Label {
        id: headerLabel
        text: "SubPage 5"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "UI Widget Gallery"
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
