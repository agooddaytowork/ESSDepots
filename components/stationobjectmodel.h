#ifndef STATIONOBJECTMODEL_H
#define STATIONOBJECTMODEL_H

#include "anlogger.h"
#include <QAbstractListModel>
#include "stationobject.h"

class StationObjectModel : public QAbstractListModel
{
    Q_OBJECT

public:

    enum StationObjectRoles
    {
        GlobalId = Qt::UserRole + 1,
        stationName,
        top,
        left,
        egunType,
        RFID,
        KTPN,
        KTSERIALPN,
        LPN,
        GUNOFFPRESSURE,
        PO,
        SUPPLIERTESTDATE,
        ReceviedDate,
        ShippedDate,
        stationState,
        HVON,
        ValveON,
        ProtectON,
        thresholdDownP,
        thresholdUpP,
        thresholdDownI,
        thresholdUpI,
        pumpType,
        pumpAddr,
        pumpCh,
        SDCSAddr,
        SDCSCh,
        lastCurrent,
        lastPressure,
        lastVoltage

    };

    StationObjectModel(QObject *parent =0);

    void addStation(const StationObject &station);
    void updateStationFruInfo(const int &index
                       , const QByteArray &KTPN, const QByteArray &KTSERIALPN, const QByteArray &LPN, const QByteArray &GUNOFFPRESSURE, const QByteArray &PO
                       , const QString &SUPPLIERTESTDATE, const QString &ReceivedDate, const QString &ShippedDate);

    void updateStationState(const int &index, const QByteArray &stateValue);
    void updateStationHVON(const int &index, const bool &command);
    void updateStationValveON(const int &index, const bool &command);
    void updateStationProtectON(const int &index, const bool &command);

    void updateStationSettings(const int &index, const int &id, const QString &name, const QByteArray &eguntype, const double &thresholdDownPvalue, const double &thresholdUpPvalue
                               , const double &thresholdDownIvalue, const double &thresholdUpIvalue, const int &pumpTypevalue, const int &pumpAddrvalue, const int &pumpChvalue
                               , const int &SDCSAddrValue, const int &SDCSChValue);


    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) ;

    StationObject getStation(const int &id);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
   // QHash<int, StationObject> m_stationObjectMap;
      QMap<int, StationObject> m_stationObjectMap;
    QHash<int, QModelIndex> m_stationModelIndexHash;
//    QList<StationObject> m_stationObjectList;

};



#endif // STATIONOBJECTMODEL_H
