import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 4"
    readonly property string subHeaderText: "Floating message dialog."

    Component {
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
        text: "Show Message"
        font.pointSize: ZoomSettings.bigFontSize
        anchors.centerIn: parent
        onClicked: {
            var dialogMessage = dialogMessageComponent.createObject(parent.parent);
            dialogMessage.anchors.centerIn = parent.parent;
            dialogMessage.visible = true;
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
