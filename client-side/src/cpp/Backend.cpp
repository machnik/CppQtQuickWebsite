#include "Backend.h"

#include <QtCore/QFile>
#include <QtCore/QTextStream>

Backend::Backend(QObject *parent) : QObject(parent), m_listModel(new ListModel(this))
{
    m_listModel->addItem("C++ Item 1");
    m_listModel->addItem("C++ Item 2");
    m_listModel->addItem("C++ Item 3");
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

    QFile file(":/resources/text/" + resourceName);
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        text = in.readAll();
    }

    return text;
}

void Backend::setMessage(const QString &message)
{
    if (message == m_message) {
        return;
    }

    m_message = message;
    emit messageChanged();
}

void Backend::resetInputField(QObject* textField)
{
    QQmlProperty::write(textField, "text", "Text set using C++.");
}
