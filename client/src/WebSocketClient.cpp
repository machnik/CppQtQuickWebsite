#include "WebSocketClient.h"

WebSocketClient::WebSocketClient(QObject *parent) :
    QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketClient::onTextMessageReceived);
}

void WebSocketClient::startClient(const QString & url)
{
    m_webSocket.open(QUrl(url));
}

void WebSocketClient::sendMessage(const QString & message)
{
    m_webSocket.sendTextMessage(message);
}

void WebSocketClient::onConnected()
{
    m_webSocket.sendTextMessage(QStringLiteral("Hello, server!"));
}

void WebSocketClient::onTextMessageReceived(const QString & message)
{
    emit messageReceived(message);
}
