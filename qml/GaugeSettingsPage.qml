import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.VirtualKeyboard 2.1
Item {

    id: gaugeSettingsPage

    property  int sGaugeId

    Rectangle{
        width: 400

        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        border.color: "black"
        border.width: 1
        color: "#cecece"

        ListView
        {
            id: gaugeList
            focus: true
            currentIndex: -1
            model:myGaugeModel
            anchors.fill: parent
            clip: true


            delegate: ItemDelegate
            {
                width: parent.width
                text: "Gauge: " + GlobalId
                font.pixelSize: 20

                highlighted: ListView.isCurrentItem
                onClicked: {

                }
            }
        }

    }

}
