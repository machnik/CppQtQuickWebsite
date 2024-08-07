import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

ApplicationWindow {

    visible: true
    width: Screen.width; height: Screen.height
    flags: Qt.Window | Qt.FramelessWindowHint

    Component {
        id: mainPage
        MainPage {}
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
        Component { id: subPage20; SubPage20 {}}
    ]

    Rectangle {
        id: stackViewBorder
        anchors.fill: parent
        anchors.margins: 70
        border.color: "black"
        border.width: 2
        radius: 8

        StackView {
            id: stackView
            anchors.centerIn: parent
            width: parent.width - 16
            height: parent.height - 16
            initialItem: mainPage
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "MENU"
            MenuItem {
                text: "Main Page"
                font.pointSize: ZoomSettings.regularFontSize
                onTriggered: {
                    stackView.pop(StackView.PopTransition)
                }
            }
            Repeater {
                model: subPagesComponents
                MenuItem {
                    text: "Page " + (index + 1)
                    font.pointSize: ZoomSettings.regularFontSize
                    onTriggered: {
                        stackView.pop()
                        stackView.push(modelData, StackView.PushTransition)
                    }
                }
            }
            MenuItem {
                text: "Exit"
                onTriggered: {
                    Qt.quit();
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
                    stackView.pop(StackView.PopTransition)
                }
            }

            Rectangle {
                width: 25
                height: parent.height
            }

            Repeater {
                model: subPagesComponents
                ToolButton {
                    icon.source: "qrc:/resources/icons/pageIcon" + (index + 1) + ".svg"
                    onClicked: {
                        stackView.pop()
                        stackView.push(modelData, StackView.PushTransition)
                    }
                }
            }

            Rectangle {
                width: 25
                height: parent.height
            }

            ZoomControl {}
        }
    }
}
