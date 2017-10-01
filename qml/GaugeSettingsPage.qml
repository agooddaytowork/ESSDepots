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


            delegate: SwipeDelegate
            {
                width: parent.width
                text: "Gauge: " + GlobalId
                font.pixelSize: 20

                highlighted: ListView.isCurrentItem

                swipe.right: Label {
                    id: deleteLabel
                    text: qsTr("Delete")
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.right: parent.right

                    SwipeDelegate.onClicked: stationList.model.remove(index)

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                    }
                }
                onClicked: {

                    gaugeList.currentIndex = index
                    sGaugeId = GlobalId
                    sDCSAddressSpinBox.value = SDCSAddr
                    thesholdDownPText.myText = thresholdDownP
                    thesholdUpPText.myText = thresholdUpP

                }
            }
        }

    }

    Rectangle
    {
        width: 1520
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        border.color: "black"
        border.width: 1

        Flickable
        {
            id: gaugeSettingsFlickable
            anchors.fill: parent
            anchors.leftMargin: 50
            anchors.rightMargin: 250
            flickableDirection:  Flickable.VerticalFlick
            clip: true

            ColumnLayout
            {
                id: column
                width: parent.width
                height: parent.height
                spacing: 1

                Label{
                    width: parent.width
                    wrapMode: Label.Wrap
                    verticalAlignment: Qt.AlignVCenter
                    text:"Gauge ID: " + sGaugeId
                    font.pixelSize: 25
                }

                Row
                {
                    Label
                    {
                        text: "SDCS Address: "
                        font.pixelSize: 20
                    }

                    SpinBox
                    {
                        id: sDCSAddressSpinBox
                        value: 0
                        from: 0
                        to: 20
                        stepSize: 1
                    }
                }

                FrusTextField{
                    id: thesholdDownPText
                    width: parent.width
                    labelText: "Pressure Threshold Lower Point : "

                    onTextfieldchanged:
                    {
                        if(activeFocus)
                        {
                            keyboardRect.visible = activeFocus
                            var posWithinFlickable = mapToItem(column, 0, height / 2);
                            gaugeSettingsFlickable.contentY = posWithinFlickable.y - gaugeSettingsFlickable.height / 2;
                        }
                    }
                }

                FrusTextField{
                    id: thesholdUpPText
                    width: parent.width
                    labelText: "Pressure Threshold Upper Point : "

                    onTextfieldchanged:
                    {
                        if(activeFocus)
                        {
                            keyboardRect.visible = activeFocus
                            var posWithinFlickable = mapToItem(column, 0, height / 2);
                            gaugeSettingsFlickable.contentY = posWithinFlickable.y - gaugeSettingsFlickable.height / 2;
                        }
                    }
                }

                Button
                {
                    id: updateButton
                    text: "Update"
                    font.pixelSize: 20
                    anchors.horizontalCenter:  parent.horizontalCenter
                    background: Rectangle{
                        implicitHeight: 100
                        implicitWidth: 400
                        radius: 10
                        color: updateButton.pressed ? "#222" : "transparent"
                        border.width: 1
                        border.color: "black"
                    }

                    onPressed:
                    {

                    }
                }

            }
        }
    }

    Rectangle {
        id: keyboardRect
        width: parent.width
        height: parent.height * 0.4
        anchors.bottom: parent.bottom
        color: "transparent"
        visible: false
    }

    InputPanel {
        id: inputPanel
        y: Qt.inputMethod.visible ? (parent.height - inputPanel.height +100 ) : parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        scale: 0.7

    }



}
