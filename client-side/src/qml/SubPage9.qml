import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(9)
    readonly property string subHeaderText: "C++ class is used to implement the counters."

    property int bigFontSize: ZoomSettings.bigFontSize

    color: "transparent"

    Counter {
        id: counter1
    }

    Counter {
        id: counter2
    }

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {

        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    Label {
        id: countLabel
        text: "Count 1: [" + counter1.count + "]\nCount 2: [" + counter2.count + "]"
        anchors.centerIn: parent
        font.pixelSize: ZoomSettings.hugeFontSize
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
            font.pointSize: bigFontSize
            anchors.top: parent.top
            anchors.margins: 15
            onClicked: counter1.count++
        }

        Button {
            id: incrementButton2
            text: "Increment Count 2"
            font.pointSize: bigFontSize
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
