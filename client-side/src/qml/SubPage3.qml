import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    readonly property string headerText: (Localization.string("SubPage %1")).arg(3)
    readonly property string subHeaderText: Localization.string("UI Widget Gallery")

    property int regularFontSize: ZoomSettings.regularFontSize

    color: "transparent"

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        spacing: 10

        Label {
            id: headerLabel
            text: headerText
            font.pointSize: ZoomSettings.hugeFontSize
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: subHeaderText
            font.pointSize: ZoomSettings.bigFontSize
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.preferredHeight: 20
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            anchors.margins: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 40

                ColumnLayout {
                    spacing: 20

                    Button {
                        text: Localization.string("Button")
                        font.pointSize: regularFontSize
                    }

                    Button {
                        text: Localization.string("Checkable Button")
                        font.pointSize: regularFontSize
                        checkable: true
                    }

                    CheckBox {
                        text: (Localization.string("CheckBox %1")).arg(1)
                        font.pointSize: regularFontSize
                        checked: true
                    }

                    CheckBox {
                        text: (Localization.string("CheckBox %1")).arg(2)
                        font.pointSize: regularFontSize
                        checked: false
                    }

                    ComboBox {
                        model: [(Localization.string("Item %1")).arg(1), (Localization.string("Item %1")).arg(2), (Localization.string("Item %1")).arg(3)]
                        font.pointSize: regularFontSize
                        delegate: ItemDelegate {
                            text: modelData
                            font.pointSize: regularFontSize
                        }
                    }

                    Dial {
                        from: 0
                        to: 100
                        value: 75
                    }
                }

                ColumnLayout {
                    spacing: 20

                    BusyIndicator {
                        running: true
                    }

                    ProgressBar {
                        from: 0
                        to: 100
                        value: 25
                    }

                    Rectangle {
                        border.width: 3
                        border.color: darkBlueRB.checked ? "darkblue" : darkRedRB.checked ? "darkred" : "darkgreen"
                        radius: 10

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: darkBlueRB.checked ? "lightblue" : darkRedRB.checked ? "pink" : "lightgreen" }
                            GradientStop { position: 0.5; color: darkBlueRB.checked ? "#87CEEB" : darkRedRB.checked ? "#FFB6C1" : "#98FB98" }
                            GradientStop { position: 1.0; color: darkBlueRB.checked ? "#4682B4" : darkRedRB.checked ? "#FF6347" : "#32CD32" }
                        }

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {

                            RadioButton {
                                id: darkBlueRB
                                text: Localization.string("Blue")
                                checked: true
                                contentItem: Text {
                                    text: darkBlueRB.text
                                    font.pointSize: regularFontSize
                                    color: "#00008B"
                                    leftPadding: darkBlueRB.indicator.width + darkGreenRB.spacing
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            RadioButton {
                                id: darkRedRB
                                text: Localization.string("Red")
                                checked: false
                                contentItem: Text {
                                    text: darkRedRB.text
                                    font.pointSize: regularFontSize
                                    color: "#8B0000"
                                    leftPadding: darkRedRB.indicator.width + darkGreenRB.spacing
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            RadioButton {
                                id: darkGreenRB
                                text: Localization.string("Green")
                                checked: false
                                contentItem: Text {
                                    text: darkGreenRB.text
                                    font.pointSize: regularFontSize
                                    color: "#006400"
                                    leftPadding: darkGreenRB.indicator.width + darkGreenRB.spacing
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }

                    Slider {
                        from: 0
                        to: 100
                        value: 35
                    }

                    SpinBox {
                        from: 0
                        to: 100
                        value: 80
                        font.pointSize: regularFontSize
                    }

                    Switch {
                        text: Localization.string("Switch")
                        font.pointSize: regularFontSize
                    }
                }

                ColumnLayout {
                    spacing: 20

                    TextField {
                        placeholderText: Localization.string("Text Field")
                        font.pointSize: regularFontSize
                    }

                    TextArea {
                        placeholderText: Localization.string("Text Area")
                        font.pointSize: regularFontSize
                    }

                    Tumbler {
                        model: ["A", "B", "C", "D", "E", "F", "G", "H"]
                        font.pointSize: regularFontSize
                    }
                }
            }
        }

        ToMainPageButton {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
