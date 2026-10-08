import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(4)
    readonly property string subHeaderText: Localization.string("Floating message dialog.")

    color: "transparent"

    Component {
        // A Component stores a reusable object definition; createObject()
        // below creates a fresh dialog only when the user asks for one.
        id: dialogMessageComponent
        MessageDialog {}
    }

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

    Button {
        text: Localization.string("Show Message")
        font.pointSize: ZoomSettings.bigFontSize
        anchors.centerIn: parent
        onClicked: {
            var dialogMessage = dialogMessageComponent.createObject(parent.parent);
            if (!dialogMessage) {
                return;
            }
            dialogMessage.anchors.centerIn = parent.parent;
            dialogMessage.open();
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
