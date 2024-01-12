import QtQuick
import QtQuick.Controls

Page {
    id: subPage8

    Component {
        id: popUpMessageComponent
        PopUpMessage {}
    }

    Label {
        id: headerLabel
        text: "SubPage 8"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Floating pop-up message."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Button {
        text: "Show Message"
        anchors.centerIn: parent
        onClicked: {
            var popUpMessage = popUpMessageComponent.createObject(subPage8);
            popUpMessage.visible = true;
        }
    }
}