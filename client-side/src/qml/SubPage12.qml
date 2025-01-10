import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(12)
    readonly property string subHeaderText: "Long-running parallel computations in C++."

    property int regularFontSize: ZoomSettings.regularFontSize

    readonly property list<FakeProcessor> fakeProcessors: [
        FakeProcessor { deciseconds: 32 },
        FakeProcessor { deciseconds: 40 },
        FakeProcessor { deciseconds: 43 },
        FakeProcessor { deciseconds: 58 },
        FakeProcessor { deciseconds: 70 },
        FakeProcessor { deciseconds: 82 },
        FakeProcessor { deciseconds: 86 },
        FakeProcessor { deciseconds: 90 }
    ]

    function statusColor(status) {
        switch (status) {
            case FakeProcessor.Running:
                return "blue";
            case FakeProcessor.Finished:
                return "green";
            case FakeProcessor.Error:
                return "red";
            default:
                return "gray";
        }
    }

    Component.onCompleted: {
        fakeProcessors.forEach(function(processor) {
            processor.start();
        });
    }

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

    Button {
        id: startButton
        text: "START"
        font.pointSize: regularFontSize
        enabled: fakeProcessors.some(function(processor) { return processor.status === FakeProcessor.Idle; })
        anchors.bottom: progressBarsContainer.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            fakeProcessors.forEach(function(processor) {
                processor.start();
            });
        }
    }

    Rectangle {
        id: progressBarsContainer

        width: 600
        height: 200
        color: "transparent"
        border.color: "black"
        border.width: 1
        radius: 8
        anchors.centerIn: parent

        Grid {
            columns: 2
            rows: 4
            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: 8

                ProgressBar {
                    id: progressBar
                    value: fakeProcessors[index].progress / fakeProcessors[index].deciseconds
                    width: 240
                    height: 36
                    background: Rectangle {
                        anchors.fill: progressBar
                        color: Qt.lighter(statusColor(fakeProcessors[index].status))
                        radius: 4
                        border.width: 2
                        border.color: statusColor(fakeProcessors[index].status)
                    }

                    contentItem: Rectangle {
                        id: progressItem
                        anchors.left: progressBar.left
                        anchors.bottom: progressBar.bottom
                        height: progressBar.height
                        width: progressBar.width * progressBar.value
                        radius: 4
                        color: statusColor(fakeProcessors[index].status)
                    }
                }
            }
        }
    }

    Button {
        id: stopButton
        text: "STOP / RESET"
        font.pointSize: regularFontSize
        enabled: fakeProcessors.some(function(processor) { return processor.status !== FakeProcessor.Idle; })
        anchors.top: progressBarsContainer.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            fakeProcessors.forEach(function(processor) {
                processor.stop();
            });
        }
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
