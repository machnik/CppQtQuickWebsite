#include "WebSocketServer.h"

#include <QtWebSockets/QWebSocket>

WebSocketServer::WebSocketServer(QObject * parent) :
    QObject(parent),
    m_webSocketServer(
        new QWebSocketServer(QStringLiteral("Echo Server"),
        QWebSocketServer::NonSecureMode,
        this)
    ),
    m_isServerRunning(false)
{
    connect(m_webSocketServer, &QWebSocketServer::newConnection,
            this, &WebSocketServer::onNewConnection);
}

bool WebSocketServer::isServerRunning() const
{
    return m_isServerRunning;
}

void WebSocketServer::startServer(int port)
{
    if (!m_webSocketServer->listen(QHostAddress::Any, port)) {
        emit errorOccurred(m_webSocketServer->errorString());
    } else {
        m_isServerRunning = true;
        emit serverRunningChanged();
    }
}

void WebSocketServer::stopServer()
{
    m_webSocketServer->close();
    m_isServerRunning = false;
    emit serverRunningChanged();
}

void WebSocketServer::onNewConnection()
{
    auto socket = m_webSocketServer->nextPendingConnection();

    connect(socket, &QWebSocket::textMessageReceived,
        this, &WebSocketServer::processTextMessage);
    connect(socket, &QWebSocket::disconnected,
        this, &WebSocketServer::socketDisconnected);
}

void WebSocketServer::processTextMessage(const QString & message)
{
    if (auto socket = qobject_cast<QWebSocket *>(sender())) {
        socket->sendTextMessage(message);
        emit bouncedMessage(message);
    }
}

void WebSocketServer::socketDisconnected()
{
    if (auto socket = qobject_cast<QWebSocket *>(sender())) {
        socket->deleteLater();
    }
}
