import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.VirtualKeyboard 2.1
Item {
    id: stationSettingsPage

    property int    sGlobalId

    //    property string sStationName
    //    property string sEgunType
    //    property double sthresholdDownP
    //    property double sthresholdUpP
    //    property double sthresholdDownI
    //    property double sthresholdUpI
    //    property int sPumpType
    //    property int sPumpAddr
    //    property int sPumpCh
    //    property int sSDCSAddr
    //    property int sSDCSCh

    Rectangle
    {
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
            id: stationList
            focus: true
            currentIndex: -1
            model:myStationModel
            anchors.fill: parent
            clip: true


            delegate: ItemDelegate
            {
                width: parent.width
                text: "Station: " + stationName
                font.pixelSize: 20

                highlighted: ListView.isCurrentItem
                onClicked: {
                    stationList.currentIndex = index
                    sGlobalId = GlobalId
                    stationname.myText = stationName

                    egunTypeCombobox.myText = egunType
                    pumpTypeComboBox.currentIndex = pumpType
                    pumpAddressSpinBox.value = pumpAddr
                    pumpChannelSpinBox.value = pumpCh

                    sDCSAddressSpinBox.value = SDCSAddr
                    sDCSChannelSpinBox.value = SDCSCh
                    thesholdDownPText.myText = thresholdDownP
                    thesholdDownIText.myText = thresholdDownI
                    thesholdUpIText.myText = thresholdUpI
                    thesholdUpPText.myText = thresholdUpP

                }

            }

            ScrollIndicator.vertical: ScrollIndicator{}

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
            id: stationSettingsFlickable
            anchors.fill: parent
            anchors.leftMargin: 20
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
                    text:"Station ID: " + sGlobalId
                    font.pixelSize: 25
                }

                FrusTextField{
                    id: stationname
                    width: parent.width
                    labelText: "Station Name: "

                    onTextfieldchanged:
                    {
                        if(activeFocus)
                        {
                            keyboardRect.visible = activeFocus
                            var posWithinFlickable = mapToItem(column, 0, height / 2);
                            stationSettingsFlickable.contentY = posWithinFlickable.y - stationSettingsFlickable.height / 2;
                        }
                    }
                }

                Row
                {
                    Label
                    {
                        text: "Egun Type: "
                        font.pixelSize: 20
                    }

                    ComboBox{
                        property  string myText: ""
                        id: egunTypeCombobox
                        currentIndex: 0
                        font.pixelSize: 20
                        width: 300

                        model: ListModel
                        {
                            ListElement{text:"CIP";}
                            ListElement{text:"AMRAY"}
                            ListElement{text:"FEI"}
                            ListElement{text:"ES800 HV1"}
                            ListElement{text:"ES800 HV2"}
                            ListElement{text:"LOGAN"}
                        }

                        onMyTextChanged:
                        {
                            if (myText === "CIP")
                            {
                                currentIndex =0;
                            }
                            if(myText ==="AMRAY")
                            {
                                currentIndex = 1;
                            }
                            if(myText ==="FEI")
                            {
                                currentIndex = 2;
                            }
                            if(myText ==="ES800 HV1")
                            {
                                currentIndex = 3;
                            }
                            if(myText ==="ES800 HV2")
                            {
                                currentIndex = 4;
                            }
                            if(myText ==="LOGAN")
                            {
                                currentIndex = 5;
                            }

                        }
                    }
                }

                Row
                {
                    Label
                    {
                        text: "Ion Pump Controller Type: "
                        font.pixelSize: 20
                    }

                    ComboBox{
                        id: pumpTypeComboBox
                        currentIndex: 0
                        font.pixelSize: 20
                        width: 300
                        model: ListModel
                        {
                            ListElement{text:"UHV2"; }
                            ListElement{text:"UHV4"}
                        }
                    }
                }

                Row
                {
                    Label
                    {
                        text: "Ion Pump Address: "
                        font.pixelSize: 20
                    }

                    SpinBox
                    {
                        id: pumpAddressSpinBox
                        value: 0
                        from: 0
                        to: 32
                        stepSize: 1
                    }
                }

                Row
                {
                    Label
                    {
                        text: "Ion Pump Channel: "
                        font.pixelSize: 20
                    }

                    SpinBox
                    {
                        id: pumpChannelSpinBox
                        value: 1
                        from: 1
                        to: 4
                        stepSize: 1

                    }
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

                Row
                {
                    Label
                    {
                        text: "SDCS Channel: "
                        font.pixelSize: 20
                    }

                    SpinBox
                    {
                        id: sDCSChannelSpinBox
                        value: 1
                        from: 1
                        to: 6
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
                            stationSettingsFlickable.contentY = posWithinFlickable.y - stationSettingsFlickable.height / 2;
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
                            stationSettingsFlickable.contentY = posWithinFlickable.y - stationSettingsFlickable.height / 2;
                        }
                    }
                }

                FrusTextField{
                    id: thesholdDownIText
                    width: parent.width
                    labelText: "Current Threshold Lower Point : "



                    onTextfieldchanged:
                    {
                        if(activeFocus)
                        {
                            keyboardRect.visible = activeFocus
                            var posWithinFlickable = mapToItem(column, 0, height / 2);
                            stationSettingsFlickable.contentY = posWithinFlickable.y - stationSettingsFlickable.height / 2;
                        }
                    }
                }

                FrusTextField{
                    id: thesholdUpIText
                    width: parent.width
                    labelText: "Current Threshold Upper Point : "



                    onTextfieldchanged:
                    {
                        if(activeFocus)
                        {
                            keyboardRect.visible = activeFocus
                            var posWithinFlickable = mapToItem(column, 0, height / 2);
                            stationSettingsFlickable.contentY = posWithinFlickable.y - stationSettingsFlickable.height / 2;
                        }
                    }
                }

                Button
                {
                    id: updateButton
                    text: "Update"
                    font.pixelSize: 20

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

                        console.log("Enter update")

                        LocalDb.updateStationSettings( stationList.currentIndex,sGlobalId, stationname.myText, egunTypeCombobox.currentText, parseFloat(thesholdDownPText.myText)
                                                      , parseFloat(thesholdUpPText.myText), parseFloat(thesholdDownIText.myText), parseFloat(thesholdUpIText.myText)
                                                      , pumpTypeComboBox.currentIndex, pumpAddressSpinBox.value, pumpChannelSpinBox.value
                                                      , sDCSAddressSpinBox.value, sDCSChannelSpinBox.value)
                        console.log("out of update")
                        stationList.model = myStationModel
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
