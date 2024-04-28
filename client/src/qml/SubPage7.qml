import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers

Page {

    readonly property string headerText: "SubPage 7"
    readonly property string subHeaderText: "3D View"

    Label {
        id: headerLabel
        text: headerText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
    }

    Label {
        text: subHeaderText
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
    }

    Rectangle {

        id: view3dContainer
        anchors.centerIn: parent
        width: 400; height: 400

        color: "black"

        View3D {
            id: view3d
            anchors.fill: parent
            anchors.margins: 3

            environment: SceneEnvironment {
                clearColor: "lightgray"
                backgroundMode: SceneEnvironment.Color
            }

            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0, 200, 300)
                eulerRotation.x: -30
            }

            DirectionalLight {
                eulerRotation.x: -30
                eulerRotation.y: -70
                castsShadow: true
            }

            Model {
                position: Qt.vector3d(0, -200, 0)
                source: "#Cylinder"
                scale: Qt.vector3d(2, 0.1, 1)
                materials: [ DefaultMaterial { diffuseColor: "orange" } ]
                castsShadows: false
                receivesShadows: true
            }

            Model {
                position: Qt.vector3d(0, 150, 0)
                source: "#Sphere"

                materials: [ DefaultMaterial { diffuseColor: "green" } ]

                castsShadows: true
                receivesShadows: false

                SequentialAnimation on y {
                    loops: Animation.Infinite
                    NumberAnimation {
                        duration: 2000
                        to: -150
                        from: 150
                        easing.type: Easing.InQuad
                    }
                    NumberAnimation {
                        duration: 2000
                        to: 150
                        from: -150
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        WasdController {
            controlledObject: camera
        }
    }

    Label {
        id: wasdControlLabel
        text: "W: Forward, S: Backward, A: Left, D: Right, R: Up, F: Down, Hold Mouse: Look Around"
        anchors.top: view3dContainer.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        font.pointSize: 14
        font.bold: true
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
