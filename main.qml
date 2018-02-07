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
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.4
import QtWebSockets 1.0

import pnlug.guibkp 1.0
import "qml"

ApplicationWindow {
    visible: true
    title: "Qt Quick UI Forms"

    MessageDialog {
        id: aboutDialog
        icon: StandardIcon.Information
        title: qsTr("About")
        text: "Qt Quick UI Forms"
        informativeText: qsTr("This example demonstrates how to separate the implementation of an application from the UI using ui.qml files.")
    }

    Action {
        id: copyAction
        text: qsTr("&Copy")
        shortcut: StandardKey.Copy
        iconName: "edit-copy"
        enabled: (!!activeFocusItem && !!activeFocusItem["copy"])
        onTriggered: activeFocusItem.copy()
    }

    Action {
        id: cutAction
        text: qsTr("Cu&t")
        shortcut: StandardKey.Cut
        iconName: "edit-cut"
        enabled: (!!activeFocusItem && !!activeFocusItem["cut"])
        onTriggered: activeFocusItem.cut()
    }

    Action {
        id: pasteAction
        text: qsTr("&Paste")
        shortcut: StandardKey.Paste
        iconName: "edit-paste"
        enabled: (!!activeFocusItem && !!activeFocusItem["paste"])
        onTriggered: activeFocusItem.paste()
    }

    Action {
        id: websock_on_Action
        text: qsTr("websocket O&n")
        //iconName: "WebSocket ON"
        onTriggered: {

            socket.active = true
        }

    }

    Action {
        id: websock_off_Action
        text: qsTr("websocket Of&f")
        onTriggered: {
            socket.active = false
        }
    }

    Action {
        id: websock_refresh_Action
        text: qsTr("websocket refres&h")
        onTriggered: {
            var objArray3 = {Comando:"TxDatiRefresh"};
            console.log("Questo è un array? " + Array.isArray(objArray3))
            socket.sendTextMessage(JSON.stringify(objArray3))
        }
    }

    Action {
        id: websock_receive_Action
        text: qsTr("websocket &receive")
        onTriggered: {
            //var objArray3 = JSON.parse("{"Comando":"TxDati"}");
            //var objArray3 = JSON.parse("[]");
            var objArray3 = {Comando:"TxDati"};
            console.log("Questo è un array? " + Array.isArray(objArray3))
            socket.sendTextMessage(JSON.stringify(objArray3))
        }
    }

    Action {
        id: websock_send_Action
        text: qsTr("websocket sen&d")
        onTriggered: {
            // ok - var objArray2 = JSON.parse("[" + JSON.stringify(CustomerModel.get(0)) + "]");
            var objArray2 = JSON.parse("[]");
            console.log("Questo è un array? " + Array.isArray(objArray2))
            // error - console.log("Questo è un array? " + objArray2.isArray())
            console.log("Questo è un array? " + objArray2.constructor)

            for (var i=0;i<CustomerModel.count;i++) {
                objArray2.push(CustomerModel.get(i))
            }

            objArray2.sort();
            //objArray2.reverse();
            socket.sendTextMessage(JSON.stringify(objArray2))


        }
    }


    Action {
        id: record_add_Action
        text: qsTr("Record &Add")
        onTriggered: {
            var jsonObj = {
                "lastName":"",
                "firstName":"",
                "customerId":"",
                "email":"",
                "address":"",
                "phoneNumber":"",
                "zipCode":"",
                "city":"",
                "title":"",
                "history":"",
                "notes":""
            }

            CustomerModel.append(jsonObj)
            mainForm.tableView.selection.clear()
            mainForm.tableView.currentRow = mainForm.tableView.rowCount
            mainForm.tableView.selection.select(mainForm.tableView.rowCount-1)
        }
    }

    Action {
        id: record_del_Action
        text: qsTr("Record &Delete")
        onTriggered: {
            CustomerModel.selection.forEach(function(rowIndex){CustomerModel.remove(rowIndex)})
        }
    }
    Action {
        id: record_move_Action
        text: qsTr("Record &Move")
        onTriggered: {
            CustomerModel.move(0,2,1)
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("E&xit")
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("&Edit")
            MenuItem {
                action: cutAction
            }
            MenuItem {
                action: copyAction
            }
            MenuItem {
                action: pasteAction
            }
        }

        Menu {
            title: qsTr("&Record ")
            MenuItem {
                action: record_add_Action
            }
            MenuItem {
                action: record_del_Action
            }
            MenuItem {
                action: record_move_Action
            }
        }
        Menu {
            title: qsTr("&Test")
            MenuItem {
                action: websock_on_Action
            }
            MenuItem {
                action: websock_off_Action
            }
            MenuItem {
                action: websock_send_Action
            }
            MenuItem {
                action: websock_receive_Action
            }
            MenuItem {
                action: websock_refresh_Action
            }
        }
        Menu {
            title: qsTr("&Help")
            MenuItem {
                text: qsTr("About...")
                onTriggered: aboutDialog.open()
            }
        }
    }

    ListModel {
        id: lstModel
        ListElement {
            Campo00: "Prova 00"
            Campo01: 101
            Campo02: "Test 02"
        }
        ListElement {
            Campo00: "Prova 10"
            Campo01: 102
            Campo02: "Test 12"
        }
        ListElement {
            Campo00: "Prova 20"
            Campo01: 103
            Campo02: "Test 22"
        }
    }

    WebSocket {
        id: socket
        //url: "ws://echo.websocket.org"
        url: "ws://localhost:1234"
        onTextMessageReceived: {
            // messageBox.text = messageBox.text + "\nReceived message: " + message
            console.log ("Questo è il messaggio: " + message)
            var objectArray = JSON.parse(message)
            if (objectArray.errors !== undefined)
                console.log("Error fetching tweets: " + objectArray.errors[0].message)
            else {
                console.log("Sezione di Parsing ..." + objectArray )

                console.log("Questo è un array? " + Array.isArray(objectArray))
                if(Array.isArray(objectArray)) {
                    for (var key in objectArray) {
                        var jsonObject = objectArray[key];
                        //tweets.append(jsonObject);
                        // messageBox.text = "\nParse message: " + JSON.stringify(jsonObject)
                        //console.log("Parse Campo: " + jsonObject.Campo00)
                        //console.log("Parse message: " + JSON.stringify(jsonObject))
                        console.log("Parse firstName: " + jsonObject.firstName)
                        console.log("Parse message: " + JSON.stringify(jsonObject))
                        lstModel.append(jsonObject)
                        CustomerModel.append(jsonObject);
                    }
                } else {

                    console.log("Parse Comando: " + objectArray.Comando)
                    if(objectArray.Comando === "Connesso") {
                        CustomerModel.clear()
                        websock_refresh_Action.trigger()

                    }
                }

                // console.log("Sezione di Parsing ..." + objectArray.Pippo )
                // for (var key in objectArray.Pippo) {
                //     var jsonObject = objectArray.Pippo[key];
                //     //tweets.append(jsonObject);
                //     // messageBox.text = "\nParse message: " + JSON.stringify(jsonObject)
                //     console.log("Parse Campo: " + jsonObject.Campo00)
                //     console.log("Parse message: " + JSON.stringify(jsonObject))
                // }
            }

        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             //socket.sendTextMessage("Hello World")
                             // var objectArray = JSON.parse("{\"Array\":[true,999,\"string\"],\"Key\":\"Value\",\"null\":null}");
                             // var objectArray = JSON.parse("[\"stringa 00\",111,\"stringa 02\",{\"Campo 30\": \"String 30\",\"Campo 31\": 31,\"Campo 32\": \"String 32\"}]");
                             var objectArray = JSON.parse("[{\"Campo00\": \"String 00\",\"Campo01\": 1,\"Campo02\": \"String 02\"},{\"Campo00\": \"String 10\",\"Campo01\": 2,\"Campo02\": \"String 02\"}]");
                             // var objectArray = JSON.parse("{\"Pippo\": [{\"Campo00\": \"String 00\",\"Campo01\": 1,\"Campo02\": \"String 02\"},{\"Campo00\": \"String 10\",\"Campo01\": 2,\"Campo02\": \"String 02\"}]}");
                             //socket.sendTextMessage(JSON.stringify(objectArray))
                             // OK - var objArray = lstModel.get(0)
                             // OK - socket.sendTextMessage("[" + JSON.stringify(objArray) + "]")
                             var objArray = JSON.parse("[" + JSON.stringify(lstModel.get(0)) + "]")
                             objArray.push(lstModel.get(1))
                             objArray.push(lstModel.get(2))
                             objArray.push(lstModel.get(1))
                             //socket.sendTextMessage(JSON.stringify(objArray))

                             // NO - socket.sendTextMessage(objectArray.toString())
                             // socket.sendTextMessage("{\"Array\":[true,999,\"string\"],\"Key\":\"Value\",\"null\":null}")
                         } else if (socket.status == WebSocket.Closed) {
                             // messageBox.text += "\nSocket closed"
                             console.log("Socket closed!!")
                         }
        active: false
    }

    MainForm {
        id: mainForm

        anchors.fill: parent

        Layout.minimumWidth: 800
        Layout.minimumHeight: 480
        Layout.preferredWidth: 768
        Layout.preferredHeight: 480

        tableView.model: CustomerModel

        Component.onCompleted: {

            websock_on_Action.trigger()
            //websock_refresh_Action.trigger()
            CustomerModel.selection = tableView.selection
            tableView.sortIndicatorVisible = true

        }
    }
}
