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

    Q_PROPERTY(QLocale::Language currentLanguage READ currentLanguage NOTIFY currentLanguageChanged)

public:
    explicit Localization(QObject *parent = nullptr);

    Q_INVOKABLE QLocale::Language currentLanguage() const;
    Q_INVOKABLE void setLanguage(QLocale::Language language);

    Q_INVOKABLE QString string(const QString &key) const;

signals:
    void currentLanguageChanged();

private:
    QLocale::Language m_currentLanguage;
    std::map<QString, QString> m_localStrings;
};

#endif // LOCALIZATION_H
