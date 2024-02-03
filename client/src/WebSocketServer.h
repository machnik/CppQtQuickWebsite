
#include <QtWebSockets/QWebSocketServer>

class WebSocketServer : public QObject
{
    Q_OBJECT
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
