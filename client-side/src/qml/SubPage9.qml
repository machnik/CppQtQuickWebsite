import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "Subpage 9"
    readonly property string subHeaderText: "C++ class is used to implement the counters."
    
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

    Counter {
        id: counter1
    }

    Counter {
        id: counter2
    }

    Label {
        id: countLabel
        text: "Count 1: [" + counter1.count + "]\nCount 2: [" + counter2.count + "]"
        anchors.centerIn: parent
        font.pixelSize: 18
        font.bold: true
    }

    Rectangle {
        width: incrementButton1.width + incrementButton2.width
        anchors.top: countLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20

        Button {
            id: incrementButton1
            text: "Increment Count 1"
            anchors.top: parent.top
            anchors.margins: 15
            onClicked: counter1.count++
        }

        Button {
            id: incrementButton2
            text: "Increment Count 2"
            anchors.top: parent.top
            anchors.left: incrementButton1.right
            anchors.margins: 15
            onClicked: counter2.count++
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
