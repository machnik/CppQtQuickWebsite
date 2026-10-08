#ifndef IMAGE_DOWNLOADER_H
#define IMAGE_DOWNLOADER_H

#include <QtCore/QObject>
#include <QtCore/QByteArray>
#include <QtCore/QString>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>

#include <QtQml/QtQml>

/*
    A reliable image downloader using Qt's networking capabilities.
    This class is a singleton, so it is instantiated only once, automatically.
*/

class ImageDownloader : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit ImageDownloader(QObject *parent = nullptr);

    Q_INVOKABLE void downloadImage(const QString &url);

signals:
    // Signals separate network progress from the UI, allowing QML to react
    // without blocking while the QNetworkReply is active.
    void downloadStarted();
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(const QString &dataUrl);
    void downloadError(const QString &errorString);

private slots:
    void onDownloadFinished();
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onDownloadError(QNetworkReply::NetworkError error);

private:
    void clearReply(QNetworkReply *reply);
    static bool isSupportedImageMimeType(const QString &mimeType);
    static QString normalizedMimeType(const QString &mimeType);

    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_currentReply;
    
    QString convertToDataUrl(const QByteArray &imageData, const QString &mimeType);
    QString guessMimeType(const QString &url);
};

#endif // IMAGE_DOWNLOADER_H
