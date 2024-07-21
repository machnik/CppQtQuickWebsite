import QtQuick.Controls

import "../js/JSCounterBtnCodeBehindImpl.js" as CodeBehindJS

Button {
    property int counter: 0 

    id: counterButton
    text: "[" + counter + "]"
    onClicked: CodeBehindJS.onClicked(counterButton)
}
