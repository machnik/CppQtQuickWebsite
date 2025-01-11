#include "Localization.h"

#include <QtCore/QFile>

#include <QtCore/QJsonArray>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>

#include <QtCore/QSettings>

Localization* Localization::s_instance = nullptr;

Localization::Localization(QObject *parent)
    : QObject(parent)
    , m_currentLanguage(QLocale::English)
{
    s_instance = this;
}

QLocale::Language Localization::currentLanguage() const
{
    return m_currentLanguage;
}

void Localization::setLanguage(QLocale::Language language)
{
    if (m_currentLanguage != language) {

        m_currentLanguage = language;

        m_localStrings.clear();

        QString languageCode = QLocale(language).name();

        QFile jsonFile{ QString(":/resources/translation/local_strings_%1.json").arg(languageCode) };
        jsonFile.open(QIODevice::ReadOnly);
        QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonFile.readAll());
        QJsonObject translations = jsonDocument.object();

        for (auto it = translations.begin(); it != translations.end(); ++it) {
            m_localStrings[it.key()] = it.value().toString();
        }
    }
}

QString Localization::string(const QString & key) const
{
    auto it = m_localStrings.find(key);
    auto translation = (it != m_localStrings.end()) ? it->second : key;
    return translation;
}

QString Localization::strCpp(const QString & key)
{
    if (!s_instance) {
        return key;
    }

    return s_instance->string(key);
}
