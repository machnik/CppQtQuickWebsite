pragma Singleton

import QtQuick

QtObject {
    property real zoomLevel: 1.0

    property int hugeFontSize: Math.round(14 * zoomLevel)
    property int bigFontSize: Math.round(12 * zoomLevel)
    property int regularFontSize: Math.round(10 * zoomLevel)
    property int smallFontSize: Math.round(8 * zoomLevel)
    property int tinyFontSize: Math.round(6 * zoomLevel)
}
