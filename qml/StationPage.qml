import QtQuick 2.7
import QtCharts 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.VirtualKeyboard 2.1
import CustomControls 1.0

Item {
    id: stationPage
    property bool fruEditEnable: false
    property int    sGlobalId
    property string sStationName
    property string sEgunType
    property string sRFID
    property string sKTPN
    property string sKTSERIALPN
    property string sLPN
    property string sSUPPLIERTESTDATE
    property string sMFGGUNOFFPRESSURE
    property string sPONumber
    property string sDATERECEIVED
    property string sDATESHIPPED
    property bool   sHVON
    property bool sProtectON
    property bool sValveON


    Text {
        id: stationName
        text: sStationName
        font.pixelSize: 20
        font.bold:  true
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle
    {
        width: 200
        height: 80
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 100

        Image {
            id: logoImage
            source: "../images/Kla-logo-purplepng.png"
            scale: 0.5
        }
    }

    ChartView{
        id: chartView
        anchors.topMargin: 70
        anchors.top: parent.top

        anchors.left: parent.left
        width: 1350
        height: 720
        theme: ChartView.ChartThemeDark
        animationOptions:  ChartView.SeriesAnimations
        antialiasing: true
        property  int initialX
        property int  initialY
        property double currentScale

        function toMsecsSinceEpoch(date) {
            var msecs = date.getTime();
            return msecs;
        }
        PinchArea{
            width: parent.width
            height: parent.height

            onPinchStarted: {
                chartView.currentScale = pinch.scale
                chartView.initialX = pinch.center.x
                valueIndicatorLine.visible = true
            }

            onPinchUpdated: {

                // update gauges value to match the valueIndicatorLine

                pressureGauge.value =  pressureSerie.at(parseInt(pressureSerie.count/2)).y
                currentGauge.value  = currentSerie.at(parseInt(currentSerie.count/2)).y
                voltageGauge.value  = voltageSerie.at(parseInt(voltageSerie.count/2)).y
                // console.log("Pressure: " + pressureGauge.value)
                // console.log("Voltage: " + voltageGauge.value)
                // console.log("Current: " + currentGauge.value)
                // console.log("------------------------------------------")
                chartView.scrollLeft(pinch.center.x - pinch.previousCenter.x)
                chartView.scrollUp(pinch.center.y - pinch.previousCenter.y)

                if(Math.abs(pinch.center.x - chartView.initialX) >= 100)
                {
                    LocalDb.updateDataToGraph(pressureSerie,voltageSerie, currentSerie, axisX1.min, axisX1.max, sRFID)
                    chartView.initialX = pinch.center.x
                }

                if(Math.abs(pinch.scale - chartView.currentScale) >= 0.3)
                {

                    chartView.currentScale = pinch.scale
                    if (pinch.scale < 1)
                    {

                        if(Math.abs(chartView.toMsecsSinceEpoch(axisX1.min) - chartView.toMsecsSinceEpoch(axisX1.max)) <(24*60*60*1000))
                        {
                            axisX1.min = new Date(axisX1.min - 1000000*(1/pinch.scale))
                            axisX1.max = new Date(axisX1.max + 1000000*(1/pinch.scale))
                        }
                        else
                        {
                            axisX1.min = new Date(axisX1.max - (24*60*60*1000))
                        }
                    }
                    else
                    {
                        if(Math.abs(chartView.toMsecsSinceEpoch(axisX1.min) - chartView.toMsecsSinceEpoch(axisX1.max)) > (20*60*1000))
                        {
                            axisX1.min = new Date(axisX1.min + 1000000*pinch.scale)
                            axisX1.max = new Date(axisX1.max - 1000000*pinch.scale)
                        }
                        else
                        {
                            axisX1.min = new Date(axisX1.max - (20*60*1000))
                        }

                    }

                    LocalDb.updateDataToGraph(pressureSerie, voltageSerie, currentSerie, axisX1.min, axisX1.max, sRFID)

                }
                // console.log("pinch scale: " + pinch.scale)
            }

            onPinchFinished:
            {
                LocalDb.updateDataToGraph(pressureSerie, voltageSerie, currentSerie, axisX1.min, axisX1.max, sRFID)
                valueIndicatorLine.visible = false

                pressureGauge.value =  pressureSerie.at(pressureSerie.count - 1).y
                currentGauge.value  = currentSerie.at(currentSerie.count - 1).y
                voltageGauge.value  = voltageSerie.at(voltageSerie.count - 1).y
            }
        }


        Rectangle
        {
            id: valueIndicatorLine
            width: 3
            height: 580
            color: "red"
            visible: false
            x:parent.width/2
            y:80
            z:3

        }

        ValueAxis{
            id: axisY2
            min: 0
            max: 8000
            tickCount: 6
            labelFormat: "%d"


        }

        LogValueAxis{
            id: axisY1
            base: 10
            max: 1e-7
            min: 1e-12
            labelFormat: "%.2e"

        }

        DateTimeAxis{
            id: axisX1
            tickCount: 6
            min: new Date(new Date() - 100000)
            max: new Date()
            format: "MMM\dd hh:mm"
        }

        LineSeries{
            id: pressureSerie
            name: "Pressure"
            axisX: axisX1
            axisY: axisY1
            useOpenGL: true
            width: 4
            color: "red"
            style: Qt.DotLine
        }

        LineSeries{
            id: voltageSerie
            name: "Voltage"
            axisX: axisX1
            axisYRight: axisY2
            useOpenGL: true
            width: 4
            color: "orange"
            style: Qt.DotLine

        }

        LineSeries{
            id: currentSerie
            name: "Current"
            axisX: axisX1
            axisY: axisY1
            useOpenGL: true
            width: 4
            color: "cyan"
            style: Qt.DotLine

        }
        // Timer to load graph the first time, only run one time
        Timer
        {
            id:loadGraphFirstTime
            interval:0
            repeat: false
            running:true
            onTriggered:
            {
                LocalDb.initializeDataToGraph(pressureSerie,voltageSerie,currentSerie,axisX1, sRFID)
                pressureGauge.value =  pressureSerie.at(pressureSerie.count - 1).y
                currentGauge.value  = currentSerie.at(currentSerie.count - 1).y
                voltageGauge.value  = voltageSerie.at(voltageSerie.count - 1).y
            }
        }
    }


    // 3 GAUGES for PRESSURE CURRENT AND VOLTAGE

    Rectangle{
        id: gaugeArea
        width: 1330
        height: 280
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        radius: 10
        color: "#cee"

        RowLayout{
            id: gaugeRowLayout
            anchors.fill: parent
            anchors.topMargin: 10

            spacing: 20

            //PRESURE GAUGE
            Rectangle{
                Layout.alignment: Layout.Center
                width: 250
                height: 250
                color: "#1d1d35"
                border.color: "#000000"
                border.width: 3
                radius: 10

                Text {

                    anchors.left: parent.left
                    anchors.top: parent.top

                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    font.pointSize: 13
                    color: "#FAFAFA"
                    text: qsTr("Pressure")
                }

                RadialBar{
                    id: pressureGauge
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: parent.width / 1.4
                    height: width
                    penStyle: Qt.RoundCap
                    progressColor: "#00ffc1"
                    foregroundColor: "#191a2f"
                    dialWidth: 12
                    minValue: 10e-12
                    maxValue: 10e-7
                    value: 0
                    suffixText: "Torr"
                    textFont {
                        family: "Halvetica"
                        italic: false
                        pointSize: 18
                    }
                    textColor: "#00ffc1"

                    onValueChanged:
                    {
                        pressureGauge.update()
                    }
                }
            }

            //CURRENT GAUGE
            Rectangle{
                Layout.alignment: Layout.Center
                width: 250
                height: 250
                color: "#1d1d35"
                border.color: "#000000"
                border.width: 3
                radius: 10

                Text {

                    anchors.left: parent.left
                    anchors.top: parent.top

                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    font.pointSize: 13
                    color: "#FAFAFA"
                    text: qsTr("Current")
                }

                RadialBar{
                    id: currentGauge
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: parent.width / 1.4
                    height: width
                    penStyle: Qt.RoundCap
                    progressColor: "#00ffc1"
                    foregroundColor: "#191a2f"
                    dialWidth: 12
                    minValue: 10e-9
                    maxValue: 10e-5
                    value: 0
                    suffixText: "Ampe"
                    textFont {
                        family: "Halvetica"
                        italic: false
                        pointSize: 18
                    }
                    textColor: "#00ffc1"
                    onValueChanged:
                    {
                        currentGauge.update()
                    }
                }
            }

            //Voltage Gauge
            Rectangle{
                Layout.alignment: Layout.Center
                width: 250
                height: 250
                color: "#1d1d35"
                border.color: "#000000"
                border.width: 3
                radius: 10

                Text {

                    anchors.left: parent.left
                    anchors.top: parent.top

                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    font.pointSize: 13
                    color: "#FAFAFA"
                    text: qsTr("Voltage")
                }

                RadialBar{
                    id: voltageGauge
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: parent.width / 1.4
                    height: width
                    penStyle: Qt.RoundCap
                    progressColor: "#00ffc1"
                    foregroundColor: "#191a2f"
                    dialWidth: 12
                    minValue: 0
                    maxValue: 8000
                    value: 0
                    suffixText: "Volt"
                    textFont {
                        family: "Halvetica"
                        italic: false
                        pointSize: 18
                    }
                    textColor: "#00ffc1"
                    onValueChanged: {
                        voltageGauge.update()
                    }
                }
            }
        }

    }

    // FRU INFO EDIT PANEL
    Flickable{
        id: flickable

        anchors.fill: parent
        anchors.topMargin: 60
        anchors.bottomMargin: keyboardRect.visible ? keyboardRect.height : 100
        anchors.leftMargin: 1400
        anchors.rightMargin: 50
        visible: true
        flickableDirection: Flickable.VerticalFlick


        Rectangle{
            anchors.fill: parent
            color: "transparent"

        }

        ColumnLayout{
            id: column
            width: parent.width
            height: parent.height
            spacing: 10
            Label{
                width: parent.width
                wrapMode: Label.Wrap
                verticalAlignment: Qt.AlignVCenter
                text:"E-source Information"
                font.pixelSize: 30
            }

            FrusTextField{
                id: rfid
                width: parent.width
                labelText: "RFID: "
                myText: sRFID
                enable: fruEditEnable
                onTextfieldchanged:
                {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }
                }

            }

            FrusTextField{
                id: ktpn

                labelText: "KT PN: "
                myText: sKTPN
                enable: fruEditEnable
                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }
            FrusTextField{
                id: ktserialpn

                labelText: "KT Serial PN: "
                myText: sKTSERIALPN
                enable: fruEditEnable
                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }
            FrusTextField{
                id: lpn

                labelText: "LPN: "
                myText: sLPN
                enable: fruEditEnable
                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }
            FrusTextField{
                id: supplierTestDate

                labelText: "Supplier Test Date: "
                myText: sSUPPLIERTESTDATE
                enable: fruEditEnable
                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }
            FrusTextField{
                id: mfgPressureoff
                enable: fruEditEnable
                labelText:"MFG Gun off GV Closed: "
                myText: sMFGGUNOFFPRESSURE

                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }
            FrusTextField{
                id: purchaseOrder

                labelText: "PO: "
                myText:sPONumber
                enable: fruEditEnable
                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }
            FrusTextField{
                id: dateReceive
                enable: fruEditEnable
                labelText: "Date Received: "
                myText:sDATERECEIVED
                onTextfieldchanged: {
                    if(activeFocus)
                    {
                        keyboardRect.visible = activeFocus
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }
                }
            }
            FrusTextField{
                id: dateShipped
                enable: fruEditEnable
                labelText: "Date Shipped: "
                myText: sDATESHIPPED

                onTextfieldchanged: {

                    if(activeFocus)
                    {

                        keyboardRect.visible = activeFocus;
                        var posWithinFlickable = mapToItem(column, 0, height / 2);
                        flickable.contentY = posWithinFlickable.y - flickable.height / 2;
                    }

                }
            }

            Button
            {
                id: updateDatebutton
                text: "Update"
                anchors.horizontalCenter: parent.horizontalCenter
                visible: fruEditEnable
                background: Rectangle{
                    radius: 10
                    implicitWidth: 300
                    implicitHeight: 50
                    border.color: "#333"
                    border.width: 1
                }

                onClicked: {

                    LocalDb.updateStationFruInfo(sGlobalId, ktpn.myText, ktserialpn.myText, lpn.myText, mfgPressureoff.myText, purchaseOrder.myText, supplierTestDate.myText, dateReceive.myText, dateShipped.myText)
                }
            }

            GridLayout{
                visible: !fruEditEnable
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                columnSpacing: 10
                rowSpacing: 10

                Switch{
                    Layout.alignment: Qt.AlignLeft
                    id: hvONswitch
                    text: "HV ON"
                    Layout.fillWidth: true

                }
                Switch{
                    id: protectONswitch
                    Layout.alignment: Qt.AlignLeft
                    text: "Protect ON"
                    Layout.fillWidth: true

                }

                Switch{
                    id: valveONswitch
                    Layout.alignment: Qt.AlignLeft
                    text: "Valve OPEN"

                }

                Button
                {
                    id: shipButton
                    Layout.alignment: Qt.AlignLeft
                    text: "Ship"
                    Layout.fillWidth: true
                }
            }
        }
    }



    // KEYBOARD SECTIONS
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
        y: Qt.inputMethod.visible ? (parent.height - inputPanel.height + 100 ) : parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        scale: 0.7

    }
}
