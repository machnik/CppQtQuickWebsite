import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

Page {

    Label {
        id: headerLabel
        text: "Main Page"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        text: "Table of Contents"
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    GridLayout {
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20

        columns: 5
        rows: 4

        Repeater {
            model: 20

            delegate: Button {
                width: 100
                height: 65
                text: "Page " + (index + 1)
                font.pointSize: ZoomSettings.regularFontSize
                onClicked: {
                    stackView.push(subPagesComponents[index], StackView.PushTransition)
                }
            }
        }
    }
}
