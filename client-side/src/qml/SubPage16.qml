import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.Physics
import QtQuick3D.Physics.Helpers

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {

    readonly property string headerText: (Localization.string("SubPage %1")).arg(16)
    readonly property string subHeaderText: Localization.string("Qt Quick 3D Physics")

    color: "transparent"

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

    PhysicsWorld {
        scene: view3d.scene
        gravity: Qt.vector3d(0, -981, 0)
        typicalSpeed: 200
        enableCCD: true
    }

    Rectangle {

        id: view3dContainer
        anchors.centerIn: parent
        width: 500; height: 320

        color: "black"

        View3D {
            id: view3d

            anchors.fill: parent
            anchors.margins: 3

            Component.onCompleted: {
                view3d.forceActiveFocus();
            }

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
                    restitution: 0.75
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
                    restitution: 0.95
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
        text: Localization.string("W: Forward, S: Backward, A: Left, D: Right, R: Up, F: Down, Hold Mouse: Look Around")
        anchors.top: view3dContainer.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        font.pointSize: ZoomSettings.regularFontSize
        font.bold: true
    }

    ToMainPageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
