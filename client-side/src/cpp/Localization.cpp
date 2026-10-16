#include "Localization.h"

#include <QtCore/QDebug>
#include <QtCore/QFile>

#include <QtCore/QJsonArray>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>
#include <QtCore/QJsonParseError>

#include <QtCore/QSettings>

Localization* Localization::s_instance = nullptr;

Localization::Localization(QObject *parent)
    : QObject{parent}
    , m_currentLanguage{QLocale::English}
{
    s_instance = this;
}

Localization::~Localization()
{
    if (s_instance == this) {
        s_instance = nullptr;
    }
}

QLocale::Language Localization::currentLanguage() const
{
    return m_currentLanguage;
}

void Localization::setLanguage(QLocale::Language language)
{
    if (m_currentLanguage == language) {
        return;
    }

    // Locale::name() produces the resource naming convention used by the
    // JSON files (for example, de_DE).
    auto languageCode{QLocale{language}.name()};

    QFile jsonFile{QString(":/resources/translation/local_strings_%1.json").arg(languageCode)};

    if (!jsonFile.open(QIODevice::ReadOnly)) {
        // Keep the previous language active rather than degrading the UI to
        // untranslated keys when the file is missing.
        qWarning() << "Could not open translation file:" << jsonFile.fileName();
        return;
    }

    QJsonParseError parseError;
    const auto jsonDocument{QJsonDocument::fromJson(jsonFile.readAll(), &parseError)};
    if (parseError.error != QJsonParseError::NoError || !jsonDocument.isObject()) {
        qWarning() << "Could not parse translation file:" << jsonFile.fileName() << parseError.errorString();
        return;
    }

    const auto translations{jsonDocument.object()};

    m_currentLanguage = language;
    m_localStrings.clear();

    for (auto it{translations.begin()}; it != translations.end(); ++it) {
        m_localStrings[it.key()] = it.value().toString();
    }

    emit languageChanged();
}

QString Localization::string(const QString & key) const
{
    // Showing the source key when a translation is missing keeps the UI usable
    // and makes untranslated strings obvious during development.
    auto it{m_localStrings.constFind(key)};
    const auto translation{(it != m_localStrings.constEnd()) ? it.value() : key};
    return translation;
}

QString Localization::strCpp(const QString & key)
{
    if (!s_instance) {
        return key;
    }

    return s_instance->string(key);
}
