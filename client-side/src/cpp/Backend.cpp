#include "Backend.h"

#include <QtCore/QFile>
#include <QtCore/QDebug>
#include <QtCore/QTextStream>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include "Localization.h"

#ifndef CPP_QT_QUICK_WEBSITE_VERSION
#define CPP_QT_QUICK_WEBSITE_VERSION "1.1.4"
#endif

Backend::Backend(QObject *parent)
    : QObject{parent}
    , m_listModel{new ListModel{this}}
{
    resetBackend();
}

void Backend::reloadQML()
{
    auto appEngine{qobject_cast<QQmlApplicationEngine *>(QQmlEngine::contextForObject(this)->engine())};
    if (appEngine) {
        appEngine->clearComponentCache();
        appEngine->load(":/qml/main.qml");
    }
}

void Backend::resetBackend()
{
    m_message.clear();

    m_listModel->clear();

    m_listModel->addItem(Localization::strCpp("C++ Item %1").arg(1));
    m_listModel->addItem(Localization::strCpp("C++ Item %1").arg(2));
    m_listModel->addItem(Localization::strCpp("C++ Item %1").arg(3));
}

QString Backend::message() const
{
    return m_message;
}

ListModel *Backend::listModel() const
{
    return m_listModel;
}

QString Backend::textResource(const QString &resourceName) const
{
    QString text;

    QFile file{":/resources/text/" + resourceName};
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in{&file};
        text = in.readAll();
    }

    return text;
}

QString Backend::version() const
{
    return QString::fromLatin1(CPP_QT_QUICK_WEBSITE_VERSION);
}

void Backend::setMessage(const QString &message)
{
    if (message == m_message) {
        return;
    }

    m_message = message;
    emit messageChanged();
}

void Backend::resetInputField(QObject *textField)
{
    if (!textField) {
        return;
    }

    QQmlProperty textProperty{textField, QStringLiteral("text")};
    if (!textProperty.isValid() || !textProperty.isWritable()) {
        qWarning() << "Backend::resetInputField expected a writable 'text' property on" << textField;
        return;
    }

    textProperty.write(Localization::strCpp("Text set using C++."));
}
