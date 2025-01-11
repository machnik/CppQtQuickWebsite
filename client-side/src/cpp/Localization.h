#ifndef LOCALIZATION_H
#define LOCALIZATION_H

#include <QtCore/QObject>
#include <QtCore/QLocale>

#include <QtQml/QtQml>

#include <map>

/*
    A very lightweight alternative to Qt's built-in localization system.
    This class is a singleton, so it is instantiated only once, automatically.
*/

class Localization : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QLocale::Language currentLanguage READ currentLanguage)

public:
    explicit Localization(QObject *parent = nullptr);

    Q_INVOKABLE QLocale::Language currentLanguage() const;
    Q_INVOKABLE void setLanguage(QLocale::Language language);

    Q_INVOKABLE QString string(const QString &key) const; // Returns the localized string for the given key.
    static QString strCpp(const QString &key); // Convenience method with functionality similar to Qt's tr().

private:
    QLocale::Language m_currentLanguage;
    std::map<QString, QString> m_localStrings;

    static Localization *s_instance;
};

#endif // LOCALIZATION_H
