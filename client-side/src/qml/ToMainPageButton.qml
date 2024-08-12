import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Button {
    text: "To Main Page"
    font.pointSize: ZoomSettings.bigFontSize
    onClicked: {
        stackView.pop(StackView.Immediate)
    }
}
