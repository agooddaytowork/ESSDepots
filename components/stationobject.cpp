
#include "stationobject.h"


StationObject::StationObject()
{

}

StationObject::StationObject(const int &id, const QString &name, const double &top, const double &left, const QByteArray &RFID)
    :m_id(id), m_stationName(name), m_top(top), m_left(left), m_RFID(RFID), m_lastCurrent(0), m_lastPressure(0), m_lastVoltage(0)
{
}

StationObject::StationObject(const int &id, const QString &name, const double &top, const double &left,const QByteArray &egunType, const QByteArray &RFID, const QByteArray &KTPN, const QByteArray &KTSERIALPN, const QByteArray &LPN, const QByteArray &GUNOFFPRESSURE, const QByteArray &PO, const QString &SUPPLIERTESTDATE, const QString &ReceivedDate, const QString &ShippedDate)
    :m_id(id), m_stationName(name), m_top(top), m_left(left), m_RFID(RFID), m_KTPN(KTPN), m_KTSERIALPN(KTSERIALPN), m_LPN(LPN), m_GUNOFFPRESSURE(GUNOFFPRESSURE), m_PONumber(PO), m_SUPPLIERTESTDATE(SUPPLIERTESTDATE), m_ReceivedDate(ReceivedDate), m_ShippedDate(ShippedDate), m_egunType(egunType), m_lastCurrent(0), m_lastPressure(0), m_lastVoltage(0)
{

}

int StationObject::stationId() const
{
    return m_id;
}

void StationObject::setStationId(const int &id)
{
    if(id != m_id)
    {
        m_id = id;

    }
}

QString StationObject::stationName() const
{
    return m_stationName;
}

void StationObject::setStationName(const QString &name)
{
    if(name != m_stationName)
    {
        m_stationName = name;
    }
}

double StationObject::top() const
{
    return m_top;
}

void StationObject::setTop(const double &top)
{
    if(top != m_top)
    {
        m_top = top;

    }
}

double StationObject::left() const
{
    return m_left;
}

void StationObject::setLeft(const double &left)
{
    if(left != m_left)
    {
        m_left = left;
    }
}

QByteArray StationObject::RFID() const
{
    return m_RFID;
}

void StationObject::setRFID(const QByteArray &RFID)
{
    if(RFID != m_RFID)
    {
        m_RFID = RFID;
    }
}


QByteArray StationObject::KTPN()const
{
    return m_KTPN;
}

void StationObject::setKTPN(const QByteArray &KTPN)
{
    if(KTPN!= m_KTPN)
    {
        m_KTPN = KTPN;
    }
}

QByteArray StationObject::KTSERIALPN()const
{
    return m_KTSERIALPN;
}

void StationObject::setKTSERIALPN(const QByteArray &SERIALPN)
{
    if(SERIALPN != m_KTSERIALPN)
    {
        m_KTSERIALPN = SERIALPN;
    }
}

QByteArray StationObject::LPN()const
{
    return m_LPN;
}

void StationObject::setLPN(const QByteArray &LPN)
{
    if(LPN != m_LPN)
    {
        m_LPN = LPN;
    }
}

QByteArray StationObject::GUNOFFPRESSURE()const
{
    return m_GUNOFFPRESSURE;
}

void StationObject::setGUNOFFPRESSURE(const QByteArray &pressure)
{
   if(pressure != m_GUNOFFPRESSURE)
   {
       m_GUNOFFPRESSURE = pressure;
   }
}

QByteArray StationObject::PO()const
{
    return m_PONumber;
}

void StationObject::setPO(const QByteArray &PO)
{
    if (PO != m_PONumber)
    {
        m_PONumber = PO;
    }
}

QString StationObject::SUPPLIERTESTDATE()const
{
    return m_SUPPLIERTESTDATE;
}

void StationObject::setSUPPLIERTESTDATE(const QString &date)
{
    m_SUPPLIERTESTDATE = date;
}

QString StationObject::ReceivedDate()const
{
    return m_ReceivedDate;
}

void StationObject::setReceivedDate(const QString &date)
{
    m_ReceivedDate = date;
}

QString StationObject::ShippedDate() const
{
    return m_ShippedDate;
}

void StationObject::setShippedDate(const QString &date)
{
    m_ShippedDate = date;
}

QByteArray StationObject::egunType() const
{
    return m_egunType;
}

void StationObject::setEgunType(const QByteArray &egunType)
{
    m_egunType = egunType;
}

QByteArray StationObject::stationState() const
{
    return m_StationState;
}

void StationObject::setStationState(const QByteArray &state)
{
    if( state == "EgunNotFound" || state == "EgunGood" || state == "EgunWarning" || state =="EgunAlert")
    {
        m_StationState = state;
    }
    else
    {
        m_StationState = "EgunNotFound";
    }

}


bool StationObject::HVON() const
{
    return m_HVON;
}

void StationObject::setHVON(const bool &command)
{
    m_HVON = command;
}

bool StationObject::ValveON() const
{
    return m_ValveON;
}

void StationObject::setValveON(const bool &command)
{
    m_ValveON = command;
}

bool StationObject::ProtectON() const
{
    return m_ProtectON;
}

void StationObject::setProtectON(const bool &command)
{
    m_ProtectON = command;
}

double StationObject::thresholdDownI() const
{
    return m_thresholdDownI;
}

void StationObject::setThresholdDownI(const double &value)
{
    m_thresholdDownI = value;
}

double StationObject::thresholdDownP() const
{
    return m_thresholdDownP;
}

void StationObject::setThresholdDownP(const double &value)
{
    m_thresholdDownP = value;
}

double StationObject::thresholdUpI() const
{
    return m_thresholdUpI;
}

void StationObject::setThresholdUpI(const double &value)
{
    m_thresholdUpI = value;
}

double StationObject::thresholdUpP() const
{
    return m_thresholdUpP;
}

void StationObject::setThresHoldUpP(const double &value)
{
    m_thresholdUpP = value;
}

int StationObject::pumpType() const
{
    return m_pumpType;
}

void StationObject::setPumpType(const int &type)
{
   m_pumpType = type;

}

int StationObject::pumpAddr() const
{
    return m_pumpAddr;
}

void StationObject::setPumpAddr(const int &addr)
{
    m_pumpAddr = addr;
}

int StationObject::pumpCh() const
{
    return m_pumpCh;
}

void StationObject::setPumpCh(const int &ch)
{
    m_pumpCh = ch;
}

int StationObject::SDCSAddr() const
{
    return m_SDCSAddr;
}

void StationObject::setSDCSAddr(const int &addr)
{
    m_SDCSAddr = addr;
}

int StationObject::SDCSCh() const
{
    return m_SDCSCh;
}

void StationObject::setSDCSCh(const int &ch)
{
    m_SDCSCh = ch;
}


double StationObject::lastCurrent() const
{
    return m_lastCurrent;
}

double StationObject::lastPressure() const
{
    return m_lastPressure;
}

int StationObject::lastVoltage() const
{
    return m_lastVoltage;
}

void StationObject::setLastCurrent(const double &value)
{
    m_lastCurrent = value;
}

void StationObject::setLastPressure(const double &value)
{
    m_lastPressure = value;
}

void StationObject::setLastVoltage(const int &value)
{
    m_lastVoltage = value;
}






