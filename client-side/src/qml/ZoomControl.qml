import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

/*
    A custom component that provides a slider to control
    the size of text in the application's UI.
*/

Item {
    width: 200
    height: 50

    property alias zoomLabelWidth: zoomLabel.width

    Row {
        width: parent.width
        height: parent.height

        Slider {
            id: zoomSlider
            from: 0.75
            to: 1.5
            value: ZoomSettings.zoomLevel
            stepSize: 0.01
            anchors.verticalCenter: parent.verticalCenter
            onValueChanged: {
                ZoomSettings.zoomLevel = value
            }
            ToolTip {
                text: Localization.string("Adjust the size of the text in the application's UI.")
                visible: parent.hovered
                delay: 0
            }
        }

        Label {
            id: zoomLabel
            text: (zoomSlider.value * 100).toFixed(0) + "%"
            font.pointSize: ZoomSettings.regularFontSize
            anchors.verticalCenter: zoomSlider.verticalCenter
            leftPadding: ZoomSettings.bigFontSize
        }
    }
}
