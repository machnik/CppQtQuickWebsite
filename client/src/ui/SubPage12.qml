import QtQuick
import QtQuick.Controls

Page {
    id: subPage12

    Label {
        id: headerLabel
        text: "SubPage 12"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Benchmark: JavaScript vs. C++ (WebAssembly)."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Label {
        text: "..."
        anchors.centerIn: parent
    }
}
