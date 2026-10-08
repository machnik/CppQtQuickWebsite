import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    id: root

    readonly property string headerText: Localization.string("SubPage %1").arg(26)
    readonly property string subHeaderText: Localization.string("Real CPU-bound work on a C++ worker thread.")
    readonly property bool showWasmThreadNotice: BrowserJS.browserEnvironment

    color: "transparent"

    ThreadedProcessor {
        id: threadedProcessor
    }

    function workerStateText() {
        switch (threadedProcessor.state) {
        case ThreadedProcessor.Running:
            return Localization.string("Thread running")
        case ThreadedProcessor.Cancelling:
            return Localization.string("Cancelling thread...")
        case ThreadedProcessor.Completed:
            return Localization.string("Thread completed")
        case ThreadedProcessor.Cancelled:
            return Localization.string("Thread cancelled")
        default:
            return Localization.string("Thread idle")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 10

        Label {
            text: headerText
            font.pointSize: ZoomSettings.hugeFontSize
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: subHeaderText
            font.pointSize: ZoomSettings.bigFontSize
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            visible: showWasmThreadNotice
            text: Localization.string("WebAssembly needs Qt's wasm_multithread build and cross-origin isolation to use C++ threads. Otherwise, try this page in a native build.")
            font.pointSize: ZoomSettings.regularFontSize
            color: "#8B0000"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.maximumWidth: 760
            Layout.alignment: Qt.AlignHCenter
            implicitHeight: threadControls.implicitHeight + 36

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#f0f0f0" }
                GradientStop { position: 1.0; color: "#b0b0b0" }
            }
            border.color: "#7a7a7a"
            border.width: 1.5
            radius: 18

            ColumnLayout {
                id: threadControls
                anchors.fill: parent
                anchors.margins: 18
                spacing: 10

                Label {
                    text: Localization.string("Counts primes up to %1 on a dedicated worker thread. The interface remains responsive while the CPU-bound loop runs outside the GUI thread.")
                          .arg(limitSpinBox.value)
                    font.pointSize: ZoomSettings.regularFontSize
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    Label {
                        text: Localization.string("Search limit:")
                        font.pointSize: ZoomSettings.regularFontSize
                    }

                    SpinBox {
                        id: limitSpinBox
                        from: 2
                        to: threadedProcessor.maximumCandidateLimit
                        value: 10_000_000
                        stepSize: 1_000_000
                        Layout.preferredWidth: 220
                        editable: true
                        validator: IntValidator {
                            bottom: limitSpinBox.from
                            top: limitSpinBox.to
                        }
                        textFromValue: function(value, locale) {
                            return value.toString()
                        }
                        valueFromText: function(text, locale) {
                            return parseInt(text, 10)
                        }
                        enabled: !threadedProcessor.busy
                        font.pointSize: ZoomSettings.regularFontSize
                    }

                    Label {
                        text: Localization.string("Maximum: %1").arg(threadedProcessor.maximumCandidateLimit)
                        font.pointSize: ZoomSettings.smallFontSize
                    }
                }

                Label {
                    text: Localization.string("Larger limits can take much longer. You can cancel the worker at any time.")
                    font.pointSize: ZoomSettings.smallFontSize
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Label {
                    text: Localization.string("Progress and results return through queued signals. Cancellation is cooperative and uses an atomic flag checked by the worker.")
                    font.pointSize: ZoomSettings.regularFontSize
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Label {
                    text: Localization.string("Worker state: %1").arg(workerStateText())
                    font.pointSize: ZoomSettings.bigFontSize
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                ProgressBar {
                    from: 0
                    to: 100
                    value: threadedProcessor.progress
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: Localization.string("Progress: %1%").arg(threadedProcessor.progress)
                        font.pointSize: ZoomSettings.regularFontSize
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: Localization.string("Primes found: %1").arg(threadedProcessor.primesFound)
                        font.pointSize: ZoomSettings.regularFontSize
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    Button {
                        text: Localization.string("START")
                        font.pointSize: ZoomSettings.regularFontSize
                        enabled: !threadedProcessor.busy && threadedProcessor.threadingSupported
                        onClicked: threadedProcessor.start(limitSpinBox.value)
                    }

                    Button {
                        text: Localization.string("CANCEL")
                        font.pointSize: ZoomSettings.regularFontSize
                        enabled: threadedProcessor.state === ThreadedProcessor.Running
                        onClicked: threadedProcessor.cancel()
                    }

                    Button {
                        text: Localization.string("STOP / RESET")
                        font.pointSize: ZoomSettings.regularFontSize
                        enabled: !threadedProcessor.busy
                        onClicked: threadedProcessor.reset()
                    }
                }
            }
        }

        Label {
            text: Localization.string("Compare this with page 12: QTimer callbacks share the GUI event loop and do not run CPU work in parallel.")
            font.pointSize: ZoomSettings.regularFontSize
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
        }

        ToMainPageButton {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
