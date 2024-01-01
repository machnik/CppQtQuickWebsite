#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QtCore/QAbstractListModel>

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

private:
    QList<QString> m_items;
};

#endif // LISTMODEL_H
