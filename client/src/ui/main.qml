import QtQuick
import QtQuick.Controls

ApplicationWindow {

    visible: true
    width: 800
    height: 600
    title: "CppQtQuickWebsite"

    Component {
        id: "mainPage"
        MainPage { }
    }

    Component {
        id: "subPage1"
        SubPage1 { }
    }

    Component {
        id: "subPage2"
        SubPage2 { }
    }

    Component {
        id: "subPage3"
        SubPage3 { }
    }

    Component {
        id: "subPage4"
        SubPage4 { }
    }

    Component {
        id: "subPage5"
        SubPage5 { }
    }

    Component {
        id: "subPage6"
        SubPage6 { }
    }

    Component {
        id: "subPage7"
        SubPage7 { }
    }

    Component {
        id: "subPage8"
        SubPage8 { }
    }

    Component {
        id: "subPage9"
        SubPage9 { }
    }

    Component {
        id: "subPage10"
        SubPage10 { }
    }

    Component {
        id: "subPage11"
        SubPage11 { }
    }

    Component {
        id: "subPage12"
        SubPage12 { }
    }

    Component {
        id: "subPage13"
        SubPage13 { }
    }

    Component {
        id: "subPage14"
        SubPage14 { }
    }

    Component {
        id: "subPage15"
        SubPage15 { }
    }

    Component {
        id: "subPage16"
        SubPage16 { }
    }

    Component {
        id: "subPage17"
        SubPage17 { }
    }
    
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
                onTriggered: stackView.replace(mainPage)
            }
            MenuItem {
                text: "SubPage 1"
                onTriggered: stackView.replace(subPage1)
            }
            MenuItem {
                text: "SubPage 2"
                onTriggered: stackView.replace(subPage2)
            }
            MenuItem {
                text: "SubPage 3"
                onTriggered: stackView.replace(subPage3)
            }
            MenuItem {
                text: "SubPage 4"
                onTriggered: stackView.replace(subPage4)
            }
            MenuItem {
                text: "SubPage 5"
                onTriggered: stackView.replace(subPage5)
            }
            MenuItem {
                text: "SubPage 6"
                onTriggered: stackView.replace(subPage6)
            }

            MenuItem {
                text: "SubPage 7"
                onTriggered: stackView.replace(subPage7)
            }

            MenuItem {
                text: "SubPage 8"
                onTriggered: stackView.replace(subPage8)
            }

            MenuItem {
                text: "SubPage 9"
                onTriggered: stackView.replace(subPage9)
            }

            MenuItem {
                text: "SubPage 10"
                onTriggered: stackView.replace(subPage10)
            }

            MenuItem {
                text: "SubPage 11"
                onTriggered: stackView.replace(subPage11)
            }

            MenuItem {
                text: "SubPage 12"
                onTriggered: stackView.replace(subPage12)
            }

            MenuItem {
                text: "SubPage 13"
                onTriggered: stackView.replace(subPage13)
            }

            MenuItem {
                text: "SubPage 14"
                onTriggered: stackView.replace(subPage14)
            }

            MenuItem {
                text: "SubPage 15"
                onTriggered: stackView.replace(subPage15)
            }

            MenuItem {
                text: "SubPage 16"
                onTriggered: stackView.replace(subPage16)
            }

            MenuItem {
                text: "SubPage 17"
                onTriggered: stackView.replace(subPage17)
            }
        }
    }
}
