#include "Base64Converter.h"

#include <QtCore/QFile>
#include <QtCore/QByteArray>
#include <QtCore/QBuffer>
#include <QtCore/QTextStream>

Base64Converter::Base64Converter(QObject *parent) : QObject(parent)
{
}

QString Base64Converter::convertFileToBase64(const QString &filePath)
{
    QFile file {filePath};

    if (!file.open(QIODevice::ReadOnly)) {
        // TODO: Why does this not work?
        return QString();
    }

    auto fileData = file.readAll();

    return QString(fileData.toBase64());
}
