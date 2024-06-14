import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import CppQtQuickWebsite.CppObjects

Page {

    readonly property string headerText: "SubPage 11"
    readonly property string subHeaderText: "QML ListViews with QML and C++ models."

    ColumnLayout {
        anchors.centerIn: parent
        anchors.fill: parent

        Label {
            id: headerLabel
            text: headerText
            font.pointSize: 15
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: subHeaderText
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 40

            ColumnLayout {

                width: parent.width / 3

                Button {
                    text: "Add Item to QML ListView"
                    Layout.fillWidth: true
                    onClicked: listViewQML.model.append({"text": "QML Item " + (listViewQML.model.count + 1)})
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 200
                    border.color: "black"
                    border.width: 1
                    clip: true

                    ListView {
                        id: listViewQML
                        anchors.fill: parent
                        anchors.margins: 4
                        model: ListModel {
                            ListElement { text: "QML Item 1" }
                            ListElement { text: "QML Item 2" }
                            ListElement { text: "QML Item 3" }
                        }
                        delegate: Text {
                            text: model.text
                            font.pointSize: 10
                        }
                    }
                }

                Button {
                    id: removeItemFromQMLListButton
                    text: "Remove Item from QML ListView"
                    Layout.fillWidth: true
                    onClicked: {
                        if (listViewQML.model.count > 0) {
                            listViewQML.model.remove(0)
                        }
                    }
                }
            }
            
            ColumnLayout {

                width: parent.width / 3

                Button {
                    id: addItemFromCppListButton
                    text: "Add Item to C++ ListView"
                    Layout.fillWidth: true
                    onClicked: Backend.listModel.addItem("C++ Item " + (listViewCpp.count + 1))
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 200
                    border.color: "black"
                    border.width: 1
                    clip: true

                    ListView {
                        id: listViewCpp
                        anchors.fill: parent
                        anchors.margins: 4
                        model: Backend.listModel
                        delegate: Text { 
                            text: model.display 
                            font.pointSize: 10
                        }
                    }
                }

                Button {
                    id: removeItemFromCppListButton
                    text: "Remove Item from C++ ListView"
                    Layout.fillWidth: true
                    onClicked: {
                        if (listViewCpp.count > 0) {
                            Backend.listModel.removeItem(0)
                        }
                    }
                }
            }
        }

        Component.onCompleted: {
            listViewQML.model.append({"text": "QML Item 4"})
            listViewQML.model.append({"text": "QML Item 5"})

            Backend.listModel.addItem("C++ Item 4");
            Backend.listModel.addItem("C++ Item 5");
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
