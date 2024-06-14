import QtQuick
import QtQuick.Controls

Page {

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
        font.pointSize: 15
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
    }

    Button {
        text: "Show Message"
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
