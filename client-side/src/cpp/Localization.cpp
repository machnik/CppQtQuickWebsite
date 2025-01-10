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
    qDebug() << "Setting language to" << language;

    if (m_currentLanguage != language) {

        qDebug() << "Changing language to" << language;

        m_currentLanguage = language;

        //QSettings settings;
        //settings.setValue("language", static_cast<int>(language));

        qDebug() << "Loading translations...";

        m_localStrings.clear();

        QString languageCode = QLocale(language).name();

        qDebug() << "Language code:" << languageCode;

        QFile jsonFile{ QString(":/resources/translation/local_strings_%1.json").arg(languageCode) };
        jsonFile.open(QIODevice::ReadOnly);
        QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonFile.readAll());
        QJsonObject translations = jsonDocument.object();

        qDebug() << "Translations:" << translations;

        for (auto it = translations.begin(); it != translations.end(); ++it) {
            qDebug() << "Setting - Key:" << it.key() << "Value:" << it.value().toString();
            m_localStrings[it.key()] = it.value().toString();
        }

        qDebug() << "Translations loaded.";

        emit currentLanguageChanged();
    }
}

QString Localization::string(const QString & key) const
{
    qDebug() << "Getting string for key:" << key;
    auto it = m_localStrings.find(key);
    auto translation = (it != m_localStrings.end()) ? it->second : key;
    qDebug() << "Translation:" << translation;
    return translation;
}
