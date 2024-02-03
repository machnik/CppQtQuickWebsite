import QtQuick
import QtQuick.Controls
Page {

    readonly property string headerText: "SubPage 9"
    readonly property string subHeaderText: "Drag and Drop"

    readonly property int drawingBorderWidth: 3

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

    Rectangle {
        id: draggingArea
        width: 550; height: 350
        anchors.centerIn: parent

        color: "lightyellow"
        border.color: "orange"
        border.width: drawingBorderWidth

        Label {
            text: "... AND DROP!"
            anchors.centerIn: parent
            font {
                pointSize: 15
                weight: Font.Bold
            }
            color: "orange"
        }

        Rectangle {
            id: draggableRectangle
            width: 50; height: 50
            color: "yellow"
            border.color: "red"
            border.width: drawingBorderWidth
            x: 100; y: 100

            Label {
                text: "DRAG"
                anchors.centerIn: parent
                font {
                    pointSize: 10
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
