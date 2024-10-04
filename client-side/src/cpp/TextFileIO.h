#ifndef TEXTFILEIO_H
#define TEXTFILEIO_H

#include <QtCore/QObject>
#include <QtWidgets/QFileDialog>
#include <QtQml/QtQml>

class TextFileIO : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit TextFileIO(QObject *parent = nullptr);

/*
    WebAssembly does not have direct access to the local file system, but it can access
    (read and write) local files using the browser's file dialog.
*/

public slots:
    void loadFileContent();
    void saveFileContent(const QString &fileName, const QString &content);

signals:
    void fileContentReady(const QString &content);
    void currentFileNameChanged(const QString &fileName);
};

#endif // TEXTFILEIO_H
