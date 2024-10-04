#include "ListModel.h"

ListModel::ListModel(QObject *parent) : QAbstractListModel(parent)
{
}

int ListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_items.count();
}

QVariant ListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_items.count()) {
        return QVariant();
    }

    const QString &item = m_items[index.row()];
    if (role == Qt::DisplayRole) {
        return item;
    }

    return QVariant();
}

void ListModel::addItem(const QString &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_items << item;
    endInsertRows();
}

void ListModel::removeItem(int index)
{
    if (index < 0 || index >= m_items.count()) {
        return;
    }

    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
}
