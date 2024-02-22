import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

    RowLayout {
        id: benchmarkLayout
        anchors.centerIn: parent

        Rectangle {
            border.width: 2
            width: 400; height: 400
            anchors.margins: 20
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                Label {
                    text: "C++"
                    font.pointSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: "Decimal places:"
                        font.pointSize: 12
                        anchors.margins: 10
                    }
                    SpinBox {
                        value: 100; from: 10; to: 100000; stepSize: 10
                        anchors.margins: 10
                    }
                    Button {
                        text: "GO!"
                        anchors.margins: 10
                        onClicked: {
                            //let decimalPlaces = cppDecimalPlacesSpinBox.value
                            cppPiTextArea.text = "Calculating..."
                        }
                    }
                }
                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: "Last Time:"
                        font.pointSize: 16
                        anchors.margins: 10
                    }
                    Label {
                        text: "0.00 s"
                        font.pointSize: 16
                        anchors.margins: 10
                    }
                }
                Rectangle {
                    width: parent.width - 20; height: 150
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.width: 2
                    border.color: "black"
                    color: "darkblue"
                    TextArea {
                        id: cppPiTextArea
                        text: "3.14"
                        anchors.fill: parent
                        readOnly: true
                        width: parent.width
                        font.pointSize: 13
                        font.family: "Courier"
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        ColumnLayout {
            anchors.margins: 20
            Label {
                text: "VS."
                font.pointSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                id: rButton
                width: 50; height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 20
                color: "red"
                border.width: 2
                MouseArea {
                    id: rMouseArea
                    anchors.fill: parent
                    onClicked: {
                        console.log("R clicked")
                    }
                }
            }
            Rectangle {
                id: gButton
                width: 50; height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 20
                color: "green"
                border.width: 2
                MouseArea {
                    id: gMouseArea
                    anchors.fill: parent
                    onClicked: {
                        console.log("G clicked")
                    }
                }
            }
            Rectangle {
                id: bButton
                width: 50; height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 20
                color: "blue"
                border.width: 2
                MouseArea {
                    id: bMouseArea
                    anchors.fill: parent
                    onClicked: {
                        console.log("B clicked")
                    }
                }
            }

            ToolTip {
                text: "This is a tooltip"
                background: Rectangle {
                    radius: 10
                    color: "lightgrey"
                }
                visible: rMouseArea.containsMouse || gMouseArea.containsMouse || bMouseArea.containsMouse
                delay: 1000
                x: rMouseArea.containsMouse ? rMouseArea.mouseX : (gMouseArea.containsMouse ? gMouseArea.mouseX : bMouseArea.mouseX)
                y: rMouseArea.containsMouse ? rMouseArea.mouseY : (gMouseArea.containsMouse ? gMouseArea.mouseY : bMouseArea.mouseY)
            }
        }

        Rectangle {
            border.width: 2
            width: 400; height: 400
            anchors.margins: 20
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                Label {
                    text: "JavaScript (Qt Engine)"
                    font.pointSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: "Decimal places:"
                        font.pointSize: 12
                        anchors.margins: 10
                    }
                    SpinBox {
                        value: 100; from: 10; to: 100000; stepSize: 10
                        anchors.margins: 10
                    }
                    Button {
                        text: "GO!"
                        anchors.margins: 10
                        onClicked: {
                            //let decimalPlaces = cppDecimalPlacesSpinBox.value
                            jsQtPiTextArea.text = "Calculating..."
                        }
                    }
                }
                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: "Last Time:"
                        font.pointSize: 16
                        anchors.margins: 10
                    }
                    Label {
                        text: "0.00 s"
                        font.pointSize: 16
                        anchors.margins: 10
                    }
                }
                Rectangle {
                    width: parent.width - 20; height: 150
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.width: 2
                    border.color: "black"
                    color: "darkblue"
                    TextArea {
                        id: jsQtPiTextArea
                        text: "3.14"
                        anchors.fill: parent
                        readOnly: true
                        width: parent.width
                        font.pointSize: 13
                        font.family: "Courier"
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        Rectangle {
            border.width: 2
            width: 400; height: 400
            anchors.margins: 20
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                Label {
                    text: "JavaScript (Browser)"
                    font.pointSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: "Decimal places:"
                        font.pointSize: 12
                        anchors.margins: 10
                    }
                    SpinBox {
                        value: 100; from: 10; to: 100000; stepSize: 10
                        anchors.margins: 10
                    }
                    Button {
                        text: "GO!"
                        anchors.margins: 10
                        onClicked: {
                            //let decimalPlaces = cppDecimalPlacesSpinBox.value
                            jsBrowserPiTextArea.text = "Calculating..."
                        }
                    }
                }

                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: "Last Time:"
                        font.pointSize: 16
                        anchors.margins: 10
                    }
                    Label {
                        text: "0.00 s"
                        font.pointSize: 16
                        anchors.margins: 10
                    }
                }

                Rectangle {
                    width: parent.width - 20; height: 150
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.width: 2
                    border.color: "black"
                    color: "darkblue"
                    TextArea {
                        id: jsBrowserPiTextArea
                        text: "3.14"
                        anchors.fill: parent
                        readOnly: true
                        width: parent.width
                        font.pointSize: 13
                        font.family: "Courier"
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
