import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

MessageDialog {
    id: popUpDialog
    title: "Pop-up Window"
    text: "Lorem ipsum!"
    informativeText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    buttons: MessageDialog.Ok | MessageDialog.Cancel
    onAccepted: console.log("Accepted")
    onRejected: console.log("Rejected")
}
