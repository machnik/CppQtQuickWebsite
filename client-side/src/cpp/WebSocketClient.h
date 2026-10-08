#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QtNetwork/QAbstractSocket>
#include <QtWebSockets/QWebSocket>

#include <QtQml>

/*
    A simple WebSocket client that can be used in QML.
    A singleton, so it is instantiated only once, automatically.
*/

class WebSocketClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool isClientRunning READ isClientRunning NOTIFY clientRunningChanged)
    Q_PROPERTY(bool isClientConnecting READ isClientConnecting NOTIFY clientStateChanged)
    Q_PROPERTY(bool isClientActive READ isClientActive NOTIFY clientStateChanged)
public:
    explicit WebSocketClient(QObject * parent = nullptr);
    Q_INVOKABLE void startClient(const QString &url);
    Q_INVOKABLE void stopClient(); 
    bool isClientRunning() const;
    bool isClientConnecting() const;
    bool isClientActive() const;
    Q_INVOKABLE void sendMessage(const QString &message);
signals:
    void errorOccurred(const QString & error);
    void messageReceived(const QString & message);
    void clientRunningChanged();
    void clientStateChanged();
private slots:
    void onConnected();
    void onDisconnected();
    void onErrorOccurred(QAbstractSocket::SocketError error);
    void onTextMessageReceived(const QString & message);
private:
    void setClientRunning(bool isRunning);

    QWebSocket m_webSocket;
    bool m_isClientRunning;
};

#endif // WEBSOCKETCLIENT_H
