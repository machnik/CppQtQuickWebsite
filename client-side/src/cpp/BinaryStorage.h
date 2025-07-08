#ifndef BINARY_STORAGE_H
#define BINARY_STORAGE_H

#include <QtCore/QByteArray>
#include <QtCore/QObject>
#include <QtCore/QSettings>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <memory>

#include <QtQml/QtQml>

/*
    Use QSettings with WebIndexedDBFormat to store binary data in IndexedDB
    when running in a browser, or IniFormat when running as a desktop application.
    This class is a singleton, so it is instantiated only once, automatically.
*/

class BinaryStorage : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit BinaryStorage(QObject *parent = nullptr);

    Q_INVOKABLE QByteArray file(const QString &fileName) const;
    Q_INVOKABLE void setFile(const QString &fileName, const QByteArray &data);
    Q_INVOKABLE void removeFile(const QString &fileName);
    Q_INVOKABLE bool hasFile(const QString &fileName) const;
    Q_INVOKABLE void clearFiles();
    Q_INVOKABLE QStringList fileNames() const;
    Q_INVOKABLE qint64 fileSize(const QString &fileName) const;
    Q_INVOKABLE bool isEmpty() const;
    
    // Convenience methods for working with strings (like data URLs)
    Q_INVOKABLE QString fileAsString(const QString &fileName) const;
    Q_INVOKABLE void setFileAsString(const QString &fileName, const QString &data);
    
    // Storage format switching methods
    Q_INVOKABLE void switchToWebLocalStorage();
    Q_INVOKABLE void switchToWebIndexedDB();

private:
    void recreateSettings();
    
    QSettings::Format m_currentFormat;
    mutable std::unique_ptr<QSettings> m_settings;
};

#endif // BINARY_STORAGE_H
