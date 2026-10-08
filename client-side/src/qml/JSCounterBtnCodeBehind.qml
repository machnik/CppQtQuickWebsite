import QtQuick.Controls

import "../js/JSCounterBtnCodeBehindImpl.js" as CodeBehindJS

Button {
    // This ordinary imported JS module has per-component state. Compare it
    // with the .pragma library version used by the shared-counter example.
    property int counter: 0 

    id: counterButton
    text: "[" + counter + "]"
    onClicked: CodeBehindJS.onClicked(counterButton)
}
