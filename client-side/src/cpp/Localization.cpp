#include "Localization.h"

#include <QtCore/QFile>

#include <QtCore/QJsonArray>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>

#include <QtCore/QSettings>

Localization::Localization(QObject *parent)
    : QObject(parent)
    , m_currentLanguage(QLocale::English)
{
    QSettings settings;
    if (settings.contains("language")) {
        m_currentLanguage = static_cast<QLocale::Language>(settings.value("language").toInt());
    }
}

QLocale::Language Localization::currentLanguage() const
{
    return m_currentLanguage;
}

void Localization::setLanguage(QLocale::Language language)
{
    if (m_currentLanguage != language) {

        m_currentLanguage = language;

        QSettings settings;
        settings.setValue("language", static_cast<int>(language));

        m_localStrings.clear();

        QString languageCode = QLocale(language).name();
        QString filename = QString(":/translation/local_strings_%1.json").arg(languageCode);
        QJsonDocument jsonDocument = QJsonDocument::fromJson(QFile(filename).readAll());
        QJsonObject translations = jsonDocument.object();

        for (auto it = translations.begin(); it != translations.end(); ++it) {
            m_localStrings[it.key()] = it.value().toString();
        }

        emit currentLanguageChanged();
    }
}

QString Localization::string(const QString & key) const
{
    auto it = m_localStrings.find(key);
    return (it != m_localStrings.end()) ? it->second : key;
}
