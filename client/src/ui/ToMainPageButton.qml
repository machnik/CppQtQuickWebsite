import QtQuick
import QtQuick.Controls

Button {
    text: "To Main Page"
    onClicked: {
        stackView.push(mainPage)
    }
}
