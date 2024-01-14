import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppClasses

Page {
    id: subPage1

    Label {
        id: headerLabel
        text: "SubPage 1"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "C++ class is used to implement the counters."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Counter {
        id: counter1
    }

    Counter {
        id: counter2
    }

    Label {
        text: "Count 1: " + counter1.count + ", Count 2: " + counter2.count
        anchors.centerIn: parent
        font.pixelSize: 40
    }

    Button {
        text: "Increment Count 1"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        onClicked: counter1.count++
    }

    Button {
        text: "Increment Count 2"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: counter2.count++
    }
}
