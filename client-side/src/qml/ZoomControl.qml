import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Item {
    width: 200
    height: 50

    Slider {
        id: zoomSlider
        from: 0.5
        to: 2.0
        value: ZoomSettings.zoomLevel
        stepSize: 0.1
        anchors.centerIn: parent
        onValueChanged: {
            ZoomSettings.zoomLevel = value
        }
    }

    Label {
        text: "Subpage Text Zoom: " + (zoomSlider.value * 100).toFixed(0) + "%"
        anchors.top: zoomSlider.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
