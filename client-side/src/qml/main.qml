import QtQuick
import QtQuick.Controls

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
        
    StackView {
        id: stackView
        initialItem: mainPage
        anchors.fill: parent
        anchors.margins: 50
    }

    menuBar: MenuBar {
        Menu {
            title: "Website Menu"
            MenuItem {
                text: "Main Page"
                onTriggered: {
                    stackView.pop(StackView.PopTransition)
                }
            }
            Repeater {
                model: subPagesComponents
                MenuItem {
                    text: "Page " + (index + 1)
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
}
