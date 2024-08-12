import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    readonly property string headerText: "SubPage 6"
    readonly property string subHeaderText: "JavaScript interpreter."

    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize
    property int smallFontSize: ZoomSettings.smallFontSize

    readonly property string exampleJSCode: "let x = 1;\n" +
        "let y = 2;\n" +
        "let z = x + y;\n" +
        "console.log('The sum of x and y is: ' + z);";

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
                            font.pixelSize: regularFontSize
                            text: exampleJSCode
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
                            font.pointSize: bigFontSize
                            onClicked: eval(javascriptEditor.text);
                        }
                        Button {
                            id: browserJsEngineButton
                            text: "BROWSER JS INTERPRETER"
                            font.pointSize: bigFontSize
                            enabled: !BrowserJS.isAvailable
                            onClicked: {
                                BrowserJS.runJS(javascriptEditor.text);
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
                            text: "Code-Behind JS Implementation"
                            font.bold: true
                            font.pointSize: smallFontSize
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: parent.height / 8
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

                            JSCounterBtnCodeBehind {
                                font.pointSize: bigFontSize
                            }
                            JSCounterBtnCodeBehind {
                                font.pointSize: bigFontSize
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
                            text: "Shared JS Library"
                            font.bold: true
                            font.pointSize: smallFontSize
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: parent.height / 8
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

                            JSCounterBtnCodeShared {
                                font.pointSize: bigFontSize
                            }
                            JSCounterBtnCodeShared {
                                font.pointSize: bigFontSize
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
