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
#include "ws_server.h"
#include "QtWebSockets/QWebSocketServer"
#include "QtWebSockets/QWebSocket"
#include <QtCore/QDebug>
#include <QtCore/QFile>
#include <QtNetwork/QSslCertificate>
#include <QtNetwork/QSslKey>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>

#include <QFile>
#include <QRegularExpression>

QT_USE_NAMESPACE

//! [constructor]
WSServer::WSServer(quint16 port, QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(Q_NULLPTR)
{
    m_pWebSocketServer = new QWebSocketServer(QStringLiteral("WebSocket Server"),
                                              QWebSocketServer::NonSecureMode,
                                              this);
    // - QSslConfiguration sslConfiguration;
    // - QFile certFile(QStringLiteral(":/localhost.cert"));
    // - QFile keyFile(QStringLiteral(":/localhost.key"));
    // - certFile.open(QIODevice::ReadOnly);
    // - keyFile.open(QIODevice::ReadOnly);
    // - QSslCertificate certificate(&certFile, QSsl::Pem);
    // - QSslKey sslKey(&keyFile, QSsl::Rsa, QSsl::Pem);
    // - certFile.close();
    // - keyFile.close();
    // - sslConfiguration.setPeerVerifyMode(QSslSocket::VerifyNone);
    // - sslConfiguration.setLocalCertificate(certificate);
    // - sslConfiguration.setPrivateKey(sslKey);
    // - sslConfiguration.setProtocol(QSsl::TlsV1SslV3);
    // - //sslConfiguration.setProtocol(QSsl::SslV3);
    // - m_pWebSocketServer->setSslConfiguration(sslConfiguration);

    if (m_pWebSocketServer->listen(QHostAddress::Any, port))
    {
        qDebug() << "WebSocket Server listening on port" << port;
        connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
                this, &WSServer::onNewConnection);
        connect(m_pWebSocketServer, &QWebSocketServer::acceptError,
                this, &WSServer::onAcceptError);
        connect(m_pWebSocketServer, &QWebSocketServer::serverError,
                this, &WSServer::onServerError);

    }
}
//! [constructor]

WSServer::~WSServer()
{
    m_pWebSocketServer->close();
    qDeleteAll(m_clients.begin(), m_clients.end());
}

//! [onNewConnection]
void WSServer::onNewConnection()
{
    // QWebSocketServer *pServer = qobject_cast<QWebSocketServer *>(sender());
    // QWebSocket *pSocket = pServer->nextPendingConnection();


    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();



    qDebug() << "Client connected:" << pSocket->peerName() << pSocket->origin();

    connect(pSocket, &QWebSocket::textMessageReceived,   this, &WSServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &WSServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected,          this, &WSServer::socketDisconnected);

    m_clients << pSocket;

    QJsonObject json_obj {{"Comando","Connesso"}};
    QJsonDocument json_doc(json_obj);

    qDebug() << "Comando: " << json_doc["Comando"].toString();

    pSocket->sendTextMessage(json_doc.toJson());

}
//! [onNewConnection]

//! [processTextMessage]
void WSServer::processTextMessage(QString message)
{
    QFile storageFile(QStringLiteral("./conf/backup.txt"));
    storageFile.open(QIODevice::ReadWrite);

    QFile storageFileRead(QStringLiteral("./conf/backup_read.txt"));
    storageFileRead.open(QIODevice::ReadWrite);
    QJsonDocument json_doc_read = QJsonDocument::fromJson(storageFileRead.readAll());



    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());

    // QJsonObject *json_msg = new QJsonObject(message);
    QJsonDocument json_doc = QJsonDocument::fromJson(message.toLocal8Bit());
    //QJsonDocument json_doc2 = QJsonDocument::fromRawData(message.toLocal8Bit());

    if (pClient)
    {
        //qint64 length_message = storageFile.write(json_doc.toJson(QJsonDocument::Indented));
        qint64 length_message = storageFile.write(json_doc.toJson());
        storageFile.close();

        qDebug() << "Client message: " << message;
        qDebug() << "Clent msg length 0: " << length_message;
        qDebug() << "Client json document 1: " << json_doc.toJson();
        qDebug() << "Client json document 2: " << json_doc_read[0];
        qDebug() << "Client json document 3: " << json_doc[0]["Campo00"].toString();
        qDebug() << "4 - Message is Array? " << json_doc.isArray();
        qDebug() << "5 - Message is Object? " << json_doc.isObject();
        qDebug() << "Client json document 5: " << json_doc[0].isObject();

        if(json_doc.isObject()) {
            //QFile storageFileGuibkp(QStringLiteral("/home/mdau/Work/GUIBkp_read2.txt"));
            QFile storageFileGuibkp(QStringLiteral("./conf/GUIBkp_read.txt"));
            // QFile storageFileGuibkp(QStringLiteral("/home/mdau/Work/backup_read.txt"));
            storageFileGuibkp.open(QIODevice::ReadWrite);
            QJsonDocument json_doc_guibkp = QJsonDocument::fromJson(storageFileGuibkp.readAll());

            qDebug() << "Comando: " << json_doc["Comando"].toString();


            QFile fileTest(QStringLiteral("./conf/FileTest"));
            fileTest.open(QIODevice::ReadWrite);
            QString  strFileTest(fileTest.readAll());
            // ok - strFileTest.replace(QRegExp("^_VAR1="),"_VAR1=`date +%Y`");
            // ok - strFileTest.replace(QRegExp("\n_VAR2="),"\n_VAR2=/Pippo/Peppo");
            strFileTest.replace(QRegularExpression("^_VAR1=",QRegularExpression::MultilineOption),"_VAR1=`date +%Y`");
            strFileTest.replace(QRegularExpression("^_VAR2=",QRegularExpression::MultilineOption),"_VAR2=/Pippo/Peppo");
            fileTest.close();

            QFile fileTestInstance(QStringLiteral("./conf/FileTestInstance"));
            fileTestInstance.open(QIODevice::ReadWrite|QIODevice::Truncate);
            fileTestInstance.write(strFileTest.toLocal8Bit());
            fileTestInstance.close();

            pClient->sendTextMessage(json_doc_guibkp.toJson());
            //pClient->sendTextMessage(strFileTest);
        }
        else if(json_doc.isArray()) {
            qDebug() << "First Name: " << json_doc[0]["firstName"].toString();

            QFile file_json_doc(QStringLiteral("./conf/json_doc_rx.txt"));
            file_json_doc.open(QIODevice::WriteOnly|QIODevice::Truncate);
            file_json_doc.write(json_doc.toJson());
            file_json_doc.close();

            QJsonArray json_array = json_doc.array();
            //json_array[0]["Campo00"] = "Modifica by Marco";
            //json_array[0].Ob;
            //json_doc.setArray(json_array);
            for(int i=0; i<json_doc.array().size(); i++)
            {
                //QJsonObject *json_obj = qobject_cast<QJsonObject *>(json_doc[i]);
                //qDebug() << "Client json document 6: " << json_obj.contains("Prova");
                qDebug() << "Client json document 6: " << json_doc[i].toObject().contains("Campo00");
                qDebug() << "Client json document 6: " << json_doc[i]["Campo00"].toString();
            }

            QJsonObject json_obj_guibkp_answ {{"Comando","Dati Ricevuti"}};
            QJsonDocument json_doc_guibkp_answ(json_obj_guibkp_answ);

            qDebug() << "Il messaggio in invio è un oggetto? " << json_doc_guibkp_answ.isObject();
            pClient->sendTextMessage(json_doc_guibkp_answ.toJson());
        }


        //json_doc_read[0]["Campo00"] = "Modifica by marco";
        QJsonObject json_obj = json_doc[0].toObject();
        json_obj["Campo00"] = "Modifica by Marco";

        //pClient->sendTextMessage(message);
        //pClient->sendTextMessage(json_doc_read.toJson());
        // pClient->sendTextMessage(json_doc.toJson());


        //QJsonArray::Iterator json_i;
        //for (json_i = json_array.begin(); json_i != json_array.end(); ++json_i ) {
        //    qDebug() << "Client json document 7: " << *json_i["Campo00"].toString();
        //}
    }
}
//! [processTextMessage]

//! [processBinaryMessage]
void WSServer::processBinaryMessage(QByteArray message)
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (pClient)
    {
        pClient->sendBinaryMessage(message);
    }
}
//! [processBinaryMessage]

//! [socketDisconnected]
void WSServer::socketDisconnected()
{
    qDebug() << "Client disconnected";
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (pClient)
    {
        m_clients.removeAll(pClient);
        pClient->deleteLater();
    }
}

//! [socketDisconnected]


void WSServer::onAcceptError(QAbstractSocket::SocketError) {

    qDebug() << "Ssl errors occurred";
}
void WSServer::onServerError(QWebSocketProtocol::CloseCode ) {

    qDebug() << "Ssl errors occurred";
}

