#include "ImageDownloader.h"

#include <QtCore/QDebug>
#include <QtCore/QMimeDatabase>
#include <QtCore/QUrl>

ImageDownloader* ImageDownloader::s_instance = nullptr;

ImageDownloader::ImageDownloader(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_currentReply(nullptr)
{
    s_instance = this;
}

void ImageDownloader::downloadImage(const QString &url)
{
    if (url.isEmpty()) {
        emit downloadError("URL is empty");
        return;
    }
    
    // Cancel any existing download
    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply->deleteLater();
        m_currentReply = nullptr;
    }
    
    QUrl downloadUrl(url);
    if (!downloadUrl.isValid()) {
        emit downloadError("Invalid URL: " + url);
        return;
    }
    
    qDebug() << "ImageDownloader: Starting download from" << url;
    emit downloadStarted();
    
    QNetworkRequest request(downloadUrl);
    request.setHeader(QNetworkRequest::UserAgentHeader, "CppQtQuickWebsite/1.0");
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);
    
    m_currentReply = m_networkManager->get(request);
    
    connect(m_currentReply, &QNetworkReply::finished, this, &ImageDownloader::onDownloadFinished);
    connect(m_currentReply, &QNetworkReply::downloadProgress, this, &ImageDownloader::onDownloadProgress);
    connect(m_currentReply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::errorOccurred),
            this, &ImageDownloader::onDownloadError);
}

void ImageDownloader::downloadDemoImage()
{
    // Use a reliable demo image service
    downloadImage("https://picsum.photos/400/300");
}

void ImageDownloader::onDownloadFinished()
{
    if (!m_currentReply) {
        return;
    }
    
    if (m_currentReply->error() == QNetworkReply::NoError) {
        QByteArray imageData = m_currentReply->readAll();
        QString contentType = m_currentReply->header(QNetworkRequest::ContentTypeHeader).toString();
        
        if (imageData.isEmpty()) {
            emit downloadError("Downloaded data is empty");
        } else if (!contentType.startsWith("image/")) {
            // Guess MIME type from URL if Content-Type header is not reliable
            QString url = m_currentReply->url().toString();
            contentType = guessMimeType(url);
            
            if (!contentType.startsWith("image/")) {
                contentType = "image/jpeg"; // Default fallback
            }
        }
        
        QString dataUrl = convertToDataUrl(imageData, contentType);
        qDebug() << "ImageDownloader: Download completed, data URL length:" << dataUrl.length();
        emit downloadFinished(dataUrl);
    }
    
    m_currentReply->deleteLater();
    m_currentReply = nullptr;
}

void ImageDownloader::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    if (bytesTotal > 0) {
        emit downloadProgress(static_cast<int>(bytesReceived), static_cast<int>(bytesTotal));
    }
}

void ImageDownloader::onDownloadError(QNetworkReply::NetworkError error)
{
    if (!m_currentReply) {
        return;
    }
    
    QString errorString = m_currentReply->errorString();
    qWarning() << "ImageDownloader: Network error:" << error << errorString;
    emit downloadError("Network error: " + errorString);
    
    m_currentReply->deleteLater();
    m_currentReply = nullptr;
}

QString ImageDownloader::convertToDataUrl(const QByteArray &imageData, const QString &mimeType)
{
    QString base64Data = imageData.toBase64();
    return QString("data:%1;base64,%2").arg(mimeType, base64Data);
}

QString ImageDownloader::guessMimeType(const QString &url)
{
    QUrl qurl(url);
    QString path = qurl.path().toLower();
    
    if (path.endsWith(".jpg") || path.endsWith(".jpeg")) {
        return "image/jpeg";
    } else if (path.endsWith(".png")) {
        return "image/png";
    } else if (path.endsWith(".gif")) {
        return "image/gif";
    } else if (path.endsWith(".webp")) {
        return "image/webp";
    } else if (path.endsWith(".bmp")) {
        return "image/bmp";
    } else if (path.endsWith(".svg")) {
        return "image/svg+xml";
    }
    
    return "image/jpeg"; // Default fallback
}
