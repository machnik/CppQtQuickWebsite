import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

/*
    Extends the Button component to provide a custom button
    that navigates back to the main page.
*/

Button {
    text: Localization.string("To Main Page")
    font.pointSize: ZoomSettings.bigFontSize
    onClicked: {
        stackView.pop(StackView.Immediate)
    }
}
