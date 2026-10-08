// .pragma library makes this module's state shared by all importers, so clicks
// on separate buttons increment the same counter.

.pragma library

var clickCount = 0;

function onClicked(button) {
    clickCount += 1;
    button.counter = clickCount;
}
