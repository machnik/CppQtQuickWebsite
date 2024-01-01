#include "Backend.h"

Backend::Backend(QObject *parent) : QObject(parent), m_listModel(new ListModel(this))
{
}

QString Backend::message() const
{
    return m_message;
}

ListModel *Backend::listModel() const
{
    return m_listModel;
}

void Backend::setMessage(const QString &message)
{
    if (message == m_message)
        return;

    m_message = message;
    emit messageChanged();
}

void Backend::resetInputField(QObject* textField)
{
    QQmlProperty::write(textField, "text", "Text set using C++.");
}
