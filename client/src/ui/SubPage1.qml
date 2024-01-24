import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppClasses

Page {

    readonly property string headerText: "Subpage 1"
    readonly property string subHeaderText: "C++ class is used to implement the counters."
    
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

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
