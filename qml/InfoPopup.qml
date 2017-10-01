import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item {

    id: infoPopup
    function open(){
        infoPopup.open()
    }

    state: "Info"
    states: [
        State { name:"Info"},
        State { name:"Warning"},
        State { name:"Alert"},
        State { name:"Confirmation"}
    ]
    Popup{
        id: aPopUP
        width: 500
        height: 500
        dim: true
        background: Rectangle{
            radius: 10
        }

        ListView {
            id: popupListView
            anchors.fill: parent
            currentIndex: -1
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            model: messageModel
            clip: true

            delegate: SwipeDelegate{

                text: theMessage

            }

        }

        closePolicy: Popup.CloseOnPressOutside
        onAboutToHide: {
            messageModel.clear()
        }

    }

    ListModel{
        id: messageModel

    }

    Connections{
        target: LocalDb
        onMessageToUser:{

            if(type === LocalDb.Info)
            {
                infoPopup.state = "Info"
            }
            else if (type === LocalDb.Warning)
            {
                infoPopup.state = "Warning"
            }
            else if (type === LocalDb.Alert)
            {
                infoPopup.state = "Alert"
            }
            else if (type === LocalDb.Confirmation)
            {
                infoPopup.state = "Confimation"
            }
            messageModel.append({theMessage: message})
            aPopUP.open()
        }
    }



}
