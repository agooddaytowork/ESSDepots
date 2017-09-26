
#ifndef GAUGEOBJECT_H
#define GAUGEOBJECT_H

#include "anlogger.h"

class GaugeObject
{

public:
    GaugeObject();
    explicit GaugeObject(const int &id, const double &top, const double &left, const int &sdcsAddr);
    explicit GaugeObject(const int &id, const double &top, const double &left, const int &sdcsAddr, const double &thresholdDownP, const double &thresholdUpP);

    int id() const;
    void setId(const int &id);
    double top() const;
    void setTop(const double &top);

    double left() const;
    void setLeft(const double &left);

    double thresholdDownP() const;
    void setThresholdDownP(const double &value);

    double thresholdUpP() const;
    void setThresholdUpP(const double &value);

    int SDCSAddr() const;
    void setSDCSAddr(const int &addr);

    double currentValue() const;
    void setCurrentValue(const double &value);

 private:
    int m_id;
    double m_top;
    double m_left;

    double m_thresholdDownP;
    double m_thresholdUpP;

    double m_currentValue;

    int m_SDCSAddr;
};

#endif // GAUGEOBJECT_H
