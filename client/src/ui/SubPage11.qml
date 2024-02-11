import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.Physics
import QtQuick3D.Physics.Helpers

Page {

    readonly property string headerText: "SubPage 11"
    readonly property string subHeaderText: "Qt Quick 3D Physics"

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

    PhysicsWorld {
        scene: view3d.scene
        gravity: Qt.vector3d(0, -9.81, 0)
        enableCCD: true
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

            StaticRigidBody {
                position: Qt.vector3d(0, -200, 0)
                collisionShapes: BoxShape {
                    extents: Qt.vector3d(1000, 1, 1000)
                }
                physicsMaterial: PhysicsMaterial {
                    staticFriction: 0.0
                    dynamicFriction: 0.0
                    restitution: 1.0
                }

                Model {
                    source: "#Cylinder"
                    scale: Qt.vector3d(2, 0.1, 1)
                    materials: [ DefaultMaterial { diffuseColor: "orange" } ]
                    castsShadows: false
                    receivesShadows: true
                }
            }

            DynamicRigidBody {
                position: Qt.vector3d(0, 150, 0)
                collisionShapes: SphereShape {}
                physicsMaterial: PhysicsMaterial {
                    staticFriction: 0.0
                    dynamicFriction: 0.0
                    restitution: 1.0
                }

                Model {
                    source: "#Sphere"
                    materials: [ DefaultMaterial { diffuseColor: "green" } ]
                    castsShadows: true
                    receivesShadows: false
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
