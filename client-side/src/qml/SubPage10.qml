import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(10)
    readonly property string subHeaderText: Localization.string("Modifying QML properties using JavaScript or C++.")

    readonly property string textSetJs: Localization.string("Text set using JavaScript.")

    function resetInputField(inputField) {
        inputField.text = textSetJs;
    }

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

    TextField {
        id: textField
        anchors.centerIn: parent
        width: 300
        text: Localization.string("Enter text here")
        font.pointSize: ZoomSettings.bigFontSize
    }

    Button {
        id: buttonSetTextJS
        anchors.top: textField.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.margins: 20
        text: Localization.string("Set text using JavaScript")
        font.pointSize: ZoomSettings.bigFontSize
        onClicked: {
            resetInputField(textField);
        }
    }

    Button {
        id: buttonSetTextCpp
        anchors.top: buttonSetTextJS.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.margins: 10
        text: Localization.string("Set text using C++")
        font.pointSize: ZoomSettings.bigFontSize
        onClicked: {
            Backend.resetInputField(textField);
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
