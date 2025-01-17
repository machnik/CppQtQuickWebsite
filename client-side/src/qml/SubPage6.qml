import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(6)
    readonly property string subHeaderText: Localization.string("JavaScript interpreter.")

    property int hugeFontSize: ZoomSettings.hugeFontSize
    property int bigFontSize: ZoomSettings.bigFontSize
    property int regularFontSize: ZoomSettings.regularFontSize
    property int smallFontSize: ZoomSettings.smallFontSize

    readonly property string exampleJSCode: "1 + 1";

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
                color: "lightgray"

                ColumnLayout {
                    anchors.fill: parent

                    Label {
                        id: jsInterpreterLabel
                        text: Localization.string("JavaScript Interpreter")
                        font.bold: true
                        font.pointSize: hugeFontSize
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: parent.height / 8
                    }

                    TextField {
                        id: jsExpressionEditor
                        text: exampleJSCode
                        font.pointSize: regularFontSize
                        width: parent.width - 20
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: parent.height / 8
                    }

                    Label {
                        id: resultLabel
                        text: Localization.string("Result: ")
                        font.pointSize: bigFontSize
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: parent.height / 8
                    }

                    Label {
                        id: resultValueLabel
                        text: "-"
                        font.pointSize: hugeFontSize
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.topMargin: parent.height / 16
                    }

                    RowLayout {
                        id: runButtonsRow
                        Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                        Layout.margins: 32
                        Button {
                            id: qtJsEngineButton
                            text: Localization.string("QT JS ENGINE")
                            font.pointSize: bigFontSize
                            onClicked: {
                                var result = eval(jsExpressionEditor.text);
                                resultValueLabel.text = result;
                            }
                        }
                        Button {
                            id: browserJsEngineButton
                            text: Localization.string("BROWSER JS INTERPRETER")
                            font.pointSize: bigFontSize
                            onClicked: {
                                if (BrowserJS.browserEnvironment) {
                                    var result = BrowserJS.runJS(jsExpressionEditor.text);
                                    resultValueLabel.text = result;
                                } else {
                                    resultValueLabel.text = "Browser JS interpreter is not available.";
                                }
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
                            text: Localization.string("Code-Behind JS Implementation\n(separate instances)")
                            font.bold: true
                            font.pointSize: smallFontSize
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 8
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

                    // Horizontal line:
                    Rectangle {
                        Layout.preferredWidth: parent.width - 8
                        Layout.preferredHeight: 2
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        color: "black"
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
                            text: Localization.string("Shared JS Library\n(one common instance)")
                            font.bold: true
                            font.pointSize: smallFontSize
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 8
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
