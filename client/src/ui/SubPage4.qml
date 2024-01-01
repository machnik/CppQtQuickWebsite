import QtQuick
import QtQuick.Controls

import CppQtQuickWebpage.Backend

Page {
    id: subPage4

    function resetInputField(inputField) {
        inputField.text = "Text set using JavaScript.";
    }

    Label {
        id: headerLabel
        text: "SubPage 4"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Modifying QML properties using JavaScript or C++."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
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
        text: "Set text using JavaScript"
        onClicked: {
            resetInputField(textField);
        }
    }

    Button {
        id: buttonSetTextCpp
        anchors.top: buttonSetTextJS.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        text: "Set text using C++"
        onClicked: {
            Backend.resetInputField(textField);
        }
    }
}
