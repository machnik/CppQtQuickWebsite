import QtQuick
import QtQuick.Controls
/*
    QtQuick.Layouts enable the use of complex layouts,
    giving much better control over the positioning of elements
    than the basic anchors system, at the cost of being more verbose.
*/
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    color: "transparent"

    Label {
        id: headerLabel
        text: Localization.string("Main Page")
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        text: Localization.string("Table of Contents")
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    GridLayout {
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20

        columns: 6
        rows: 4
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: subPagesComponents

            delegate: Button {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 65
                text: Localization.string("Page %1").arg(index + 1)
                font.pointSize: ZoomSettings.regularFontSize
                ToolTip {
                    text: subPagesDescriptions[index]
                    y: parent.height
                    visible: hovered
                    delay: 0
                }
                onClicked: {
                    stackView.push(subPagesComponents[index], StackView.Immediate)
                }
            }
        }
    }
}
