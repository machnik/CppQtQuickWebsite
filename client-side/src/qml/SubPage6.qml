import QtQuick
import QtQuick.Controls

Page {
// https://doc.qt.io/qt-6/qtqml-javascript-resources.html
    readonly property string headerText: "SubPage 6"
    readonly property string subHeaderText: "JavaScript interpreter."

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

    Label {
        text: "..."
        anchors.centerIn: parent
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
