#include "gaugeobject.h"

GaugeObject::GaugeObject()
{

}

GaugeObject::GaugeObject(const int &id, const double &top, const double &left, const int &sdcsAddr):
    m_id(id), m_top(top), m_left(left), m_SDCSAddr(sdcsAddr), m_thresholdDownP(0), m_thresholdUpP(0), m_currentValue(0)
{
}

GaugeObject::GaugeObject(const int &id, const double &top, const double &left, const int &sdcsAddr, const double &thresholdDownP, const double &thresholdUpP):
       m_id(id), m_top(top), m_left(left), m_SDCSAddr(sdcsAddr), m_thresholdDownP(thresholdDownP), m_thresholdUpP(thresholdUpP), m_currentValue(0.05)
{

}

int GaugeObject::id() const
{
    return m_id;
}

void GaugeObject::setId(const int &id)
{
    m_id = id;
}

double GaugeObject::top() const
{
    return m_top;
}

void GaugeObject::setTop(const double &top)
{
    m_top = top;
}

double GaugeObject::left() const
{
    return m_left;
}

void GaugeObject::setLeft(const double &left)
{
    m_left = left;
}

double GaugeObject::thresholdDownP() const
{
    return m_thresholdDownP;
}

void GaugeObject::setThresholdDownP(const double &value)
{
    m_thresholdDownP = value;
}

double GaugeObject::thresholdUpP() const
{
    return m_thresholdUpP;
}

void GaugeObject::setThresholdUpP(const double &value)
{
    m_thresholdUpP = value;
}

int GaugeObject::SDCSAddr() const
{
    return m_SDCSAddr;
}

void GaugeObject::setSDCSAddr(const int &addr)
{
    m_SDCSAddr = addr;
}

double GaugeObject::currentValue() const
{
    return m_currentValue;
}

void GaugeObject::setCurrentValue(const double &value)
{
    m_currentValue = value;
}
