// Without .pragma library, each QML import gets its own module instance and
// therefore its own clickCount; this contrasts with the shared-library page.

var clickCount = 0;

function onClicked(button) {
    clickCount += 1;
    button.counter = clickCount;
}
