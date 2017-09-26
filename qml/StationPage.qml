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
        anchors.topMargin: 50
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
            }

            onPinchUpdated: {
                chartView.scrollLeft(pinch.center.x - pinch.previousCenter.x)
                chartView.scrollUp(pinch.center.y - pinch.previousCenter.y)

                if(Math.abs(pinch.center.x - chartView.initialX) >= 100)
                {
                    LocalDb.updateDataToGraph(pressureSerie, axisX1.min, axisX1.max, sRFID)
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

                    LocalDb.updateDataToGraph(pressureSerie, axisX1.min, axisX1.max, sRFID)

                }
                console.log("pinch scale: " + pinch.scale)
            }

            onPinchFinished:
            {
                LocalDb.updateDataToGraph(pressureSerie, axisX1.min, axisX1.max, sRFID)
            }
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

        Timer
        {
            id:loadGraphFirstTime
            interval:0
            repeat: false
            running:true
            onTriggered:
            {
                LocalDb.initializeDataToGraph(pressureSerie,axisX1, sRFID)

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
                    value: 1e-8
                    suffixText: "Torr"
                    textFont {
                        family: "Halvetica"
                        italic: false
                        pointSize: 18
                    }
                    textColor: "#00ffc1"
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
                    minValue: 10e-12
                    maxValue: 10e-7
                    value: 1e-7
                    suffixText: "Ampe"
                    textFont {
                        family: "Halvetica"
                        italic: false
                        pointSize: 18
                    }
                    textColor: "#00ffc1"
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
                    value: 5000
                    suffixText: "Volt"
                    textFont {
                        family: "Halvetica"
                        italic: false
                        pointSize: 18
                    }
                    textColor: "#00ffc1"
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
        visible: !fruEditEnable
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
