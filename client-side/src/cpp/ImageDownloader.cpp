#include "ImageDownloader.h"

#include <QtCore/QUrl>

namespace {
constexpr qint64 MaxImageBytes{10 * 1024 * 1024};
constexpr int DownloadTimeoutMilliseconds{30'000};
}

ImageDownloader::ImageDownloader(QObject *parent)
    : QObject {parent}
    , m_networkManager {new QNetworkAccessManager(this)}
    , m_currentReply {nullptr}
{
}

void ImageDownloader::downloadImage(const QString &url)
{
    if (url.isEmpty()) {
        emit downloadError("URL is empty!");
        return;
    }

    if (m_currentReply) {
        // This singleton handles one download at a time. Abort the old reply
        // and ignore its later signals before starting the replacement request.
        auto previousReply{m_currentReply};
        m_currentReply = nullptr;
        previousReply->abort();
        previousReply->deleteLater();
    }

    QUrl downloadUrl{url.trimmed()};
    if (!downloadUrl.isValid() || (downloadUrl.scheme() != "http" && downloadUrl.scheme() != "https")) {
        emit downloadError("Invalid URL: " + url);
        return;
    }

    emit downloadStarted();

    QNetworkRequest request{downloadUrl};
    // Don't follow redirects that downgrade an HTTPS request to plain HTTP.
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);
    request.setTransferTimeout(DownloadTimeoutMilliseconds);

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

    // Check the declared length early, then check the actual payload below:
    // servers may omit or misstate Content-Length.
    const auto contentLength{reply->header(QNetworkRequest::ContentLengthHeader).toLongLong()};
    if (contentLength > MaxImageBytes) {
        emit downloadError("Downloaded image exceeds the size limit.");
        clearReply(reply);
        return;
    }

    auto imageData{reply->readAll()};
    if (imageData.isEmpty()) {
        emit downloadError("Downloaded data is empty");
        clearReply(reply);
        return;
    }

    if (imageData.size() > MaxImageBytes) {
        emit downloadError("Downloaded image exceeds the size limit.");
        clearReply(reply);
        return;
    }

    // Prefer the server's declared MIME type. Only infer from the URL when the
    // server provides no useful type, rather than overriding a conflicting one.
    auto contentType{normalizedMimeType(reply->header(QNetworkRequest::ContentTypeHeader).toString())};
    if (contentType.isEmpty() || contentType == "application/octet-stream") {
        contentType = guessMimeType(reply->url().toString());
    }

    if (!isSupportedImageMimeType(contentType)) {
        emit downloadError("Downloaded content is not a supported image.");
        clearReply(reply);
        return;
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

    if (bytesReceived > MaxImageBytes || bytesTotal > MaxImageBytes) {
        emit downloadError("Downloaded image exceeds the size limit.");
        reply->abort();
        clearReply(reply);
        return;
    }

    if (bytesTotal > 0) {
        emit downloadProgress(bytesReceived, bytesTotal);
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
    }
    
    return QString{};
}

bool ImageDownloader::isSupportedImageMimeType(const QString &mimeType)
{
    static const QStringList supportedMimeTypes{
        "image/bmp",
        "image/gif",
        "image/jpeg",
        "image/png",
        "image/webp"
    };

    return supportedMimeTypes.contains(normalizedMimeType(mimeType));
}

QString ImageDownloader::normalizedMimeType(const QString &mimeType)
{
    return mimeType.section(';', 0, 0).trimmed().toLower();
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
