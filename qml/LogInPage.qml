import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtCharts 2.1
import QtQuick.VirtualKeyboard 2.1
import Qt.labs.settings 1.0

Item {

    id: loginPage
    Settings
    {
        id: setting
        category: "logInPage"
        property string screenPassword: "159753"
    }

    Rectangle
    {
        anchors.fill: parent

        Image {
            id: background
            anchors.fill: parent
            source: "../images/background.jpg"
            fillMode: Image.Stretch
        }


        RowLayout
        {
            id: passwordFieldRow
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            TextField
            {
                id: passwordField
                implicitWidth: 250
                implicitHeight: 50
                echoMode: TextInput.Password
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints:  Qt.ImhDigitsOnly
                text: ""
                placeholderText: "Enter password ..."
                background: Rectangle
                {
                    id: passwordFieldBackGround

                    radius: 10
                    border.color: "#051c42"
                    border.width: 2
                }

                SequentialAnimation{
                    id: shakeWhenWrongPassWord
                    running: false

                    loops: 2
                    onStopped: {
                        wrongPasswordText.visible = true
                    }

                    NumberAnimation {
                        target: passwordField
                        property: "x"
                        duration: 100
                        from: passwordFieldBackGround.x
                        to: passwordFieldBackGround.x + 30
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: passwordField
                        property: "x"
                        duration: 50
                        from: passwordFieldBackGround.x + 30
                        to: passwordFieldBackGround.x
                        easing.type: Easing.InOutQuad
                    }


                }


                onTextChanged:
                {
                    if(passwordField.text.length >= 1)
                    {
                        passwordFieldBackGround.border.color = "black"
                        wrongPasswordText.visible = false
                    }

                    if(passwordField.text == setting.screenPassword && passwordField.text.length <= setting.screenPassword.length  )
                    {
                        passwordField.text = ""
                        passwordField.focus = false
                        if(mainStackView.depth <=1)
                        {
                            mainStackView.push(Qt.resolvedUrl("DepotFloor.qml"))
                        }
                        else
                        {
                            mainStackView.pop()
                        }

                    }
                    else
                    {
                        if( passwordField.text.length === setting.screenPassword.length )
                        {
                            shakeWhenWrongPassWord.running = true
                            passwordField.text = ""
                            passwordFieldBackGround.border.color = "red"
                        }

                        // add some thing here to indicate wrong password

                    }
                }
            }


            Label
            {
                id: wrongPasswordText
                text: "Wrong password!"
                color: "red"
                font.pixelSize: 20
                anchors.rightMargin: 10
                visible: false
            }
        }





        Rectangle
        {
            width: 300
            height: 86
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 100
            anchors.rightMargin: 200

            Image {
                id: logo
                source: "../images/Kla-logo-purplepng.png"
                anchors.fill: parent
                fillMode: Image.Stretch
            }

        }

    }
    InputPanel {
        id: inputPanel
        y: Qt.inputMethod.visible ? (parent.height - inputPanel.height +100 ) : parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        scale: 0.7

    }


}
