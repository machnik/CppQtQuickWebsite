#include "WebSocketServer.h"

#include <QtWebSockets/QWebSocket>

#include "Localization.h"

WebSocketServer::WebSocketServer(QObject * parent)
    : QObject{parent}
    , m_webSocketServer{new QWebSocketServer{Localization::strCpp("Echo Server"), QWebSocketServer::NonSecureMode, this}}
    , m_isServerRunning{false}
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
    if (port < 1 || port > 65535) {
        emit errorOccurred(Localization::strCpp("Please enter a valid port number between 1 and 65535."));
        return;
    }

    if (m_isServerRunning) {
        return;
    }

    if (!m_webSocketServer->listen(QHostAddress::Any, port)) {
        setServerRunning(false);
        emit errorOccurred(m_webSocketServer->errorString());
    } else {
        setServerRunning(true);
    }
}

void WebSocketServer::stopServer()
{
    const auto clients{m_clients};
    for (auto socket : clients) {
        if (!socket) {
            continue;
        }

        socket->close();
        socket->deleteLater();
    }

    m_clients.clear();
    m_webSocketServer->close();
    setServerRunning(false);
}

void WebSocketServer::onNewConnection()
{
    auto socket{m_webSocketServer->nextPendingConnection()};
    if (!socket) {
        return;
    }

    m_clients.append(socket);

    connect(socket, &QWebSocket::textMessageReceived,
        this, &WebSocketServer::processTextMessage);
    connect(socket, &QWebSocket::disconnected,
        this, &WebSocketServer::socketDisconnected);
}

void WebSocketServer::processTextMessage(const QString & message)
{
    if (auto socket{qobject_cast<QWebSocket *>(sender())}; socket) {
        socket->sendTextMessage(message);
        emit bouncedMessage(message);
    }
}

void WebSocketServer::socketDisconnected()
{
    if (auto socket{qobject_cast<QWebSocket *>(sender())}; socket) {
        m_clients.removeAll(socket);
        socket->deleteLater();
    }
}

void WebSocketServer::setServerRunning(bool isRunning)
{
    if (m_isServerRunning == isRunning) {
        return;
    }

    m_isServerRunning = isRunning;
    emit serverRunningChanged();
}
