import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    readonly property string headerText: "SubPage 6"
    readonly property string subHeaderText: "JavaScript interpreter."

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

    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.75
        height: parent.height * 0.75
        border.color: "black"
        border.width: 2

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4

            Rectangle {
                width: parent.width / 1.5
                height: parent.height
                border.width: 2
                color: "darkblue"

                ColumnLayout {
                    anchors.fill: parent

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        TextArea {
                            id: javascriptEditor
                            font.family: "DejaVu Sans Mono"
                            font.pixelSize: 10
                            text: "alert(\"Hello World\");"
                            readOnly: false
                            wrapMode: TextArea.NoWrap
                            anchors.fill: parent
                            color: "white"
                        }
                    }

                    RowLayout {
                        id: runButtonsRow
                        Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                        Layout.margins: 32
                        Button {
                            id: qtJsEngineButton
                            text: "QT JS ENGINE"
                            onClicked: {
                                console.log("Running JavaScript code with Qt's JavaScript engine.");
                            }
                        }
                        Button {
                            id: browserJsEngineButton
                            text: "BROWSER JS INTERPRETER"
                            onClicked: {
                                console.log("Running JavaScript code with the browser's JavaScript interpreter.");
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width / 3 - 8
                height: parent.height
                border.width: 2
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 4

                    Rectangle {
                        Layout.preferredWidth: parent.width - 8
                        Layout.preferredHeight: parent.height / 2 - 10
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        Layout.topMargin: 4
                        Layout.bottomMargin: 2
                        color: "lightyellow"
                        border.width: 2

                        Label {
                            text: "Code-Behind Implementation Resource"
                            font.bold: true
                            font.pointSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: parent.height / 8
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

                            Button {
                                text: "0"
                            }
                            Button {
                                text: "0"
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: parent.width - 8
                        Layout.preferredHeight: parent.height / 2 - 10
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        Layout.topMargin: 2
                        Layout.bottomMargin: 4
                        color: "lightgreen"
                        border.width: 2

                        Label {
                            text: "Shared JavaScript Resource"
                            font.bold: true
                            font.pointSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: parent.height / 8
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

                            Button {
                                text: "0"
                            }
                            Button {
                                text: "0"
                            }
                        }
                    }
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
