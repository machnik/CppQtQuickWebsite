import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(11)
    readonly property string subHeaderText: "QML ListViews with QML and C++ models."

    property int regularFontSize: ZoomSettings.regularFontSize

    color: "transparent"

    ColumnLayout {
        anchors.centerIn: parent
        anchors.fill: parent

        Label {
            id: headerLabel
            text: headerText
            font.pointSize: ZoomSettings.hugeFontSize
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: subHeaderText
            font.pointSize: ZoomSettings.bigFontSize
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 40

            ColumnLayout {

                width: parent.width / 3

                Button {
                    text: "Add Item to QML ListView"
                    font.pointSize: regularFontSize
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
                            font.pointSize: regularFontSize
                        }
                    }
                }

                Button {
                    id: removeItemFromQMLListButton
                    text: "Remove Item from QML ListView"
                    font.pointSize: regularFontSize
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
                    font.pointSize: regularFontSize
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
                            font.pointSize: regularFontSize
                        }
                    }
                }

                Button {
                    id: removeItemFromCppListButton
                    text: "Remove Item from C++ ListView"
                    font.pointSize: regularFontSize
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
