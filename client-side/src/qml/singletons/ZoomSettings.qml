pragma Singleton

import QtQuick

QtObject {
    // Centralized font sizes make a single zoom value propagate through every
    // page using ordinary QML binding reevaluation.
    property real zoomLevel: 1.0

    property int hugeFontSize: Math.round(18 * zoomLevel)
    property int bigFontSize: Math.round(15 * zoomLevel)
    property int regularFontSize: Math.round(12 * zoomLevel)
    property int smallFontSize: Math.round(9 * zoomLevel)
    property int tinyFontSize: Math.round(6 * zoomLevel)
}
