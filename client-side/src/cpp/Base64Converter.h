#ifndef BASE64CONVERTER_H
#define BASE64CONVERTER_H

#include <QtCore/QObject>
#include <QtCore/QString>

#include <QtQml/QtQml>

/*
    A simple class that contains a method to convert a file to a Base64 string.
    A singleton, so it is instantiated only once, automatically.
*/

class Base64Converter : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Base64Converter(QObject *parent = nullptr);

    Q_INVOKABLE QString convertFileToBase64(const QString &filePath);
};

#endif // BASE64CONVERTER_H
