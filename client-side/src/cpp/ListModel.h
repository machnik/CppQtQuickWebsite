#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QtCore/QAbstractListModel>

/*
    A simple list model that can be used in QML.
    Demonstrates how to create a custom model in C++.
    Models can also be defined in QML, but C++ models are more flexible and can be used
    in more complex scenarios.
    A model in this context is a data source that provides data to views.
*/

class ListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

public slots:
    void addItem(const QString &item);
    void removeItem(int index);
    void clear();

private:
    QList<QString> m_items;
};

#endif // LISTMODEL_H
