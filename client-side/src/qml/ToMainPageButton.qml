import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

/*
    Extends the Button component to provide a custom button
    that navigates back to the main page.
*/

Button {
    text: "To Main Page"
    font.pointSize: ZoomSettings.bigFontSize
    onClicked: {
        stackView.pop(StackView.Immediate)
    }
}
