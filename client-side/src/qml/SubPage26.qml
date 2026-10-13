import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    id: root

    readonly property string headerText: Localization.string("SubPage %1").arg(26)
    readonly property string subHeaderText: Localization.string("Real CPU-bound work on C++ worker threads.")
    readonly property bool showWasmThreadNotice: BrowserJS.browserEnvironment
    property int lastRecordedState: ThreadedProcessor.Idle

    color: "transparent"

    ThreadedProcessor {
        id: threadedProcessor

        onStateChanged: {
            // stateChanged is also emitted when the last thread exits, so
            // record each completed run only once.
            if (state === ThreadedProcessor.Completed && root.lastRecordedState !== ThreadedProcessor.Completed) {
                runHistory.insert(0, {
                    "threads": threadCount,
                    "limit": candidateCount + 1,
                    "seconds": formatSeconds(elapsedMs)
                })
                if (runHistory.count > 5) {
                    runHistory.remove(5)
                }
            }
            root.lastRecordedState = state
        }
    }

    ListModel {
        id: runHistory
    }

    function formatSeconds(milliseconds) {
        return (milliseconds / 1000).toFixed(2)
    }

    function workerStateText() {
        switch (threadedProcessor.state) {
        case ThreadedProcessor.Running:
            return Localization.string("Threads running")
        case ThreadedProcessor.Cancelling:
            return Localization.string("Cancelling threads...")
        case ThreadedProcessor.Completed:
            return Localization.string("Threads completed")
        case ThreadedProcessor.Cancelled:
            return Localization.string("Threads cancelled")
        default:
            return Localization.string("Threads idle")
        }
    }

    // Text typed into an editable SpinBox is only committed on Enter or focus
    // loss, so commit it explicitly before starting.
    function commitSpinBoxText(spinBox) {
        spinBox.value = spinBox.valueFromText(spinBox.contentItem.text, spinBox.locale)
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

        // The controls grow with the thread count, so they scroll on small windows.
        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: 10

                Label {
                    visible: showWasmThreadNotice
                    text: threadedProcessor.threadingSupported
                          ? Localization.string("Threads in WebAssembly also require cross-origin isolation (COOP/COEP headers or the threading helper) and must not exceed the build's PTHREAD_POOL_SIZE (see the README). Otherwise, START may not work.")
                          : Localization.string("WebAssembly needs Qt's wasm_multithread build and cross-origin isolation to use C++ threads. Otherwise, try this page in a native build.")
                    font.pointSize: ZoomSettings.regularFontSize
                    color: threadedProcessor.threadingSupported ? palette.windowText : "#8B0000"
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
                            text: Localization.string("Counts primes up to %1 on the selected number of worker threads. The interface remains responsive while the CPU-bound loops run outside the GUI thread.")
                                  .arg(limitSpinBox.value)
                            font.pointSize: ZoomSettings.regularFontSize
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        GridLayout {
                            columns: 3
                            columnSpacing: 10
                            rowSpacing: 6
                            Layout.alignment: Qt.AlignHCenter

                            Label {
                                text: Localization.string("Search limit:")
                                font.pointSize: ZoomSettings.regularFontSize
                            }

                            SpinBox {
                                id: limitSpinBox
                                from: 2
                                to: threadedProcessor.maximumCandidateLimit
                                value: 10000000
                                stepSize: 1000000
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
                                    const parsed = parseInt(text, 10)
                                    return isNaN(parsed) ? limitSpinBox.value : parsed
                                }
                                enabled: !threadedProcessor.busy
                                font.pointSize: ZoomSettings.regularFontSize
                            }

                            Label {
                                text: Localization.string("Maximum: %1").arg(threadedProcessor.maximumCandidateLimit)
                                font.pointSize: ZoomSettings.smallFontSize
                            }

                            Label {
                                text: Localization.string("Threads:")
                                font.pointSize: ZoomSettings.regularFontSize
                            }

                            SpinBox {
                                id: threadsSpinBox
                                from: 1
                                to: threadedProcessor.maximumThreadCount
                                value: threadedProcessor.idealThreadCount
                                Layout.preferredWidth: 220
                                enabled: !threadedProcessor.busy
                                font.pointSize: ZoomSettings.regularFontSize
                            }

                            Label {
                                text: Localization.string("Detected: %1").arg(threadedProcessor.idealThreadCount)
                                font.pointSize: ZoomSettings.smallFontSize
                            }
                        }

                        Label {
                            text: Localization.string("Larger limits can take much longer. You can cancel the workers at any time.")
                            font.pointSize: ZoomSettings.smallFontSize
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        Label {
                            text: Localization.string("Threads claim blocks of numbers from a shared atomic counter, so all of them stay busy. Progress and results return through queued signals, and cancellation is cooperative with an atomic flag. Run the same limit with 1 thread and with several, then compare the times.")
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
                                text: Localization.string("Elapsed: %1 s").arg(formatSeconds(threadedProcessor.elapsedMs))
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

                        // One row per thread of the current run. The bar shows
                        // the thread's share of an even split of all numbers.
                        Repeater {
                            model: threadedProcessor.threadCount

                            RowLayout {
                                required property int index
                                readonly property int processed: threadedProcessor.workerProcessed[index] ?? 0
                                readonly property int primes: threadedProcessor.workerPrimes[index] ?? 0

                                Layout.fillWidth: true
                                spacing: 10

                                Label {
                                    text: Localization.string("Thread %1").arg(index + 1)
                                    font.pointSize: ZoomSettings.smallFontSize
                                    Layout.preferredWidth: 90
                                }

                                ProgressBar {
                                    from: 0
                                    to: 1
                                    value: threadedProcessor.candidateCount > 0
                                           ? Math.min(1, processed * threadedProcessor.threadCount / threadedProcessor.candidateCount)
                                           : 0
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: Localization.string("Primes found: %1").arg(primes)
                                    font.pointSize: ZoomSettings.smallFontSize
                                    horizontalAlignment: Text.AlignRight
                                    Layout.preferredWidth: 170
                                }
                            }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10

                            Button {
                                text: Localization.string("START")
                                font.pointSize: ZoomSettings.regularFontSize
                                enabled: !threadedProcessor.busy && threadedProcessor.threadingSupported
                                onClicked: {
                                    commitSpinBoxText(limitSpinBox)
                                    threadedProcessor.start(limitSpinBox.value, threadsSpinBox.value)
                                }
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
                                onClicked: {
                                    threadedProcessor.reset()
                                    runHistory.clear()
                                    root.lastRecordedState = ThreadedProcessor.Idle
                                }
                            }
                        }

                        Label {
                            visible: runHistory.count > 0
                            text: Localization.string("Previous runs")
                            font.pointSize: ZoomSettings.regularFontSize
                            font.bold: true
                        }

                        Repeater {
                            model: runHistory

                            Label {
                                required property int threads
                                required property int limit
                                required property string seconds

                                text: Localization.string("Threads: %1, limit: %2, time: %3 s")
                                      .arg(threads).arg(limit).arg(seconds)
                                font.pointSize: ZoomSettings.smallFontSize
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
            }
        }

        ToMainPageButton {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
