import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(11)
    readonly property string subHeaderText: Localization.string("QML ListViews with QML and C++ models.")

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
                    text: Localization.string("Add Item to QML ListView")
                    font.pointSize: regularFontSize
                    Layout.fillWidth: true
                    onClicked: listViewQML.model.append({"text": (Localization.string("QML Item %1")).arg(listViewQML.model.count + 1)})
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 200
                    border.color: "black"
                    border.width: 1
                    color: "transparent"
                    clip: true

                    ListView {
                        id: listViewQML
                        anchors.fill: parent
                        anchors.margins: 4
                        model: ListModel {} // QML model
                        delegate: Rectangle {
                            width: listViewQML.width
                            height: 30
                            color: ListView.isCurrentItem ? "#E91E63" : "transparent"
                            border.color: ListView.isCurrentItem ? "#80E91E63" : "transparent"
                            border.width: ListView.isCurrentItem ? 1 : 0
                            radius: 6
                            
                            Text {
                                text: model.text
                                font.pointSize: regularFontSize
                                color: ListView.isCurrentItem ? "white" : "black"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: listViewQML.currentIndex = index
                            }
                        }
                    }
                }

                Button {
                    id: removeItemFromQMLListButton
                    text: Localization.string("Remove Item from QML ListView")
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
                    text: Localization.string("Add Item to C++ ListView")
                    font.pointSize: regularFontSize
                    Layout.fillWidth: true
                    onClicked: Backend.listModel.addItem((Localization.string("C++ Item %1")).arg(listViewCpp.count + 1))
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 200
                    border.color: "black"
                    border.width: 1
                    color: "transparent"
                    clip: true

                    ListView {
                        id: listViewCpp
                        anchors.fill: parent
                        anchors.margins: 4
                        model: Backend.listModel // C++ model
                        delegate: Rectangle {
                            width: listViewCpp.width
                            height: 30
                            color: ListView.isCurrentItem ? "#E91E63" : "transparent"
                            border.color: ListView.isCurrentItem ? "#80E91E63" : "transparent"
                            border.width: ListView.isCurrentItem ? 1 : 0
                            radius: 6
                            
                            Text { 
                                text: model.display 
                                font.pointSize: regularFontSize
                                color: ListView.isCurrentItem ? "white" : "black"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: listViewCpp.currentIndex = index
                            }
                        }
                    }
                }

                Button {
                    id: removeItemFromCppListButton
                    text: Localization.string("Remove Item from C++ ListView")
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

            for (let i = 1; i <= 3; i++) {
                listViewQML.model.append({
                    "text": (Localization.string("QML Item %1")).arg(i)
                })
            }

            listViewQML.model.append({
                "text": (Localization.string("QML Item %1")).arg(4)
            })
            listViewQML.model.append({
                "text": (Localization.string("QML Item %1")).arg(5)
            })

            Backend.listModel.addItem((Localization.string("C++ Item %1")).arg(4))
            Backend.listModel.addItem((Localization.string("C++ Item %1")).arg(5))
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
