// This is instantiated only once and that instance is shared between all objects that use it.

.pragma library

var clickCount = 0;

function onClicked(button) {
    clickCount += 1;
    button.counter = clickCount;
}
