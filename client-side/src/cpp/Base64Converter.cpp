#include "Base64Converter.h"

#include <QtCore/QDebug>
#include <QtCore/QFile>

Base64Converter::Base64Converter(QObject *parent)
    : QObject{parent}
{
}

QString Base64Converter::convertFileToBase64(const QString &filePath)
{
    // Encoding a bundled resource as a data URL is a simple bridge to browser
    // APIs that cannot resolve Qt's qrc:/ resource URLs directly.
    QFile file{filePath};
    QString base64String;

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Base64Converter could not open file:" << filePath;
        return base64String;
    }

    base64String = QString{file.readAll().toBase64()};

    return base64String;
}
