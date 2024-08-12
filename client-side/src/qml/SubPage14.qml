import QtQuick
import QtQuick.Controls

import "qrc:/qml/singletons/"

Rectangle {

    readonly property string headerText: "SubPage 14"
    readonly property string subHeaderText: "2D animation."

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    Item {
        id: animationCanvas
        width: 400; height: 300
        anchors.centerIn: parent

        Rectangle {
            id: blueSky

            anchors {
                left: parent.left;
                top: parent.top;
                right: parent.right;
                bottom: parent.verticalCenter
            }
            gradient: Gradient {
                GradientStop {
                    position: 0.0;
                    color: "#1e1eaa"
                }
                GradientStop {
                    position: 1.0;
                    color: "#3ac4ff"
                }
            }
        }

        Rectangle {
            id: greenGrass

            anchors {
                left: parent.left;
                top: parent.verticalCenter;
                right: parent.right;
                bottom: parent.bottom
            }
            gradient: Gradient {
                GradientStop {
                    position: 0.0;
                    color: "#a0e65a"
                }
                GradientStop {
                    position: 1.0;
                    color: "#00a03d"
                }
            }
        }

        Rectangle {
            id: greyShadow

            color: "#333333"

            anchors.horizontalCenter: parent.horizontalCenter

            y: orangeBall.minHeight + ( orangeBall.height / 1.5 )

            radius: orangeBall.radius * 1.5 
            width: orangeBall.width * 1.25;
            height: orangeBall.height / 1.5

            scale: orangeBall.y / orangeBall.minHeight
        }

        Rectangle {
            id: orangeBall

            color: "#FA8500"

            readonly property int maxHeight: animationCanvas.height * 0.15
            readonly property int minHeight: animationCanvas.height * 0.75

            radius: 20
            width: radius * 2;
            height: radius * 2

            y: minHeight

            anchors.horizontalCenter: parent.horizontalCenter

            SequentialAnimation on y {

                loops: Animation.Infinite

                NumberAnimation {
                    // Raise...
                    from: orangeBall.minHeight;
                    to: orangeBall.maxHeight
                    easing.type: Easing.OutExpo;
                    duration: 500
                }

                NumberAnimation {
                    // ...and fall.
                    from: orangeBall.maxHeight;
                    to: orangeBall.minHeight
                    easing.type: Easing.OutBounce;
                    duration: 3000
                }

                PauseAnimation {
                    // Wait.
                    duration: 500
                }
            }
        }
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
