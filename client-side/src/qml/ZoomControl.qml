import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

/*
    A custom component that provides a slider to control
    the size of text in the application's UI.
*/

Item {
    width: 200
    height: 50

    Row {
        width: parent.width
        height: parent.height

        Slider {
            id: zoomSlider
            from: 0.5
            to: 2.0
            value: ZoomSettings.zoomLevel
            stepSize: 0.1
            anchors.verticalCenter: parent.verticalCenter
            onValueChanged: {
                ZoomSettings.zoomLevel = value
            }
        }

        Label {
            text: (zoomSlider.value * 100).toFixed(0) + "%"
            font.pointSize: ZoomSettings.regularFontSize
            anchors.verticalCenter: zoomSlider.verticalCenter
            leftPadding: ZoomSettings.bigFontSize
        }
    }
}
