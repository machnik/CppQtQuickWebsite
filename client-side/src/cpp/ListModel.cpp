#include "ListModel.h"

ListModel::ListModel(QObject *parent)
    : QAbstractListModel{parent}
{
}

int ListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_items.count();
}

QVariant ListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_items.count()) {
        return QVariant{};
    }

    const QString &item{m_items[index.row()]};
    if (role == Qt::DisplayRole) {
        return item;
    }

    return QVariant{};
}

void ListModel::addItem(const QString &item)
{
    // Views need begin/end notifications around storage changes to keep their
    // delegates and current indexes synchronized with the model.
    beginInsertRows(QModelIndex{}, rowCount(), rowCount());
    m_items << item;
    endInsertRows();
}

void ListModel::removeItem(int index)
{
    if (index < 0 || index >= m_items.count()) {
        return;
    }

    beginRemoveRows(QModelIndex{}, index, index);
    m_items.removeAt(index);
    endRemoveRows();
}

void ListModel::clear()
{
    if (m_items.isEmpty()) {
        return;
    }

    beginRemoveRows(QModelIndex{}, 0, m_items.count() - 1);
    m_items.clear();
    endRemoveRows();
}
