/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0


ColumnLayout {
    property string rFID
    property string KTPN
    property string KTSERIALPN
    property string LPN
    property string SUPPLIERTESTDATE
    property string MFGGUNOFFPRESSURE
    property string PONumber
    property string DATERECEIVED
    property string DATESHIPPED

    spacing: 8
    Layout.fillHeight: true
    width: 400

    Label{
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignVCenter
        text:"E-source Information"
        font.pixelSize: 30

    }
    Label{
        id: rfid
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"RFID: " + rFID
        font.pixelSize: 20
    }

    Label{
        id: ktpn
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"KTPN: " +KTPN
        font.pixelSize: 20
    }
    Label{
        id: ktserialpn
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"KT Serial PN: " +KTSERIALPN
        font.pixelSize: 20
    }
    Label{
        id: lpn
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"LPN: "+ LPN
        font.pixelSize: 20
    }
    Label{
        id: supplierTestDate
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"Supplier Test Date: " + SUPPLIERTESTDATE
        font.pixelSize: 20
    }
    Label{
        id: mfgPressureoff
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"MFG Gun off GV Closed: "+ MFGGUNOFFPRESSURE
        font.pixelSize: 20
    }
    Label{
        id: purchaseOrder
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"PO: " +PONumber
        font.pixelSize: 20
    }
    Label{
        id: dateReceive
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"Date Received: " + DATERECEIVED
        font.pixelSize: 20
    }
    Label{
        id: dateShipped
        width: parent.width
        wrapMode: Label.Wrap
        verticalAlignment: Qt.AlignLeft
        text:"Date Shipped: " + DATESHIPPED
        font.pixelSize: 20
    }


        Switch{
            id: hvONSwitch
            text:"HV ON"
            checked: false

        }
        Switch{
            id: protectOnSwitch
            text:"Protect ON"
            checked: false

        }


        Switch
        {
            id: valveONSwitch
            text: "Valve ON"
            checked: false

        }

        Button
        {
            id: shipButton
            text: "Ship"
            Layout.fillWidth: true
        }

}
