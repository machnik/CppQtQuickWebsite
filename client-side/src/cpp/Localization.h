#ifndef LOCALIZATION_H
#define LOCALIZATION_H

#include <QtCore/QHash>
#include <QtCore/QObject>
#include <QtCore/QLocale>

#include <QtQml/QtQml>

/*
    A very lightweight alternative to Qt's built-in localization system.
    This class is a singleton, so it is instantiated only once, automatically.
*/

class Localization : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    // NOTIFY allows QML bindings to update when the selected translation map changes.
    Q_PROPERTY(QLocale::Language currentLanguage READ currentLanguage NOTIFY languageChanged)

public:
    explicit Localization(QObject *parent = nullptr);
    ~Localization() override;

    Q_INVOKABLE QLocale::Language currentLanguage() const;
    Q_INVOKABLE void setLanguage(QLocale::Language language);

    Q_INVOKABLE QString string(const QString &key) const; // Returns the localized string for the given key.
    static QString strCpp(const QString &key); // Convenience method with functionality similar to Qt's tr().

signals:
    void languageChanged();

private:
    QLocale::Language m_currentLanguage;
    QHash<QString, QString> m_localStrings;

    static Localization *s_instance;
};

#endif // LOCALIZATION_H
