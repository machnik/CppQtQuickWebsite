#include "Base64Converter.h"

#include <QtCore/QFile>
#include <QtCore/QByteArray>
#include <QtCore/QTextStream>

Base64Converter::Base64Converter(QObject *parent) : QObject(parent)
{
}

QString Base64Converter::convertFileToBase64(const QString &filePath)
{
    QFile file {filePath};
    QString base64String;

    if (file.open(QIODevice::ReadOnly)) {
        base64String = QString(file.readAll().toBase64());
    }

    return base64String;
}
