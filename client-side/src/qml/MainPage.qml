import QtQuick
import QtQuick.Controls
/*
    QtQuick.Layouts enable the use of complex layouts,
    giving much better control over the positioning of elements
    than the basic anchors system, at the cost of being more verbose.
*/
import QtQuick.Layouts

import "qrc:/qml/singletons/"

import CppQtQuickWebsite.CppObjects

Rectangle {
    // Passed in from main.qml so this page does not depend on ids from the
    // ApplicationWindow's scope.
    required property var subPagesComponents
    required property var subPagesDescriptions

    readonly property int pageColumnCount: 5
    readonly property int pageRowCount: Math.ceil(subPagesComponents.length / pageColumnCount)

    color: "transparent"

    Label {
        id: headerLabel
        text: Localization.string("Main Page")
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.hugeFontSize
    }

    Label {
        id: tableOfContentsLabel
        text: Localization.string("Table of Contents")
        anchors.top: headerLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ZoomSettings.bigFontSize
    }

    GridLayout {
        id: pageGrid
        anchors.top: tableOfContentsLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20

        columns: pageColumnCount
        rows: pageRowCount
        columnSpacing: 8
        rowSpacing: 8

        Repeater {
            // Reuse the same component list as the toolbar and menu so all
            // navigation controls stay in sync with the page ordering.
            model: subPagesComponents

            delegate: Button {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 70
                Layout.row: Math.floor(index / pageGrid.columns)
                Layout.column: {
                    const row = Math.floor(index / pageGrid.columns);
                    const remainder = subPagesComponents.length % pageGrid.columns;
                    const itemsInLastRow = remainder === 0 ? pageGrid.columns : remainder;
                    const firstLastRowColumn = Math.floor((pageGrid.columns - itemsInLastRow) / 2);
                    return row === pageGrid.rows - 1
                            ? firstLastRowColumn + index % pageGrid.columns
                            : index % pageGrid.columns;
                }
                text: Localization.string("Page %1").arg(index + 1)
                font.pointSize: ZoomSettings.regularFontSize
                icon.source: "qrc:/resources/icons/pageIcon" + (index + 1) + ".svg"
                ToolTip {
                    text: subPagesDescriptions[index]
                    y: parent.height
                    visible: hovered
                    delay: 0
                }
                onClicked: {
                    // StackView.view is the attached property of the view this
                    // page was pushed onto; it avoids depending on main.qml's ids.
                    const view = StackView.view
                    if (view) {
                        view.push(subPagesComponents[index], StackView.Immediate)
                    }
                }
            }
        }
    }
}
