import QtQuick
import QtQuick.Controls

Button {
    text: "To Main Page"
    font.pointSize: 12
    onClicked: {
        stackView.pop(StackView.PopTransition)
    }
}
