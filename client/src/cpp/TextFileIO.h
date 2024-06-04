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

public slots:
    void loadFileContent();
    void saveFileContent(const QString &content);

signals:
    void fileContentReady(const QString &content);
};

#endif // TEXTFILEIO_H
