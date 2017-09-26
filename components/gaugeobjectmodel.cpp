#include "gaugeobjectmodel.h"

GaugeObjectModel::GaugeObjectModel(QObject *parent): QAbstractListModel(parent)
{

}

void GaugeObjectModel::addGauge(const GaugeObject &gauge)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_GaugeObjectMap.insert(gauge.id(), gauge);
    endInsertRows();
}


int GaugeObjectModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_GaugeObjectMap.count();
}

QVariant GaugeObjectModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= rowCount())
        return QVariant();

    GaugeObject gauge = m_GaugeObjectMap.values()[index.row()];

    if(role == GlobalId) return gauge.id();
    else if(role == top) return gauge.top();
    else if(role == left) return gauge.left();
    else if(role == SDCSAddr) return gauge.SDCSAddr();
    else if(role == thresholdDownP) return gauge.thresholdDownP();
    else if(role == thresholdUpP) return gauge.thresholdUpP();
    else if(role == currentValue) return gauge.currentValue();


    return QVariant();
}


bool GaugeObjectModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(index.row() < 0 || index.row() >= rowCount())
        return false;
    GaugeObject gauge = m_GaugeObjectMap.values()[index.row()];

    if(role == GlobalId)  gauge.setId(value.toInt());
    else if(role == top)  gauge.setTop(value.toDouble());
    else if(role == left)  gauge.setLeft(value.toDouble());
    else if(role == SDCSAddr)  gauge.setSDCSAddr(value.toInt());
    else if(role == thresholdDownP)  gauge.setThresholdDownP(value.toDouble());
    else if(role == thresholdUpP)  gauge.setThresholdUpP(value.toDouble());
    else if(role == currentValue) gauge.setCurrentValue(value.toDouble());
    m_GaugeObjectMap.insert(gauge.id(), gauge);
    dataChanged(index, index, QVector<int>() << role);

    return true;
}

QHash<int, QByteArray> GaugeObjectModel::roleNames()const
{
    QHash<int, QByteArray> roles;

    roles[GlobalId] = "GlobalId";
    roles[top] = "m_top";
    roles[left] = "m_left";
    roles[SDCSAddr] = "SDCSAddr";
    roles[thresholdDownP] = "thresholdDownP";
    roles[thresholdUpP] = "thresholdUpP";
    roles[currentValue] = "gaugeCurrentValue";

    return roles;
}


GaugeObject GaugeObjectModel::getGauge(const int &gid)
{
    return m_GaugeObjectMap.value(gid);
}
