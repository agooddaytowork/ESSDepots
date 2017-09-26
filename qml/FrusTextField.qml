import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

RowLayout
{
    id: frusTextField
    signal textfieldchanged(bool activeFocus)
    property string myText
    property string labelText
    property bool   enable:true
    Layout.fillWidth: true

    onEnableChanged: {
        thisTextfield.enabled = frusTextField.enable
    }
            spacing: 2
            Label
            {
                id: myLabel
                text: labelText
                color: "black"
                font.pixelSize: 20
            }


            TextField{
                id: thisTextfield
                font.pixelSize: 20
                text: myText
                Layout.fillWidth: true
                Layout.rightMargin: 30
                height: 40

                background: Rectangle{
                    radius: 10

                    border.color: "#333"
                    border.width: 1
                }

                onTextChanged:
                {
                    myText = thisTextfield.text
                }

                onActiveFocusChanged:
                {
                    textfieldchanged(activeFocus)
                }


            }
}

