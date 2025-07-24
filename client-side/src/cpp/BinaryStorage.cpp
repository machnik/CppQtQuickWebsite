#include "BinaryStorage.h"
#include "BrowserJS.h"

#include <QtCore/QDebug>

// Use a specific group to organize all file data
static const QString FILES_GROUP = QStringLiteral("files");

BinaryStorage::BinaryStorage(QObject *parent)
    : QObject(parent)
    , m_currentFormat{QSettings::WebLocalStorageFormat}  // Default to WebLocalStorageFormat
    , m_settings {
        std::make_unique<QSettings>(
            m_currentFormat,
            QSettings::UserScope, 
            QStringLiteral("CppQtQuickWebsite"), 
            QStringLiteral("FileStorage")
        )
    }
{
    // QSettings will use WebLocalStorageFormat by default, can be switched to WebIndexedDBFormat
}

QByteArray BinaryStorage::file(const QString &fileName) const
{
    if (fileName.isEmpty()) {
        return QByteArray();
    }

    m_settings->beginGroup(FILES_GROUP);
    QByteArray data = m_settings->value(fileName).toByteArray();
    m_settings->endGroup();

    return data;
}

void BinaryStorage::setFile(const QString &fileName, const QByteArray &data)
{
    if (fileName.isEmpty()) {
        return;
    }

    m_settings->beginGroup(FILES_GROUP);
    m_settings->setValue(fileName, data);
    m_settings->endGroup();

    m_settings->sync();
}

void BinaryStorage::removeFile(const QString &fileName)
{
    if (fileName.isEmpty()) {
        return;
    }

    m_settings->beginGroup(FILES_GROUP);
    m_settings->remove(fileName);
    m_settings->endGroup();

    m_settings->sync();
}

bool BinaryStorage::hasFile(const QString &fileName) const
{
    if (fileName.isEmpty()) {
        return false;
    }

    m_settings->beginGroup(FILES_GROUP);
    bool exists = m_settings->contains(fileName);
    m_settings->endGroup();

    return exists;
}

void BinaryStorage::clearFiles()
{
    m_settings->beginGroup(FILES_GROUP);
    m_settings->clear();
    m_settings->endGroup();

    m_settings->sync();
}

QStringList BinaryStorage::fileNames() const
{
    m_settings->beginGroup(FILES_GROUP);
    QStringList names = m_settings->childKeys();
    m_settings->endGroup();

    return names;
}

qint64 BinaryStorage::fileSize(const QString &fileName) const
{
    if (fileName.isEmpty()) {
        return -1;
    }

    QByteArray data = file(fileName);
    return data.size();
}

bool BinaryStorage::isEmpty() const
{
    return fileNames().isEmpty();
}

QString BinaryStorage::fileAsString(const QString &fileName) const
{
    QByteArray data = file(fileName);
    return QString::fromUtf8(data);
}

void BinaryStorage::setFileAsString(const QString &fileName, const QString &data)
{
    setFile(fileName, data.toUtf8());
}

void BinaryStorage::switchToWebLocalStorage()
{
    if (m_currentFormat != QSettings::WebLocalStorageFormat) {
        m_currentFormat = QSettings::WebLocalStorageFormat;
        recreateSettings();
    }
}

void BinaryStorage::switchToWebIndexedDB()
{
    if (m_currentFormat != QSettings::WebIndexedDBFormat) {
        m_currentFormat = QSettings::WebIndexedDBFormat;
        recreateSettings();
    }
}

void BinaryStorage::recreateSettings()
{
    // Create a new QSettings instance with the new format
    m_settings = std::make_unique<QSettings>(
        m_currentFormat,
        QSettings::UserScope,
        QStringLiteral("CppQtQuickWebsite"), 
        QStringLiteral("FileStorage")
    );
}
