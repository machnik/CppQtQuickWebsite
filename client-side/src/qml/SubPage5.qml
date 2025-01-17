import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(5)
    readonly property string subHeaderText: Localization.string("Drag and Drop")

    readonly property int drawingBorderWidth: 3

    color: "transparent"

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

    Rectangle {
        id: draggingArea
        width: 550; height: 350
        anchors.centerIn: parent

        color: "lightyellow"
        border.color: "orange"
        border.width: drawingBorderWidth

        Label {
            text: Localization.string("... AND DROP!")
            anchors.centerIn: parent
            font {
                pointSize: ZoomSettings.hugeFontSize
                weight: Font.Bold
            }
            color: "orange"
        }

        Rectangle {
            id: draggableRectangle
            width: 70; height: 70
            color: "yellow"
            border.color: "red"
            border.width: drawingBorderWidth
            x: 100; y: 100

            Label {
                text: Localization.string("DRAG")
                anchors.centerIn: parent
                font {
                    pointSize: ZoomSettings.bigFontSize
                    weight: Font.Bold
                }
                color: "red"
            }

            MouseArea {
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAndYAxis
                onReleased: {
                    // Constrain movement within the dragging area
                    parent.x = Math.max(
                        drawingBorderWidth,
                        Math.min(parent.x, draggingArea.width - parent.width - drawingBorderWidth)
                    );
                    parent.y = Math.max(
                        drawingBorderWidth,
                        Math.min(parent.y, draggingArea.height - parent.height - drawingBorderWidth)
                    );
                }
            }
        }
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
