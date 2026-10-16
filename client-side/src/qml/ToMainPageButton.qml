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
        // StackView.view is the attached property of the view this button's
        // page was pushed onto; it avoids depending on main.qml's ids.
        if (StackView.view) {
            StackView.view.pop(StackView.Immediate)
        }
    }
}
