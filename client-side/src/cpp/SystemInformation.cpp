#include "SystemInformation.h"

SystemInformation::SystemInformation(QObject *parent)
    : QObject(parent)
{
}

QString SystemInformation::bootUniqueId() const
{
    return QString(QSysInfo::bootUniqueId());
}

QString SystemInformation::buildAbi() const
{
    return QSysInfo::buildAbi();
}

QString SystemInformation::buildCpuArchitecture() const
{
    return QSysInfo::buildCpuArchitecture();
}

QString SystemInformation::currentCpuArchitecture() const
{
    return QSysInfo::currentCpuArchitecture();
}

QString SystemInformation::kernelType() const
{
    return QSysInfo::kernelType();
}

QString SystemInformation::kernelVersion() const
{
    return QSysInfo::kernelVersion();
}

QString SystemInformation::machineHostName() const
{
    return QSysInfo::machineHostName();
}

QString SystemInformation::machineUniqueId() const
{
    return QString(QSysInfo::machineUniqueId());
}

QString SystemInformation::prettyProductName() const
{
    return QSysInfo::prettyProductName();
}

QString SystemInformation::productType() const
{
    return QSysInfo::productType();
}

QString SystemInformation::productVersion() const
{
    return QSysInfo::productVersion();
}
