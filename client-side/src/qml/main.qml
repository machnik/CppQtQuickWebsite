import QtQuick
import QtQuick.Controls
import QtQml

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

ApplicationWindow {

    visible: true
    width: Screen.width; height: Screen.height
    flags: Qt.Window | Qt.FramelessWindowHint

    background: Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#A0A0A0" }
            GradientStop { position: 1.0; color: "#202020" }
        }
    }

    Component {
        id: mainPage
        MainPage {}
    }

    Component {
        id: exampleWindowComponent
        ExampleWindow {}
    }

    property list<Component> subPagesComponents: [
        Component { id: subPage1; SubPage1 {}},
        Component { id: subPage2; SubPage2 {}},
        Component { id: subPage3; SubPage3 {}},
        Component { id: subPage4; SubPage4 {}},
        Component { id: subPage5; SubPage5 {}},
        Component { id: subPage6; SubPage6 {}},
        Component { id: subPage7; SubPage7 {}},
        Component { id: subPage8; SubPage8 {}},
        Component { id: subPage9; SubPage9 {}},
        Component { id: subPage10; SubPage10 {}},
        Component { id: subPage11; SubPage11 {}},
        Component { id: subPage12; SubPage12 {}},
        Component { id: subPage13; SubPage13 {}},
        Component { id: subPage14; SubPage14 {}},
        Component { id: subPage15; SubPage15 {}},
        Component { id: subPage16; SubPage16 {}},
        Component { id: subPage17; SubPage17 {}},
        Component { id: subPage18; SubPage18 {}},
        Component { id: subPage19; SubPage19 {}},
        Component { id: subPage20; SubPage20 {}},
        Component { id: subPage21; SubPage21 {}},
        Component { id: subPage22; SubPage22 {}},
        Component { id: subPage23; SubPage23 {}},
        Component { id: subPage24; SubPage24 {}}
    ]

    readonly property var subPagesDescriptions: SubPagesDescriptions.descriptions(Localization.currentLanguage)

    function switchLanguage(language) {
        Localization.setLanguage(language)
        Backend.resetBackend()
        Backend.reloadQML()
    }

    Rectangle {
        id: stackViewBorder
        anchors.fill: parent
        anchors.margins: 60
        border.color: "black"
        border.width: 2
        radius: 8

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#F5F5F5" }
            GradientStop { position: 1.0; color: "#B0B0B0" }
        }

        StackView {
            id: stackView
            anchors.centerIn: parent
            width: parent.width - 60
            height: parent.height - 60
            initialItem: mainPage
        }
    }

    menuBar: MenuBar {
        Menu {
            title: Localization.string("MENU")
            MenuItem {
                text: Localization.string("Main Page")
                font.pointSize: ZoomSettings.regularFontSize
                onTriggered: {
                    stackView.pop(StackView.Immediate)
                }
            }
            Repeater {
                model: subPagesComponents
                MenuItem {
                    text: Localization.string("Page %1").arg(index + 1)
                    font.pointSize: ZoomSettings.regularFontSize
                    onTriggered: {
                        stackView.pop(StackView.Immediate)
                        stackView.push(modelData, StackView.Immediate)
                    }
                }
            }
            MenuItem {
                text: Localization.string("Exit")
                font.pointSize: ZoomSettings.regularFontSize
                onTriggered: {
                    Qt.quit();
                }
            }
        }
        Menu {
            title: Localization.string("LANGUAGE")
            MenuItem {
                text: Localization.string("Restart in English")
                font.pointSize: ZoomSettings.regularFontSize
                onTriggered: {
                    switchLanguage(Locale.English)
                }
            }
            MenuItem {
                text: Localization.string("Restart in Polish")
                font.pointSize: ZoomSettings.regularFontSize
                onTriggered: {
                    switchLanguage(Locale.Polish)
                }
            }
            MenuItem {
                text: Localization.string("Restart in German")
                font.pointSize: ZoomSettings.regularFontSize
                onTriggered: {
                    switchLanguage(Locale.German)
                }
            }
        }
    }

    ToolBar {
        id: toolBar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40

        Row {
            ToolButton {
                icon.source: "qrc:/resources/icons/homePageIcon.svg"
                onClicked: {
                    stackView.pop(StackView, StackView.Immediate)
                }
                ToolTip {
                    text: Localization.string("Navigate to the main page.")
                    visible: parent.hovered
                    delay: 0
                }
            }

            Item {
                width: 25
                height: parent.height
            }

            ToolButton {
                icon.source: "qrc:/resources/icons/addWindowIcon.svg"
                onClicked: {
                    var exampleWindow = exampleWindowComponent.createObject(
                        Overlay.overlay, { // Slight randomization of the window's position:
                            x: Screen.width / 2 - (1 + Math.random()) * 100,
                            y: Screen.height / 2 - (1+ Math.random()) * 100
                        }
                    );
                    exampleWindow.visible = true;
                }
                ToolTip {
                    text: Localization.string("Open a new non-modal window.")
                    visible: parent.hovered
                    delay: 0
                }
            }

            ToolButton {
                icon.source: "qrc:/resources/icons/gitHubIcon.svg"
                onClicked: {
                    Qt.openUrlExternally("https://github.com/machnik/CppQtQuickWebsite")
                }
                ToolTip {
                    text: Localization.string("Visit the project's GitHub repository.")
                    visible: parent.hovered
                    delay: 0
                }
            }

            Item {
                width: 25
                height: parent.height
            }

            Repeater {
                model: subPagesComponents
                ToolButton {
                    icon.source: "qrc:/resources/icons/pageIcon" + (index + 1) + ".svg"
                    onClicked: {
                        stackView.pop(StackView.Immediate)
                        stackView.push(modelData, StackView.Immediate)
                    }
                    ToolTip {
                        text: subPagesDescriptions[index]
                        visible: parent.hovered
                        delay: 0
                    }
                }
            }

            Item {
                width: zoomControl.zoomLabelWidth / 2
                height: parent.height
            }

            ZoomControl {
                id: zoomControl
            }

            Item {
                width: zoomControl.zoomLabelWidth / 2
                height: parent.height
            }
        }
    }

    Label {
        text: "v" + Backend.version()
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        font.pointSize: ZoomSettings.smallFontSize
        color: "#FFFFFF"
    }
}
