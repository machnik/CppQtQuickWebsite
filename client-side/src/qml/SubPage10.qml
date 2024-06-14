import QtQuick
import QtQuick.Controls

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 10"
    readonly property string subHeaderText: "Modifying QML properties using JavaScript or C++."

    function resetInputField(inputField) {
        inputField.text = "Text set using JavaScript.";
    }

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
    }

    TextField {
        id: textField
        anchors.centerIn: parent
        width: 300
        text: "Enter text here"
    }

    Button {
        id: buttonSetTextJS
        anchors.top: textField.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.margins: 20
        text: "Set text using JavaScript"
        onClicked: {
            resetInputField(textField);
        }
    }

    Button {
        id: buttonSetTextCpp
        anchors.top: buttonSetTextJS.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.margins: 10
        text: "Set text using C++"
        onClicked: {
            Backend.resetInputField(textField);
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
