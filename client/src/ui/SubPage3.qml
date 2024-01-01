import QtQuick
import QtQuick.Controls

Page {
    id: subPage3

    Label {
        id: headerLabel
        text: "SubPage 3"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "A QML ListView with a C++ backend."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    ListView {
        id: listView
        model: backend.listModel
        delegate: Text { text: modelData }
        anchors.centerIn: parent
    }

    Button {
        text: "Add Item"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        onClicked: backend.listModel.addItem("Item " + (listView.count + 1))
    }

    Button {
        text: "Remove Item"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: backend.listModel.removeItem(listView.currentIndex)
    }

    Component.onCompleted: {
        backend.listModel.addItem("Item 1");
        backend.listModel.addItem("Item 2");
        backend.listModel.addItem("Item 3");
    }
}
