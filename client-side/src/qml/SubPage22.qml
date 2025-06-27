import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(22)
    readonly property string subHeaderText: Localization.string("Using QSysInfo in QML.")

    property color textColor: "black"

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
            text: Localization.string("System Information:")
            font.pointSize: ZoomSettings.regularFontSize
            font.bold: true
            color: textColor
        }

        Label {
            text: Localization.string("- Boot Unique ID: ") + displayField(sysInfo.bootUniqueId)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Build ABI: ") + displayField(sysInfo.buildAbi)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Build CPU Architecture: ") + displayField(sysInfo.buildCpuArchitecture)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Current CPU Architecture: ") + displayField(sysInfo.currentCpuArchitecture)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Host Name: ") + displayField(sysInfo.machineHostName)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Kernel Type: ") + displayField(sysInfo.kernelType)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Kernel Version: ") + displayField(sysInfo.kernelVersion)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Machine Unique ID: ") + displayField(sysInfo.machineUniqueId)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Product Name: ") + displayField(sysInfo.prettyProductName)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Product Type: ") + displayField(sysInfo.productType)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }

        Label {
            text: Localization.string("- Product Version: ") + displayField(sysInfo.productVersion)
            font.pointSize: ZoomSettings.smallFontSize
            color: textColor
        }
    }
    
    Button {
        text: Localization.string("Select Font Color")
        font.pointSize: ZoomSettings.regularFontSize
        icon.source: "qrc:/resources/icons/colorPalette.svg"
        anchors.bottom: toMainPageButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        onClicked: colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        selectedColor: textColor
        onAccepted: textColor = colorDialog.selectedColor
    }

    ToMainPageButton {
        id: toMainPageButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
