/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

Item {
    id: content

    width: 480
    height: 480

    //property alias gridLayout: gridLayout
    //property alias cancel: cancel
    //property alias save: save
    //property alias rectTest: rectTest
    //property alias listViewSettings: listViewSettings


    //RowLayout {
        // anchors.topMargin: 12
        // anchors.right: parent.right
        // anchors.rightMargin: 12
        //anchors.top: gridLayout.bottom

    //}

    //FocusScope {


        Rectangle {
            id: rectTest
            x: 200
            y: 200
            width: 100
            height: 100
            color: "green"
            visible: true
            enabled: true
            Keys.forwardTo: []
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    console.log("Click Rettangolo!")
                }
            }
        }
    //}

    //GridLayout {
    //    id: gridLayout
    //
    //    anchors.right: parent.right
    //    anchors.left: parent.left
    //    anchors.top: parent.top
    //    anchors.rightMargin: 12
    //    anchors.leftMargin: 12
    //    anchors.topMargin: 12
    //    columnSpacing: 8
    //    rowSpacing: 8
    //    rows: 8
    //    columns: 7
    //    enabled: false
    //
    //    MouseArea{
    //        onClicked: {
    //            console.log("Click GridLayout")
    //        }
    //        focus: true
    //
    //    }
    //
    //    Button {
    //        id: prova
    //
    //        text: qsTr("Prova")
    //        enabled: false
    //    }
    //}

    ListModel {
        id: listModelSettings
        ListElement {
            campo: "Nome Backup"
            valore: "Pippo_Work"
        }

        ListElement {
            campo: "Dir Sorgente"
            valore: "/home/pippo/work"
        }

        ListElement {
            campo: "Nome Backup 2"
            valore: "Pippo_Work 2"
        }

        ListElement {
            campo: "Nome Backup 3"
            valore: "Pippo_Work 3"
        }

    }


    Component {
        id: listDelegateSettings
        Text {
            id: campoNome
            text: campo + ": " + valore
        }

    }

    Component {
        id: contactDelegate
        Item {
            width: 180; height: 40
            Column {
                Text { text: '<b>Name:</b> ' + campo }
                Text { text: '<b>Number:</b> ' + valore }
            }
            MouseArea{
                onClicked: {

                    listViewSettings.focus = true
                    console.log("Click ListView")
                }

            }
        }

    }

    //FocusScope
    //{

        //Keys.forwardTo: [cancel, save, listViewSettings]
        //focus: false

        Button {
            id: save
            text: qsTr("Save")
            focus: false
            x: 100
            y: 50
        }

        ListView {
            id: listViewSettings
            height: 20
            width: 150
            x: 10
            y: 150
            enabled: true
            focus: false
            // activeFocusOnTab: true

            model: listModelSettings

            //delegate: listDelegateSettings
            delegate: contactDelegate
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }

            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    console.log("Click ListView")
                }
            }
        }


        Button {
            id: cancel
            text: qsTr("Cancel")
            focus: false
            x: 100
            y: 80
        }

        Button {
            id: bottOne
            text: qsTr("Uno")
            focus: true
            x: 180
            y: 50
        }

        Button {
            id: bottTwo
            text: qsTr("Due")
            focus: false
            x: 180
            y: 110
        }



    //}
}
