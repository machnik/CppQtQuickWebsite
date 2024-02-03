#include <QtWebSockets/QWebSocket>

class WebSocketClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isClientRunning READ isClientRunning NOTIFY clientRunningChanged)
public:
    explicit WebSocketClient(QObject * parent = nullptr);
    Q_INVOKABLE void startClient(const QString &url);
    Q_INVOKABLE void stopClient(); 
    bool isClientRunning() const;
    Q_INVOKABLE void sendMessage(const QString &message);
signals:
    void errorOccurred(const QString & error);
    void messageReceived(const QString & message);
    void clientRunningChanged();
private slots:
    void onConnected();
    void onTextMessageReceived(const QString & message);
private:
    QWebSocket m_webSocket;
    bool m_isClientRunning;
};
