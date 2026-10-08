#include "BinaryStorage.h"

#include <QtCore/QDebug>

// Use a specific group to organize all file data
static const auto FILES_GROUP{QStringLiteral("files")};

namespace {
QSettings::Format defaultStorageFormat()
{
    // QSettings maps these formats onto browser storage in WASM, while native
    // builds use an ordinary INI file to demonstrate the platform difference.
#ifdef Q_OS_WASM
    return QSettings::WebLocalStorageFormat;
#else
    return QSettings::IniFormat;
#endif
}
}

BinaryStorage::BinaryStorage(QObject *parent)
    : QObject{parent}
    , m_currentFormat{defaultStorageFormat()}
    , m_settings {
        std::make_unique<QSettings>(
            m_currentFormat,
            QSettings::UserScope, 
            QStringLiteral("CppQtQuickWebsite"), 
            QStringLiteral("FileStorage")
        )
    }
{
}

QByteArray BinaryStorage::file(const QString &fileName) const
{
    if (fileName.isEmpty()) {
        return QByteArray{};
    }

    // A group keeps this demo's entries namespaced inside the application's
    // settings instead of mixing them with unrelated preferences.
    m_settings->beginGroup(FILES_GROUP);
    auto data{m_settings->value(fileName).toByteArray()};
    m_settings->endGroup();

    return data;
}

bool BinaryStorage::setFile(const QString &fileName, const QByteArray &data)
{
    if (fileName.isEmpty()) {
        return false;
    }

    m_settings->beginGroup(FILES_GROUP);
    m_settings->setValue(fileName, data);
    m_settings->endGroup();

    return syncSettings();
}

bool BinaryStorage::removeFile(const QString &fileName)
{
    if (fileName.isEmpty()) {
        return false;
    }

    m_settings->beginGroup(FILES_GROUP);
    m_settings->remove(fileName);
    m_settings->endGroup();

    return syncSettings();
}

bool BinaryStorage::hasFile(const QString &fileName) const
{
    if (fileName.isEmpty()) {
        return false;
    }

    m_settings->beginGroup(FILES_GROUP);
    auto exists{m_settings->contains(fileName)};
    m_settings->endGroup();

    return exists;
}

bool BinaryStorage::clearFiles()
{
    m_settings->beginGroup(FILES_GROUP);
    m_settings->clear();
    m_settings->endGroup();

    return syncSettings();
}

QStringList BinaryStorage::fileNames() const
{
    m_settings->beginGroup(FILES_GROUP);
    // allKeys() includes nested entries too, matching QSettings' key hierarchy.
    auto names{m_settings->allKeys()};
    m_settings->endGroup();

    return names;
}

qint64 BinaryStorage::fileSize(const QString &fileName) const
{
    if (fileName.isEmpty()) {
        return -1;
    }

    auto data{file(fileName)};
    return data.size();
}

bool BinaryStorage::isEmpty() const
{
    return fileNames().isEmpty();
}

QString BinaryStorage::fileAsString(const QString &fileName) const
{
    auto data{file(fileName)};
    return QString::fromUtf8(data);
}

bool BinaryStorage::setFileAsString(const QString &fileName, const QString &data)
{
    return setFile(fileName, data.toUtf8());
}

bool BinaryStorage::syncSettings()
{
    // QSettings may defer writes; sync() flushes them and status() lets QML
    // distinguish a persisted operation from a quota or I/O failure.
    m_settings->sync();
    const auto status{m_settings->status()};
    if (status != QSettings::NoError) {
        qWarning() << "BinaryStorage could not sync QSettings data; status:" << status;
        return false;
    }

    return true;
}

void BinaryStorage::switchToWebLocalStorage()
{
#ifdef Q_OS_WASM
    if (m_currentFormat != QSettings::WebLocalStorageFormat) {
        m_currentFormat = QSettings::WebLocalStorageFormat;
        recreateSettings();
    }
#endif
}

void BinaryStorage::switchToWebIndexedDB()
{
#ifdef Q_OS_WASM
    if (m_currentFormat != QSettings::WebIndexedDBFormat) {
        m_currentFormat = QSettings::WebIndexedDBFormat;
        recreateSettings();
    }
#endif
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
