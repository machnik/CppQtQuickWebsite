#include "Backend.h"

#include <QtCore/QFile>
#include <QtCore/QDebug>
#include <QtCore/QPointer>
#include <QtCore/QTextStream>
#include <QtCore/QTimer>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include "Localization.h"

#ifndef CPP_QT_QUICK_WEBSITE_VERSION
#define CPP_QT_QUICK_WEBSITE_VERSION "1.1.6"
#endif

Backend::Backend(QObject *parent)
    : QObject{parent}
    , m_listModel{new ListModel{this}}
{
    resetBackend();
}

void Backend::reloadQML()
{
    if (m_reloadPending) {
        return;
    }

    auto context{QQmlEngine::contextForObject(this)};
    auto appEngine{context ? qobject_cast<QQmlApplicationEngine *>(context->engine()) : nullptr};
    if (!appEngine) {
        qWarning() << "Backend::reloadQML could not find the application QML engine.";
        return;
    }

    m_reloadPending = true;
    QPointer<QQmlApplicationEngine> guardedEngine{appEngine};

    QTimer::singleShot(0, this, [this, guardedEngine] {
        m_reloadPending = false;

        if (!guardedEngine) {
            return;
        }

        qDeleteAll(guardedEngine->rootObjects());
        guardedEngine->clearComponentCache();
        guardedEngine->load(":/qml/main.qml");
    });
}

void Backend::resetBackend()
{
    setMessage(QString{});

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
