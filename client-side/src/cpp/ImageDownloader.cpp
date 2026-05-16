#include "ImageDownloader.h"

#include <QtCore/QUrl>

ImageDownloader* ImageDownloader::s_instance = nullptr;

ImageDownloader::ImageDownloader(QObject *parent)
    : QObject {parent}
    , m_networkManager {new QNetworkAccessManager(this)}
    , m_currentReply {nullptr}
{
    s_instance = this;
}

void ImageDownloader::downloadImage(const QString &url)
{
    if (url.isEmpty()) {
        emit downloadError("URL is empty!");
        return;
    }

    if (m_currentReply) {
        auto previousReply{m_currentReply};
        m_currentReply = nullptr;
        previousReply->abort();
        previousReply->deleteLater();
    }

    QUrl downloadUrl{url};
    if (!downloadUrl.isValid()) {
        emit downloadError("Invalid URL: " + url);
        return;
    }

    emit downloadStarted();

    QNetworkRequest request{downloadUrl};
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    m_currentReply = m_networkManager->get(request);

    connect(m_currentReply, &QNetworkReply::finished, this, &ImageDownloader::onDownloadFinished);
    connect(m_currentReply, &QNetworkReply::downloadProgress, this, &ImageDownloader::onDownloadProgress);
    connect(m_currentReply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::errorOccurred),
            this, &ImageDownloader::onDownloadError);
}

void ImageDownloader::onDownloadFinished()
{
    auto reply{qobject_cast<QNetworkReply *>(sender())};
    if (!reply || reply != m_currentReply) {
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        clearReply(reply);
        return;
    }

    auto imageData{reply->readAll()};
    if (imageData.isEmpty()) {
        emit downloadError("Downloaded data is empty");
        clearReply(reply);
        return;
    }

    auto contentType{reply->header(QNetworkRequest::ContentTypeHeader).toString()};
    if (!contentType.startsWith("image/")) {
        contentType = guessMimeType(reply->url().toString());
    }

    emit downloadFinished(convertToDataUrl(imageData, contentType));
    clearReply(reply);
}

void ImageDownloader::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    auto reply{qobject_cast<QNetworkReply *>(sender())};
    if (!reply || reply != m_currentReply) {
        return;
    }

    if (bytesTotal > 0) {
        emit downloadProgress(static_cast<int>(bytesReceived), static_cast<int>(bytesTotal));
    }
}

void ImageDownloader::onDownloadError(QNetworkReply::NetworkError error)
{
    auto reply{qobject_cast<QNetworkReply *>(sender())};
    if (!reply || reply != m_currentReply) {
        return;
    }

    Q_UNUSED(error)

    auto errorString{reply->errorString()};
    emit downloadError("Network error: " + errorString);
    clearReply(reply);
}

QString ImageDownloader::convertToDataUrl(const QByteArray &imageData, const QString &mimeType)
{
    auto base64Data{imageData.toBase64()};
    return QString("data:%1;base64,%2").arg(mimeType, base64Data);
}

QString ImageDownloader::guessMimeType(const QString &url)
{
    QUrl qurl(url);
    auto path{qurl.path().toLower()};
    
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
    
    return "image/jpeg";
}

void ImageDownloader::clearReply(QNetworkReply *reply)
{
    if (!reply) {
        return;
    }

    if (reply == m_currentReply) {
        m_currentReply = nullptr;
    }

    reply->deleteLater();
    }
