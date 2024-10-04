#ifndef WEBSOCKETSERVER_H
#define WEBSOCKETSERVER_H

#include <QtWebSockets/QWebSocketServer>

#include <QtQml>

/*
    A simple WebSocket server that can be used in QML.
    A singleton, so it is instantiated only once, automatically.
    WebSocket is a communication protocol that provides full-duplex communication channels
    over a single TCP connection.
*/

class WebSocketServer : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool isServerRunning READ isServerRunning NOTIFY serverRunningChanged)
public:
    explicit WebSocketServer(QObject * parent = nullptr);
    Q_INVOKABLE void startServer(int port);
    Q_INVOKABLE void stopServer();
    bool isServerRunning() const;
signals:
    void errorOccurred(const QString & error);
    void bouncedMessage(const QString & message);
    void serverRunningChanged();
private slots:
    void onNewConnection();
    void processTextMessage(const QString & message);
    void socketDisconnected();
private:
    QWebSocketServer * m_webSocketServer;
    bool m_isServerRunning;
};

#endif // WEBSOCKETSERVER_H
