#ifndef SYSTEMINFORMATION_H
#define SYSTEMINFORMATION_H

#include <QtCore/QObject>
#include <QtCore/QSysInfo>

#include <QtQml/QtQml>

class SystemInformation : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString bootUniqueId READ bootUniqueId CONSTANT)
    Q_PROPERTY(QString buildAbi READ buildAbi CONSTANT)
    Q_PROPERTY(QString buildCpuArchitecture READ buildCpuArchitecture CONSTANT)
    Q_PROPERTY(QString currentCpuArchitecture READ currentCpuArchitecture CONSTANT)
    Q_PROPERTY(QString kernelType READ kernelType CONSTANT)
    Q_PROPERTY(QString kernelVersion READ kernelVersion CONSTANT)
    Q_PROPERTY(QString machineHostName READ machineHostName CONSTANT)
    Q_PROPERTY(QString machineUniqueId READ machineUniqueId CONSTANT)
    Q_PROPERTY(QString prettyProductName READ prettyProductName CONSTANT)
    Q_PROPERTY(QString productType READ productType CONSTANT)
    Q_PROPERTY(QString productVersion READ productVersion CONSTANT)

public:
    explicit SystemInformation(QObject *parent = nullptr);

    QString bootUniqueId() const;
    QString buildAbi() const;
    QString buildCpuArchitecture() const;
    QString currentCpuArchitecture() const;
    QString kernelType() const;
    QString kernelVersion() const;
    QString machineHostName() const;
    QString machineUniqueId() const;
    QString prettyProductName() const;
    QString productType() const;
    QString productVersion() const;
};

#endif // SYSTEMINFORMATION_H
