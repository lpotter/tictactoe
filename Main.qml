/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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
import Ubuntu.Components 1.1
import "content"
import "content/tic-tac-toe.js" as Logic

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "tic-tac-toe.llornkcor"


    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    automaticOrientation: false

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(75)

    Page {
        id: game

        property bool running: true
        property real difficulty: 1.0   //chance it will actually think
        title: i18n.tr("Tic Tac Toe")
        property bool xTurn: true
        property bool playComputer: true

        Image {
            id: boardImage
            source: "content/pics/board.png"
            smooth: true
            width: game.width
            height: units.gu(47)
        }

        Column {
            id: display
            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
                fill: parent
            }
            Grid {
                id: board
                width: boardImage.width - units.gu(4)
                height: boardImage.height - units.gu(4)
                columns: 3

                Repeater {
                    model: 9

                    TicTac {
                        width: board.width/3
                        height: board.height/3

                        onClicked: {
                            if (game.running && Logic.canPlayAtPos(index)) {
                                if (!game.playComputer) {
                                    if (game.xTurn) {
                                        Logic.makeMove(index, "X")
                                    } else {
                                        Logic.makeMove(index, "O")
                                    }
                                    game.xTurn = !game.xTurn
                                } else {
                                    if (!Logic.makeMove(index, "X"))
                                        Logic.computerTurn();
                                }
                            }
                        }
                    }
                }
            }
            Label {
                text:  game.playComputer ? "Playing Computer" : (game.xTurn ? "X's turn" : "O's turn")
            }
            Row {
                spacing: units.gu(3)
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "Hard"
                    pressed: game.difficulty == 1.0
                    onClicked: { game.difficulty = 1.0 }
                }
                Button {
                    text: "Moderate"
                    pressed: game.difficulty == 0.8
                    onClicked: { game.difficulty = 0.8 }
                }
                Button {
                    text: "Easy"
                    pressed: game.difficulty == 0.2
                    onClicked: { game.difficulty = 0.2 }
                }
            }
            Row {
                spacing: units.gu(3)
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: !game.playComputer ? "Play Computer" : "2 Player"
                    onClicked: {
                        game.playComputer = !game.playComputer
                        Logic.restartGame()
                    }
                }
                Button {
                    text: "Reset"
                    onClicked: {
                        Logic.restartGame()
                    }
                }

            }
        }
        Text {
            id: messageDisplay
            anchors.centerIn: parent
            color: "blue"
            style: Text.Outline; styleColor: "white"
            font.pixelSize: units.gu(10); font.bold: true
            visible: false

            Timer {
               // interval: 2000
                running: messageDisplay.visible
                onTriggered: {
                    messageDisplay.visible = false;
                    Logic.restartGame();
                }
            }
        }
    }
}

