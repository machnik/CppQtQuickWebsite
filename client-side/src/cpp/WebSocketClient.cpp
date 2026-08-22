#include "WebSocketClient.h"

#include <QAbstractSocket>

#include "Localization.h"

WebSocketClient::WebSocketClient(QObject *parent)
    : QObject{parent}
    , m_isClientRunning{false}
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WebSocketClient::onDisconnected);
    connect(&m_webSocket, &QWebSocket::errorOccurred, this, &WebSocketClient::onErrorOccurred);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketClient::onTextMessageReceived);
}

void WebSocketClient::startClient(const QString & url)
{
    const QUrl webSocketUrl{url};
    const auto port{webSocketUrl.port()};
    if (!webSocketUrl.isValid() || (webSocketUrl.scheme() != "ws" && webSocketUrl.scheme() != "wss")
            || webSocketUrl.host().isEmpty() || (port != -1 && (port < 1 || port > 65535))) {
        emit errorOccurred(Localization::strCpp("Please enter a valid WebSocket URL."));
        return;
    }

    if (m_webSocket.state() != QAbstractSocket::UnconnectedState) {
        m_webSocket.close();
    }

    m_webSocket.open(webSocketUrl);
}

void WebSocketClient::stopClient()
{
    if (m_webSocket.state() != QAbstractSocket::UnconnectedState) {
        m_webSocket.close();
    }

    setClientRunning(false);
}

bool WebSocketClient::isClientRunning() const
{
    return m_isClientRunning;
}

void WebSocketClient::sendMessage(const QString & message)
{
    if (!m_isClientRunning) {
        emit errorOccurred(Localization::strCpp("Connect to a server before sending a message."));
        return;
    }

    m_webSocket.sendTextMessage(message);
}

void WebSocketClient::onConnected()
{
    setClientRunning(true);
    m_webSocket.sendTextMessage(Localization::strCpp("[server is running]"));
}

void WebSocketClient::onDisconnected()
{
    setClientRunning(false);
}

void WebSocketClient::onErrorOccurred(QAbstractSocket::SocketError error)
{
    Q_UNUSED(error)

    if (m_webSocket.state() == QAbstractSocket::UnconnectedState) {
        setClientRunning(false);
    }

    emit errorOccurred(m_webSocket.errorString());
}

void WebSocketClient::onTextMessageReceived(const QString & message)
{
    emit messageReceived(message);
}

void WebSocketClient::setClientRunning(bool isRunning)
{
    if (m_isClientRunning == isRunning) {
        return;
    }

    m_isClientRunning = isRunning;
    emit clientRunningChanged();
}
