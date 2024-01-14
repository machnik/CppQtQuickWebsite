import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import CppQtQuickWebpage.Backend 

Page {
    id: subPage3

    ColumnLayout {
        anchors.centerIn: parent
        anchors.fill: parent

        Label {
            id: headerLabel
            text: "SubPage 3"
            font.pointSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "QML ListViews with QML and C++ backends."
            font.pointSize: 16
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 40

            ColumnLayout {

                ListView {
                    id: listViewQML
                    width: 200; height: 300
                    model: ListModel {
                        ListElement { text: "QML Item 1" }
                        ListElement { text: "QML Item 2" }
                        ListElement { text: "QML Item 3" }
                    }
                    delegate: Text {
                        text: model.text
                    }
                }

                Button {
                    text: "Add Item to QML ListView"
                    width: listViewQML.width
                    onClicked: listViewQML.model.append({"text": "QML Item " + (listViewQML.model.count + 1)})
                }

                Button {
                    text: "Remove Item from QML ListView"
                    width: listViewQML.width
                    onClicked: {
                        if (listViewQML.model.count > 0) {
                            listViewQML.model.remove(0)
                        }
                    }
                }
            }
            
            ColumnLayout {
                ListView {
                    id: listViewCpp
                    width: 200; height: 300
                    model: Backend.listModel
                    delegate: Text { text: model.display }
                }

                Button {
                    id: addItemFromCppListButton
                    text: "Add Item to C++ ListView"
                    width: listViewCpp.width
                    onClicked: Backend.listModel.addItem("C++ Item " + (listViewCpp.count + 1))
                }

                Button {
                    id: removeItemFromCppListButton
                    text: "Remove Item from C++ ListView"
                    width: listViewCpp.width
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
}
