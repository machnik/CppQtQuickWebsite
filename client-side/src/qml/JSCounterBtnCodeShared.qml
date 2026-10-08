import QtQuick.Controls

import "../js/JSCounterBtnCodeSharedImpl.js" as CodeSharedJS

Button {
    // The imported .pragma library module is shared, so its module-level
    // clickCount is common even though each button has its own counter property.
    property int counter: 0 

    id: counterButton
    text: "[" + counter + "]"
    onClicked: CodeSharedJS.onClicked(counterButton)
}
