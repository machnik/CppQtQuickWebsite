#ifndef BACKEND_H
#define BACKEND_H

#include <QtCore/QObject>
#include <QtCore/QString>

#include <QtQml/QQmlProperty>

#include "ListModel.h"

/*
    Simple C++ implementations for QML UIs can be gathered in one "backend" class.
    Backend is a singleton, so it is instantiated only once, automatically.
*/

class Backend : public QObject
{
    Q_OBJECT // Makes the class available to the Qt's meta-object system
    QML_ELEMENT // Makes the class available to QML
    QML_SINGLETON // Makes the class a singleton

    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(ListModel *listModel READ listModel CONSTANT)

    public:
        explicit Backend(QObject *parent = nullptr);

/*  
    Slots are automatically exposed to QML.
    The Q_INVOKABLE macro can be used to expose other methods (that are not slots) to QML.
*/

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
