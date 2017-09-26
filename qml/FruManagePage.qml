import QtQuick 2.0
import QtQuick.Controls 2.0

Item {

    id:fruManagePage

    property int    sGlobalId
    property string sRFID
    property string sKTPN
    property string sKTSERIALPN
    property string sLPN
    property string sSUPPLIERTESTDATE
    property string sMFGGUNOFFPRESSURE
    property string sPONumber
    property string sDATERECEIVED
    property string sDATESHIPPED

    Rectangle{

        width: 800
        height: 800
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 500
        color: "#A2A2A2"

        Label
        {
            text: sGlobalId
        }
    }
}
