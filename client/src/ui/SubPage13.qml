import QtQuick
import QtQuick.Controls
import QtWebView

Page {
    id: subPage9

    Label {
        id: headerLabel
        text: "SubPage 13"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        id: titleLabel
        text: "Static webpage with much scrollable text."
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    ScrollView {
        anchors.top: titleLabel.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        WebView {
            anchors.fill: parent
            url: "qrc:/resources/text/lorem_ipsum.html"
        }
    }
}
