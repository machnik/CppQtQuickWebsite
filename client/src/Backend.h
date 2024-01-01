#ifndef BACKEND_H
#define BACKEND_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtQml/QQmlProperty>

#include "ListModel.h"

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(ListModel *listModel READ listModel CONSTANT)

    public:
        explicit Backend(QObject *parent = nullptr);

        Q_INVOKABLE QString message() const;
        Q_INVOKABLE ListModel *listModel() const;

    public slots:
        void setMessage(const QString &message);
        void resetInputField(QObject* textField);

    signals:
        void messageChanged();
        void listModelChanged();

    private:
        QString m_message;
        ListModel * const m_listModel;
};

#endif // BACKEND_H
