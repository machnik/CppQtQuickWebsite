
#include <QtWebSockets/QWebSocketServer>

class WebSocketServer : public QObject
{
    Q_OBJECT
public:
    explicit WebSocketServer(QObject * parent = nullptr);
    Q_INVOKABLE void startServer(int port);
signals:
    void errorOccurred(const QString & error);
    void bouncedMessage(const QString & message);
private slots:
    void onNewConnection();
    void processTextMessage(const QString & message);
    void socketDisconnected();
private:
    QWebSocketServer * m_webSocketServer;
};
