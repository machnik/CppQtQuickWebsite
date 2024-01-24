import QtQuick
import QtQuick.Controls

Page {

    readonly property string headerText: "SubPage 12"
    readonly property string subHeaderText: "Benchmark: JavaScript vs. C++ (WebAssembly)."

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
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
