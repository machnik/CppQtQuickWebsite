import QtQuick.Controls

import "../js/JSCounterBtnCodeSharedImpl.js" as CodeSharedJS

Button {
    property int counter: 0 

    id: counterButton
    text: "[" + counter + "]"
    onClicked: CodeSharedJS.onClicked(counterButton)
}
