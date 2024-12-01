import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: "SubPage 22"
    readonly property string subHeaderText: "Using QSysInfo in QML."

    SystemInformation {
        id: sysInfo
    }

    function displayField(value) {
        return value === "" ? "---" : value;
    }

    color: "transparent"

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

    Column {
        anchors.centerIn: parent
        spacing: 10

        Label {
            text: "System Information:"
            font.pointSize: ZoomSettings.regularFontSize
            font.bold: true
        }

        Label {
            text: "- Boot Unique ID: " + displayField(sysInfo.bootUniqueId)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Build ABI: " + displayField(sysInfo.buildAbi)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Build CPU Architecture: " + displayField(sysInfo.buildCpuArchitecture)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Current CPU Architecture: " + displayField(sysInfo.currentCpuArchitecture)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Host Name: " + displayField(sysInfo.machineHostName)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Kernel Type: " + displayField(sysInfo.kernelType)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Kernel Version: " + displayField(sysInfo.kernelVersion)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Machine Unique ID: " + displayField(sysInfo.machineUniqueId)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Product Name: " + displayField(sysInfo.prettyProductName)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Product Type: " + displayField(sysInfo.productType)
            font.pointSize: ZoomSettings.smallFontSize
        }

        Label {
            text: "- Product Version: " + displayField(sysInfo.productVersion)
            font.pointSize: ZoomSettings.smallFontSize
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
