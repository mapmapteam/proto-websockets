/****************************************************************************
**
** Copyright (C) 2016 Kurt Pattyn <pattyn.kurt@gmail.com>.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtWebSockets module of the Qt Toolkit.
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
import QtQuick 2.0
import QtWebSockets 1.0
import QtQuick.Layouts 1.3


Rectangle {
    width: 640
    height: 480

    WebSocket {
        id: socket
        url: "ws://localhost:1234"
        onTextMessageReceived: {
            // appends received text to the Text item
            console.log("Received :" + message)
            messageBox.appendText("Received message: " + message)
        }
        onStatusChanged: {
            console.log("socket.status" + socket.status)
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
                socket.sendTextMessage("greeting: Hello World")
                console.log("open!")
            } else if (socket.status == WebSocket.Closed) {
                messageBox.text += "\nSocket closed"
                console.log("closed")
            }
        }
        active: false
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: messageBox
            text: socket.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")
            anchors.centerIn: parent

            function appendText(message) {
                text = text + "\n" + message
            }
        }

        Rectangle {
            id: connectButton
            width: 50
            height: 50
            color: "red"

            Text {
                text: "connect"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    socket.active = ! socket.active

                    if (socket.active) {
                        connectButton.color = "blue"
                    } else {
                        connectButton.color = "red"
                    }
                }
            }
        }

        Rectangle {
            id: sendButton
            width: 50
            height: 50
            color: "orange"

            Text {
                text: "send"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (socket.active) {
                        var toSend = "more: Hello World"
                        socket.sendTextMessage(toSend)
                        messageBox.appendText("Send message: " + toSend)
                        console.log("socket.sendTextMessage " + toSend)
                    } else {
                        console.log("socket is not active")
                    }
                }
            }
        }
    }
}
