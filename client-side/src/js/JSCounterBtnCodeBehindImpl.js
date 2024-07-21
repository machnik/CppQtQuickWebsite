var clickCount = 0;

function onClicked(button) {
    clickCount += 1;
    button.counter = clickCount;
}
