#include "WebSocketClient.h"

#include <QAbstractSocket>

WebSocketClient::WebSocketClient(QObject *parent) :
    QObject(parent),
    m_isClientRunning(false)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketClient::onTextMessageReceived);
}

void WebSocketClient::startClient(const QString & url)
{
    m_webSocket.open(QUrl(url));
    if (m_webSocket.error() != QAbstractSocket::SocketError::UnknownSocketError) {
        emit errorOccurred(m_webSocket.errorString());
    } else {
        m_isClientRunning = true;
        emit clientRunningChanged();
    }
}

void WebSocketClient::stopClient()
{
    m_webSocket.close();
    m_isClientRunning = false;
    emit clientRunningChanged();
}

bool WebSocketClient::isClientRunning() const
{
    return m_isClientRunning;
}

void WebSocketClient::sendMessage(const QString & message)
{
    m_webSocket.sendTextMessage(message);
}

void WebSocketClient::onConnected()
{
    m_webSocket.sendTextMessage(QStringLiteral("[server is running]"));
}

void WebSocketClient::onTextMessageReceived(const QString & message)
{
    emit messageReceived(message);
}
