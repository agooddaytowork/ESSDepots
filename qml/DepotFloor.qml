import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtCharts 2.1
import QtQuick.Dialogs 1.1
import CustomControls 1.0

Item {
    id: mainPage

    property bool  depotEditEnable: false

    // MENU BUTTON
    Rectangle
    {
        id: menu2Button
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 20
        width: 50
        height: 50
        color: menu2Mouse.pressed? "#222" : "transparent"
        Image {
            id: menu2Icon
            source: "../images/menu2.png"
        }

        MouseArea{
            id: menu2Mouse
            anchors.fill: parent
            onClicked:
            {
                menu2Menu.open()
            }
        }

        Menu{
            id: menu2Menu
            y:menu2Button.height + 10


            MenuItem
            {
                id: editModeMenuItem
                text: "Edit Mode"
                contentItem: Text{
                    text: parent.text
                    font.pixelSize: 20
                }
                onClicked: {
                    mainPage.depotEditEnable = true
                    operatingModeMenuItem.visible = true
                    operatingModeMenuItem.height = 30
                    editModeMenuItem.visible = false
                    editModeMenuItem.height  = 0

                    for(var i =0; i < stationMap.count; i++)
                    {
                        stationMap.itemAt(i).currentStationState = stationMap.itemAt(i).state
                        stationMap.itemAt(i).state = "StationEnteredEditMode"
                    }

                    toolDrawer.visible = true
                }
            }

            MenuItem{
                id: operatingModeMenuItem
                text: "Operating Mode"
                visible: false
                height: 0
                contentItem: Text{
                    text: parent.text
                    font.pixelSize: 20
                }
                onClicked: {
                    mainPage.depotEditEnable = false
                    operatingModeMenuItem.visible = false
                    operatingModeMenuItem.height = 0
                    editModeMenuItem.visible = true
                    editModeMenuItem.height  = 30

                    for(var i =0; i < stationMap.count; i++)
                    {
                        stationMap.itemAt(i).state = stationMap.itemAt(i).currentStationState
                    }
                    toolDrawer.visible = false
                }
            }

            MenuItem
            {
                text: "Lock"

                onClicked:
                {
                    mainStackView.push(Qt.resolvedUrl("LogInPage.qml"))
                }
                contentItem: Text{
                    text: parent.text
                    font.pixelSize: 20
                }
            }
            MenuItem
            {
                text: "Exit"
                contentItem: Text{
                    text: parent.text
                    font.pixelSize: 20

                }

                onClicked:
                {
                    Qt.quit()
                }
            }

        }

    }

    // DEPOT NAME LABEL
    Label
    {
        text: "UDC"
        font.bold: true
        font.pixelSize: 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 80

    }

    // GAUGE AREA
    Rectangle
    {
        id: gaugeArea
        color: "transparent"
        width: 250
        height: 600
        radius: 10
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 300
        anchors.leftMargin: 50

        ListView{
            id: gaugeListView
            anchors.fill: parent
            model: myGaugeModel
            anchors.leftMargin: 25
            spacing: 10

            delegate: Rectangle{
                Layout.alignment: Layout.Center
                width: 200
                height: 200
                color: "#1d1d35"
                border.color: "#000000"
                border.width: 3
                radius: 10

                Text {
                    id: name
                    anchors.left: parent.left
                    anchors.top: parent.top

                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    font.pointSize: 13
                    color: "#FAFAFA"
                    text: qsTr("Gauge: G") + GlobalId
                }

                RadialBar{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: parent.width / 1.4
                    height: width
                    penStyle: Qt.RoundCap
                    progressColor: "#00ffc1"
                    foregroundColor: "#191a2f"
                    dialWidth: 12
                    minValue: 0.001
                    maxValue: 1
                    value: gaugeCurrentValue
                    suffixText: "Torr"
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


    // STATISTIC AREA
    Rectangle
    {
        id: statisticArea
        color: "transparent"
        width: 250
        height: 800
        radius: 10
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 150
        anchors.rightMargin: 50
        z:2
    }


    //LOGO
    Rectangle
    {
        width: 300
        height: 86
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 0
        anchors.rightMargin: 0

        Image {
            id: logo
            scale: 0.5
            source: "../images/Kla-logo-purplepng.png"
            anchors.fill: parent
            fillMode: Image.Stretch
        }

    }

    // DEPOT FLOOR
    Rectangle
    {
        id:depotFloor
        width: 1200
        height: 800
        color: "#cecece"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 150
        anchors.leftMargin: (1920-(depotFloor.width))/2

        radius: 10

        Rectangle{
            id: selectRect
            x:0
            y:0
            width: 0
            height: 0
            color: "black"
            z:3
            opacity: 0.5
            property int initX
            property int initY

        }
        MouseArea
        {
            id: multipleSelectMouseArea
            anchors.fill: parent
            visible: depotEditEnable

            property bool isPressed: false
            state: "selectStations"

            states:[
                State{
                    name:"selectStations"
                },
                State{
                    name:"moveStations"
                }

            ]

            onPressed:
            {

                if(multipleSelectMouseArea.state ==="selectStations")
                {
                    selectRect.x = multipleSelectMouseArea.mouseX
                    selectRect.y  = multipleSelectMouseArea.mouseY
                    selectRect.initX = multipleSelectMouseArea.mouseX
                    selectRect.initY = multipleSelectMouseArea.mouseY
                    multipleSelectMouseArea.isPressed = true

                    // temporarily reset the Cellselected paramter here

                    for(var i =0; i < stationMap.count; i++)
                    {
                        stationMap.itemAt(i).cellSelected = false
                        stationMap.selectedStations = 0
                    }
                }

            }
            onPositionChanged: {

                if(multipleSelectMouseArea.state ==="selectStations")
                {
                    if(multipleSelectMouseArea.isPressed)
                    {
                        //-x,+y
                        if(mouseX - selectRect.initX < 0 && mouseY - selectRect.initY > 0)
                        {
                            selectRect.x = mouseX
                            selectRect.y = selectRect.initY

                        }
                        //-x,-y
                        else if(mouseX - selectRect.initX < 0 && mouseY - selectRect.initY < 0)
                        {
                            selectRect.x = mouseX
                            selectRect.y = mouseY
                        }
                        //+x,-y
                        else if(mouseX - selectRect.initX > 0 && mouseY - selectRect.initY < 0)
                        {
                            selectRect.x = selectRect.initX
                            selectRect.y = mouseY
                        }
                        //+x,+y
                        else
                        {
                            //do nothing
                        }
                        selectRect.width = Math.abs(mouseX - selectRect.initX)
                        selectRect.height = Math.abs(mouseY - selectRect.initY)
                    }
                }



            }
            onReleased: {

                if(multipleSelectMouseArea.state ==="selectStations")
                {
                    for(var i = 0; i < stationMap.count; i++)
                    {
                        //                    var width = 0.5* (myDragcell.width + outerw)
                        //                    var height = 0.5* (myDragcell.height + outerh)

                        //                    var dx = (myDragcell.x +50) - (outerx + 60)
                        //                    var dy = (myDragcell.y + 50) - (outery + 60)

                        var width = 0.5*(stationMap.itemAt(i).width + selectRect.width)
                        var height=0.5*(stationMap.itemAt(i).height + selectRect.height)

                        var dx =(stationMap.itemAt(i).x+50) -(selectRect.x + selectRect.width/2)
                        var dy = (stationMap.itemAt(i).y+50) -(selectRect.y + selectRect.height/2)

                        if(Math.abs(dx) <= width && Math.abs(dy) <= height)
                        {
                            stationMap.itemAt(i).cellSelected = true
                            stationMap.selectedStations = stationMap.selectedStations + 1
                        }

                    }
                    selectRect.x = 0
                    selectRect.y = 0
                    selectRect.width = 0
                    selectRect.height = 0
                }

            }
        }

        //Repeater for stations
        Repeater
        {
            id: stationMap
            width: 1200
            height: 800

            model: myStationModel

            property int selectedStations: 0

            Rectangle
            {
                id: myDragcell
                width: 100
                height: 100
                x:m_left
                y:m_top
                color: cellSelected ?"#222":"transparent"
                property bool currentStation: false
                property string currentStationState: ""
                property int counter: 0
                property int initX
                property int initY
                property bool cellSelected: false
                property int stationId

                stationId: GlobalId
                state: stationState

                states:[
                    State{
                        name:"EgunNotFound"

                        PropertyChanges {
                            target: stationStatus
                            gradient: individualStation.pressed? stationPressedGradient: egunNotFoundGradient
                        }
                        PropertyChanges {
                            target: individualStationTextContent
                            color: "white"

                        }
                        PropertyChanges {
                            target: individualStation
                            disableClick: false
                        }

                    },
                    State{
                        name:"EgunGood"
                        PropertyChanges {
                            target: stationStatus
                            gradient: individualStation.pressed?  stationPressedGradient : egunGoodGradient
                        }
                        PropertyChanges {
                            target: individualStationTextContent
                            color: "white"
                        }

                        PropertyChanges {
                            target: individualStation
                            disableClick: false
                        }

                    },
                    State{
                        name:"EgunWarning"
                        PropertyChanges {
                            target: stationStatus
                            gradient: individualStation.pressed?   stationPressedGradient: egunWarningGradient
                        }
                        PropertyChanges {
                            target: individualStationTextContent
                            color: "white"
                        }

                        PropertyChanges {
                            target: individualStation
                            disableClick: false
                        }
                    },
                    State{
                        name:"EgunAlert"
                        PropertyChanges {
                            target: stationStatus
                            gradient: individualStation.pressed?  stationPressedGradient :egunAlertGradient
                        }
                        PropertyChanges {
                            target: individualStationTextContent
                            color: "white"
                        }

                        PropertyChanges {
                            target: individualStation
                            disableClick: false
                        }
                    },
                    State {
                        name: "StationEnteredEditMode"
                        PropertyChanges {
                            target: stationStatus
                            gradient: individualStation.pressed?  stationPressedGradient :stationEnteredEditModeGradient
                        }
                        PropertyChanges {
                            target: individualStationTextContent
                            color: "black"
                        }

                        PropertyChanges {
                            target: individualStation
                            disableClick: true
                        }
                    }



                ]

                MouseArea
                {
                    id: mouse
                    anchors.fill: parent
                    drag.target: myDragcell
                    drag.axis: Drag.XAndYAxis
                    drag.minimumY: 0
                    drag.maximumY: stationMap.height - 100
                    drag.minimumX: 0
                    drag.maximumX: stationMap.width - 100
                    visible: depotEditEnable
                    z: 2 // higher z


                    onPressed: {

                        for (var i =0; i < stationMap.count; i++)
                        {
                            stationMap.itemAt(i).initX = stationMap.itemAt(i).x
                            stationMap.itemAt(i).initY = stationMap.itemAt(i).y
                        }

                        myDragcell.cellSelected = true
                        stationMap.selectedStations = stationMap.selectedStations + 1

                    }

                    onMouseXChanged:
                    {
                        myDragcell.currentStation = true
                        if(myDragcell.cellSelected && stationMap.selectedStations > 1)
                        {
                            for (var i =0; i < stationMap.count; i++)
                            {
                                if(stationMap.itemAt(i).cellSelected)
                                {
                                    stationMap.itemAt(i).x = stationMap.itemAt(i).initX +(myDragcell.x - myDragcell.initX)
                                    stationMap.itemAt(i).y = stationMap.itemAt(i).initY +(myDragcell.y - myDragcell.initY)
                                }
                            }
                        }
                        else
                        {

                            for(var i=0; i < stationMap.count; i++)
                            {
                                if(!(stationMap.itemAt(i).currentStation))
                                {
                                    var outerw = stationMap.itemAt(i).width +20;
                                    var outerh = stationMap.itemAt(i).height + 20;

                                    var outerx = stationMap.itemAt(i).x - 10
                                    var outery = stationMap.itemAt(i).y - 10

                                    var width = 0.5* (myDragcell.width + outerw)
                                    var height = 0.5* (myDragcell.height + outerh)

                                    var dx = (myDragcell.x +50) - (outerx + 60)
                                    var dy = (myDragcell.y + 50) - (outery + 60)
                                    if(Math.abs(dx) <= width && Math.abs(dy) <= height)
                                    {

                                        var wy = width * dy;
                                        var hx = height * dx;

                                        if(wy >= hx)
                                        {
                                            if( wy >= -hx)
                                            {
                                                //snap inter bottom
                                                myDragcell.y = stationMap.itemAt(i).y + myDragcell.height
                                                //console.log("collision with the outer box bottom")

                                                if(Math.abs(myDragcell.x - stationMap.itemAt(i).x) <= 10)
                                                {
                                                    myDragcell.x = stationMap.itemAt(i).x
                                                }

                                            }
                                            else
                                            {
                                                // snap inter left
                                                myDragcell.x = stationMap.itemAt(i).x - myDragcell.width
                                                //console.log("collision with the outer box left")
                                                if(Math.abs(myDragcell.y - stationMap.itemAt(i).y) <= 10)
                                                {
                                                    myDragcell.y = stationMap.itemAt(i).y
                                                }
                                            }
                                        }
                                        else
                                        {
                                            if(wy >= -hx)
                                            {
                                                // snap inter right
                                                myDragcell.x = stationMap.itemAt(i).x + myDragcell.width
                                                //console.log("collision with the outer box right")
                                                if(Math.abs(myDragcell.y - stationMap.itemAt(i).y) <= 10)
                                                {
                                                    myDragcell.y = stationMap.itemAt(i).y
                                                }
                                            }
                                            else
                                            {
                                                // snap inter top
                                                myDragcell.y = stationMap.itemAt(i).y - myDragcell.height
                                                //console.log("collision with the outer box top")

                                                if(Math.abs(myDragcell.x - stationMap.itemAt(i).x) <= 10)
                                                {
                                                    myDragcell.x = stationMap.itemAt(i).x
                                                }
                                            }
                                        }
                                        //                                                                                                 myDragcell.state="InterBoundary"
                                    }
                                }
                            }
                        }
                        myDragcell.currentStation = false
                    }
                }

                Label{
                    width: 70
                    height: 20
                    z:1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: egunType
                    font.pixelSize: 12
                    font.bold: true
                    color: "black"
                    verticalAlignment:  Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    background: Rectangle
                    {
                        color: "transparent"
                    }

                }

                Button
                {
                    id: individualStation
                    height: 65
                    width: 70
                    text: stationName
                    z:1
                    property bool disableClick: false
                    contentItem: Text
                    {
                        id: individualStationTextContent
                        text: individualStation.text
                        font.pixelSize: 20
                        font.bold: true

                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                    }

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 20
                    background: Rectangle
                    {
                        id:stationStatus
                        radius:5
                    }

                    onClicked:
                    {
                        if(!disableClick)
                        {
                            mainStackView.push(Qt.resolvedUrl("StationPage.qml"),
                                               {sGlobalId: GlobalId,
                                                   sRFID: RFID,
                                                   sKTPN: KTPN,
                                                   sEgunType: egunType,
                                                   sStationName: stationName,
                                                   sKTSERIALPN: KTSERIALPN,
                                                   sLPN: LPN,
                                                   sSUPPLIERTESTDATE: SUPPLIERTESTDATE,
                                                   sMFGGUNOFFPRESSURE:GUNOFFPRESSURE,
                                                   sPONumber: PO,
                                                   sDATERECEIVED: ReceviedDate,
                                                   sDATESHIPPED: ShippedDate,
                                                   sHVON: HVON,
                                                   sProtectON: ProtectOn,
                                                   sValveON:ValveON })
                        }

                    }

                }
            }
        }


        //Repeater for gauge

        Repeater
        {
            id: gaugeMap
            model: myGaugeModel
            width: 1200
            height: 800

            Rectangle{

                id: myGaugeDragCell
                width: 100
                height: 100
                x: m_left
                y: m_top
                color: "transparent"
                property bool currentStation: false
                property int counter: 0
                property int previousX
                property int previousY
                property int gaugeId

                gaugeId: GlobalId
                MouseArea
                {
                    id: mouse1
                    anchors.fill: parent
                    drag.target: myGaugeDragCell
                    drag.axis: Drag.XAndYAxis
                    drag.minimumY: 0
                    drag.maximumY: gaugeMap.height - 100
                    drag.minimumX: 0
                    drag.maximumX: gaugeMap.width - 100
                    visible: depotEditEnable
                    z: 2 // higher z


                    onMouseXChanged:
                    {
                        myGaugeDragCell.currentStation = true

                        for(var i=0; i < gaugeMap.count; i++)
                        {
                            if(!(gaugeMap.itemAt(i).currentStation))
                            {
                                var outerw = gaugeMap.itemAt(i).width +20;
                                var outerh = gaugeMap.itemAt(i).height + 20;

                                var outerx = gaugeMap.itemAt(i).x - 10
                                var outery = gaugeMap.itemAt(i).y - 10

                                var width = 0.5* (myGaugeDragCell.width + outerw)
                                var height = 0.5* (myGaugeDragCell.height + outerh)

                                var dx = (myGaugeDragCell.x +50) - (outerx + 60)
                                var dy = (myGaugeDragCell.y + 50) - (outery + 60)
                                if(Math.abs(dx) <= width && Math.abs(dy) <= height)
                                {

                                    var wy = width * dy;
                                    var hx = height * dx;

                                    if(wy >= hx)
                                    {
                                        if( wy >= -hx)
                                        {
                                            //snap inter bottom
                                            myGaugeDragCell.y = gaugeMap.itemAt(i).y + myGaugeDragCell.height
                                            //console.log("collision with the outer box bottom")

                                            if(Math.abs(myGaugeDragCell.x - gaugeMap.itemAt(i).x) <= 10)
                                            {
                                                myGaugeDragCell.x = gaugeMap.itemAt(i).x
                                            }


                                        }
                                        else
                                        {
                                            // snap inter left
                                            myGaugeDragCell.x = gaugeMap.itemAt(i).x - myGaugeDragCell.width
                                            //console.log("collision with the outer box left")
                                            if(Math.abs(myGaugeDragCell.y - gaugeMap.itemAt(i).y) <= 10)
                                            {
                                                myGaugeDragCell.y = gaugeMap.itemAt(i).y
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if(wy >= -hx)
                                        {
                                            // snap inter right
                                            myGaugeDragCell.x = gaugeMap.itemAt(i).x + myGaugeDragCell.width
                                            //console.log("collision with the outer box right")
                                            if(Math.abs(myGaugeDragCell.y - gaugeMap.itemAt(i).y) <= 10)
                                            {
                                                myGaugeDragCell.y = gaugeMap.itemAt(i).y
                                            }
                                        }
                                        else
                                        {
                                            // snap inter top
                                            myGaugeDragCell.y = gaugeMap.itemAt(i).y - myGaugeDragCell.height
                                            //console.log("collision with the outer box top")

                                            if(Math.abs(myGaugeDragCell.x - gaugeMap.itemAt(i).x) <= 10)
                                            {
                                                myGaugeDragCell.x = gaugeMap.itemAt(i).x
                                            }
                                        }
                                    }

                                }
                            }
                        }
                        myGaugeDragCell.currentStation = false
                    }
                }

                Label{
                    width: 70
                    height: 20
                    z:1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: "gauge"
                    font.pixelSize: 12
                    font.bold: true
                    color: "black"
                    verticalAlignment:  Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    background: Rectangle
                    {
                        color: "transparent"
                    }

                }

                Button
                {
                    id: individualGauge
                    height: 65
                    width: 70
                    text: GlobalId
                    z:1
                    property bool disableClick: false
                    contentItem: Text
                    {
                        id: individualGaugeTextContent
                        text: individualGauge.text
                        font.pixelSize: 20
                        font.bold: true

                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                    }

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 20
                    background: Rectangle
                    {
                        id:gaugeStatus
                        radius:5
                        gradient: individualGauge.pressed? stationPressedGradient : egunGoodGradient
                    }

                    onClicked:
                    {
                        if(!disableClick)
                        {

                        }

                    }

                }

            }
        }
    }

    // GRADIENTS FOR STATION AND GAUGE STATUS

    Gradient {
        id: egunNotFoundGradient
        GradientStop {
            position: 0.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#14148c"; to: "#0E1533"; duration: 5000 }
                ColorAnimation { from: "#0E1533"; to: "#14148c"; duration: 5000 }
            }
        }
        GradientStop {
            position: 2.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#14aaff"; to: "#437284"; duration: 5000 }
                ColorAnimation { from: "#437284"; to: "#14aaff"; duration: 5000 }
            }
        }
    }


    Gradient {
        id: egunGoodGradient
        GradientStop {
            position: 1.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#4ba84c"; to: "#16dd18"; duration: 5000 }
                ColorAnimation { from: "#16dd18"; to: "#4ba84c"; duration: 5000 }

            }
        }

        GradientStop {
            position: 0.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#62a060"; to: "#2ea32a"; duration: 5000 }
                ColorAnimation { from: "#2ea32a"; to: "#62a060"; duration: 5000 }

            }
        }
    }
    Gradient {
        id: egunAlertGradient
        GradientStop {
            position: 0.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#fc8364"; to: "#f74e22"; duration: 5000 }
                ColorAnimation { from: "#f74e22"; to: "#fc8364"; duration: 5000 }

            }
        }

    }

    Gradient {
        id: egunWarningGradient
        GradientStop {
            position: 0.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#f7e874"; to: "#ffe414"; duration: 5000 }
                ColorAnimation { from: "#ffe414"; to: "#f7e874"; duration: 5000 }

            }
        }

    }

    Gradient {
        id: stationPressedGradient
        GradientStop {
            position: 0.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#a9e4f7"; to: "#0fb4e7"; duration: 5000 }
                ColorAnimation { from: "#0fb4e7"; to: "#a9e4f7"; duration: 5000 }

            }
        }

    }

    Gradient {
        id: stationEnteredEditModeGradient
        GradientStop {
            position: 0.0
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#ee0979"; to: "#ff6a00"; duration: 5000 }
                ColorAnimation { from: "#ff6a00"; to: "#ee0979"; duration: 5000 }

            }
        }

    }


    // TOOL DRAWER FOR EDITING DEPOT LAYOUT, ADD AND REMOVE STATIONS/GAUGES
    Rectangle{
        id: toolDrawer
        anchors.top: parent.top
        anchors.topMargin: 180
        anchors.right: parent.right
        visible: false
        width: 120
        height: 600
        border.color: "black"
        border.width: 3
        radius: 10

        ColumnLayout{
            anchors.fill: parent
            spacing: 0
            anchors.leftMargin: 10
            Layout.fillHeight: false

            Text {

                text: qsTr("Stations")
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                id: addStationButton
                width: 50
                height: 50
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: addStationMouse.pressed? "#222" : "transparent"
                Image {
                    id: addStationIcon
                    source: "../images/addStation.png"
                }

                MouseArea{
                    id: addStationMouse
                    anchors.fill: parent

                }
            }

            Rectangle{
                id: removeStationButton
                width: 50
                height: 50
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: removeStationMouse.pressed? "#222" : "transparent"
                Image {
                    id: remoStationIcon
                    source: "../images/removeStation.png"
                }

                MouseArea{
                    id: removeStationMouse
                    anchors.fill: parent

                }
            }

            Text {

                text: qsTr("Gauges")
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                id: addGaugeButton
                width: 50
                height: 50
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: addGaugeMouse.pressed? "#222" : "transparent"
                Image {
                    id: addGaugeIcon
                    source: "../images/addStation.png"
                }

                MouseArea{
                    id: addGaugeMouse
                    anchors.fill: parent

                }
            }

            Rectangle{
                id: removeGaugeButton
                width: 50
                height: 50
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: removeGaugeMouse.pressed? "#222" : "transparent"
                Image {
                    id: removeGaugeIcon
                    source: "../images/removeStation.png"
                }

                MouseArea{
                    id: removeGaugeMouse
                    anchors.fill: parent

                }
            }

            Rectangle
            {
                id: toolUpdateButton
                radius: 10
                color: toolUpdateButtonMouse.pressed? "#222" : "transparent"
                width: 100
                height: 40
                border.color: "black"
                border.width: 1

                Text {

                    text: qsTr("Update")
                    font.pixelSize: 20
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                }

                MouseArea{
                    id: toolUpdateButtonMouse
                    anchors.fill: parent

                    onPressed: {

                    }
                    onReleased: {
                        // update Stations positions
                        for(var i = 0; i < stationMap.count; i++)
                        {
                            LocalDb.updateStationPositions(stationMap.itemAt(i).stationId, stationMap.itemAt(i).x, stationMap.itemAt(i).y)
                        }

                         // update Gauge positions
                        for(var i1 = 0; i1 < gaugeMap.count; i1++)
                        {
                            LocalDb.updateGaugePositions(gaugeMap.itemAt(i1).gaugeId, gaugeMap.itemAt(i1).x, gaugeMap.itemAt(i1).y)
                        }

                    }
                }
            }
        }
    }

    InfoPopup{
        id: infoPopup
        x: parent.width/2 -250
        y: parent.height/2 - 250
    }
}
