import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {

    Label {
        id: headerLabel
        text: "Main Page"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: "Table of Contents"
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    GridLayout {
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20

        columns: 5
        rows: 4

        Repeater {
            model: 20

            delegate: Button {
                width: 100
                height: 65
                text: "Page " + (index + 1)
                font.pointSize: 16
                onClicked: {
                    stackView.replace(
                        subPagesComponents[index],
                        StackView.PushTransition
                    )
                }
            }
        }
    }
}
