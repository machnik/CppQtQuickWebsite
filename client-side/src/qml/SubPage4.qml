import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 4"
    readonly property string subHeaderText: "Floating pop-up message."

    Component {
        id: popUpMessageComponent
        PopUpMessage {}
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
            var popUpMessage = popUpMessageComponent.createObject(parent.parent);
            popUpMessage.anchors.centerIn = parent.parent;
            popUpMessage.visible = true;
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
