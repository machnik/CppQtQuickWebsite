import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    readonly property string headerText: "SubPage 5"
    readonly property string subHeaderText: "UI Widget Gallery"

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        spacing: 10

        Label {
            id: headerLabel
            text: headerText
            font.pointSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: subHeaderText
            font.pointSize: 16
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.preferredHeight: 20
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                Layout.fillWidth: true
                spacing: 40

                ColumnLayout {
                    spacing: 20

                    Button {
                        text: "Button"
                    }

                    Button {
                        text: "Checkable Button"
                        checkable: true
                    }

                    CheckBox {
                        text: "CheckBox 1"
                        checked: true
                    }

                    CheckBox {
                        text: "CheckBox 2"
                        checked: false
                    }

                    ComboBox {
                        model: ["ComboBox", "Item 1", "Item 2", "Item 3"]
                    }

                    Dial {
                        from: 0
                        to: 100
                        value: 75
                    }
                }

                ColumnLayout {
                    spacing: 20

                    ProgressBar {
                        from: 0
                        to: 100
                        value: 25
                    }

                    BusyIndicator {
                        running: true
                    }

                    Rectangle {
                        border.width: 1
                        border.color: "black"
                        radius: 4
                        color: "lightblue"

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        GridLayout {
                            columns: 1

                            RadioButton {
                                id: darkBlueRB
                                text: "Dark Blue"
                                checked: true
                                contentItem: Text {
                                    text: darkBlueRB.text
                                    color: "#00008B"
                                    leftPadding: darkBlueRB.indicator.width + darkGreenRB.spacing
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            RadioButton {
                                id: darkRedRB
                                text: "Dark Red"
                                checked: false
                                contentItem: Text {
                                    text: darkRedRB.text
                                    color: "#8B0000"
                                    leftPadding: darkRedRB.indicator.width + darkGreenRB.spacing
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            RadioButton {
                                id: darkGreenRB
                                text: "Dark Green"
                                checked: false
                                contentItem: Text {
                                    text: darkGreenRB.text
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
                    }

                    Switch {
                        text: "Switch"
                    }
                }

                ColumnLayout {
                    spacing: 20

                    TextField {
                        placeholderText: "TextField"
                    }

                    TextArea {
                        placeholderText: "TextArea"
                    }

                    Tumbler {
                        model: ["A", "B", "C", "D", "E", "F", "G", "H"]
                    }
                }
            }
        }

        ToMainPageButton {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
