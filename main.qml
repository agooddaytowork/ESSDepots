import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtCharts 2.1
import QtQuick.Dialogs 1.1
import "qml"
ApplicationWindow {
    id: stationPage
    visible: true
    width: 1920
    height: 1080
    title: qsTr("Station Page")

    ToolBar{
        id:theToolBar
        width: parent.width
        height: 60
        opacity: mainStackView.depth > 1 ? 1 : 0
        Rectangle {
            color: "transparent"
            anchors.fill: parent
        }

        RowLayout
        {
            anchors.fill: parent
            Rectangle {
                id: backButton
                width: opacity ? 50 : 0
                anchors.left: parent.left
                anchors.leftMargin: 20
                opacity: mainStackView.depth > 2 ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                height: 50
                radius: 4
                color: backmouse.pressed ? "#222" : "transparent"
                Behavior on opacity { NumberAnimation{} }
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/back.png"

                }
                MouseArea {
                    id: backmouse
                    enabled: mainStackView.depth > 2 ? true : false
                    anchors.fill: parent
                    anchors.margins: -10
                    onClicked: mainStackView.pop()
                }
            }

            Rectangle
            {
                id: menuButton
                anchors.left: parent.left
                anchors.leftMargin: 20
                width: 50
                height: 50
                radius: 10
                opacity: mainStackView.depth ==2? 1:0
                color: menumouse.pressed ? "#222" : "transparent"
                Image {
                    id: menuButtonIcon
                    source: "images/menu.png"

                }
                MouseArea
                {   id: menumouse
                    anchors.fill: parent
                    enabled:  mainStackView.depth ==2? true:false
                    onClicked:
                    {
                        menuDrawer.open()
                    }
                }
            }

        }
    }

    StackView{
        id: mainStackView
        anchors.fill: parent

        focus:true
        initialItem: LogInPage
        {
            id: mainPage
        }

        pushEnter: Transition {
            OpacityAnimator {
                target: mainStackView;
                from: 0.8;
                to: 1;
                duration: 500
                running: true
            }
        }
        pushExit: Transition {

        }



        popEnter: Transition {
            OpacityAnimator {
                target: mainStackView;
                from: 0.8;
                to: 1;
                duration: 500
                running: true
            }
        }

        popExit: Transition {

        }
    }

    Drawer{
        id: menuDrawer
        focus: true
        topMargin: 60
        width: Math.min(parent.width, parent.height) / 3 * 2
        height: parent.height
        //        interactive: mainStackView.depth === 1

        ListView {
            id: listView

            focus: true
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    listView.currentIndex = index
                    mainStackView.push(model.source)
                    menuDrawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Stations Settings"; source: "qrc:/qml/StationSettingsPage.qml" }
                ListElement { title: "Gauge Settings"; source: "qrc:/qml/GaugeSettingsPage.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
}

