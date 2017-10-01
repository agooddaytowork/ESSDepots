#include "localdatabaseinterface.h"
#include <QRegExp>
#include <QtCharts/QLineSeries>
#include <QtCharts/QDateTimeAxis>

QT_CHARTS_USE_NAMESPACE
#define LocalDatabaseInterfaceDebuggerEnabled 0


LocalDatabaseInterface::LocalDatabaseInterface(const QString &dbUsername, const QString &dbPassword, const QString &dbName, QObject *parent):
    QObject(parent), m_dbUsername(dbUsername), m_dbPassword(dbPassword), m_dbName(dbName)
{
    // Register MetaType for other slots from QML
    //    qRegisterMetaType<QAbstractSeries*>();
    //    qRegisterMetaType<QAbstractAxis*>();


    // Configure local data base
    anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Database info: "
                                                      << localDb.databaseName() << "-"
                                                      << localDb.userName() << "-"
                                                      << localDb.password()));

    localDb = QSqlDatabase::addDatabase("QMYSQL");
    localDb.setHostName("localhost");
    localDb.setPort(3306);
    localDb.setDatabaseName(m_dbName);
    localDb.setUserName(m_dbUsername);
    localDb.setPassword(m_dbPassword);

    // initialize LocaldatabaseHash

    if(localDb.open())
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled,
             anAck ("Connected to database");
                anTrk ("Initializing LocalDatabaseStationHash"););


        if(initializeStationModel()){anIf(LocalDatabaseInterfaceDebuggerEnabled, anTrk("Stations Initialization succeed!"));}
        else anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Stations Initialization failed!"));

        if(initializeGaugeModel()){anIf(LocalDatabaseInterfaceDebuggerEnabled, anTrk("Gauges Initialization succeed!"));}
        else anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Gauges Initialization failed!"));


    }
    else
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anTrk("Could not connect to database!"));
    }

}

bool LocalDatabaseInterface::initializeStationModel()
{
    QSqlQuery tmpQuery;

    if(tmpQuery.exec("SELECT * FROM stations "))
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query succeeded: SELECT * FROM stations"));

        anIf(LocalDatabaseInterfaceDebuggerEnabled,
             anAck("Adding stations to localDatabaseMap"  ));
        while(tmpQuery.next())
        {
            QString tmpTop = tmpQuery.value("top").toString();
            QString tmpLeft = tmpQuery.value("left_style").toString();

            tmpTop = tmpTop.remove((tmpTop.length()-2),2);
            tmpLeft = tmpLeft.remove((tmpLeft.length()-2),2);

            QByteArray aRFID;
            aRFID.append(tmpQuery.value("RFID").toString().toLower());
            StationObject aStation(tmpQuery.value("id").toInt(),
                                   tmpQuery.value("stationName").toString(),
                                   tmpTop.toDouble(),
                                   tmpLeft.toDouble(),
                                   aRFID);

            aStation.setEgunType(tmpQuery.value("egunType").toByteArray());
            aStation.setPumpType(tmpQuery.value("pumpType").toInt());
            aStation.setPumpAddr(tmpQuery.value("pumpAddr").toInt());
            aStation.setPumpCh(tmpQuery.value("pumpCH").toInt());

            aStation.setSDCSAddr(tmpQuery.value("sdcsAddr").toInt());
            aStation.setSDCSCh(tmpQuery.value("sdcsCH").toInt());

            aStation.setThresholdDownP(tmpQuery.value("thresholdDownP").toDouble());
            aStation.setThresHoldUpP(tmpQuery.value("thresholdUpP").toDouble());
            aStation.setThresholdDownI(tmpQuery.value("thresholdDownI").toDouble());
            aStation.setThresholdUpI(tmpQuery.value("thresholdUpI").toDouble());
            aStation.setStationState(checkStationState(aStation));
            QSqlQuery secondQuery;

            secondQuery.prepare("SELECT*FROM frus WHERE RFID = ? LIMIT 1");
            secondQuery.bindValue(0, aRFID);
            if(secondQuery.exec())
            {
                anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query succeeded:SELECT * FROM frus WHERE RFID = " + aRFID +" LIMIT 1"));
                if(secondQuery.next())
                {
                    aStation.setKTPN(secondQuery.value("PN").toByteArray());
                    aStation.setKTSERIALPN(secondQuery.value("Serial").toByteArray());
                    aStation.setLPN(secondQuery.value("LPN").toByteArray());
                    aStation.setGUNOFFPRESSURE(secondQuery.value("MFGPressure").toByteArray());
                    aStation.setPO(secondQuery.value("PO").toByteArray());
                    aStation.setSUPPLIERTESTDATE(secondQuery.value("TestDate").toDateTime().toString("MM/dd/yy"));
                    aStation.setReceivedDate(secondQuery.value("DateInStock").toDateTime().toString("MM/dd/yy"));
                    aStation.setShippedDate(secondQuery.value("DateShipped").toDateTime().toString("MM/dd/yy"));
                }
            }
            else
            {
                anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Query failed:SELECT * FROM frus WHERE RFID = " + aRFID +" LIMIT 1"));
            }

            m_stationModel.addStation(aStation);
        }
        anIf(LocalDatabaseInterfaceDebuggerEnabled,
             anAck("Finished adding stations to localDatabase Map; returning ..."  ));


        return true;
    }

    anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Query failed: SELECT GlobalID, stationName, top, left_style FROM stations"));

    return false;
}

bool LocalDatabaseInterface::initializeGaugeModel()
{
    QSqlQuery tmpQuery;

    if(tmpQuery.exec("SELECT * FROM gauges"))
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query succeeded: " + tmpQuery.executedQuery()));
        anIf(LocalDatabaseInterfaceDebuggerEnabled,
             anAck("Adding gauges to localDatabaseMap"  ));
        while (tmpQuery.next())
        {
            QString tmpTop = tmpQuery.value("top").toString();
            QString tmpLeft = tmpQuery.value("left_style").toString();

            tmpTop = tmpTop.remove((tmpTop.length()-2),2);
            tmpLeft = tmpLeft.remove((tmpLeft.length()-2),2);

            GaugeObject aGauge(tmpQuery.value("id").toInt(), tmpTop.toDouble(), tmpLeft.toDouble(), tmpQuery.value("sdcsAddr").toInt()
                               ,tmpQuery.value("thresholdDownP").toDouble(), tmpQuery.value("thresholdUpP").toDouble());
            m_gaugeModel.addGauge(aGauge);
        }

        anIf(LocalDatabaseInterfaceDebuggerEnabled,
             anAck("Finished adding stations to localDatabase Map; returning ..."  ));
        return true;
    }
    anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Query failed: SELECT * FROM gauges"));

    return false;

}

void LocalDatabaseInterface::start()
{

}

void LocalDatabaseInterface::stop()
{

}

void LocalDatabaseInterface::initializeDataToGraph(QAbstractSeries *pressure, QAbstractSeries *voltage, QAbstractSeries *current, QAbstractAxis *axis,const QString &mRFID)
{
    QSqlQuery tmpQuery;

    if(tmpQuery.exec("SELECT * FROM (SELECT * FROM "+ mRFID +" ORDER BY Time DESC LIMIT 180) T1 ORDER BY Time ASC"))
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query Succeeded: SELECT * FROM (SELECT * FROM "+ mRFID +" ORDER BY Time DESC LIMIT 500) T1 ORDER BY Time ASC"));
        if(pressure && voltage && current)
        {
            if(axis)
            {
                anIf(LocalDatabaseInterfaceDebuggerEnabled,anAck("series exists"));
                QLineSeries *pressurelineSeries = static_cast<QLineSeries *>(pressure);
                QLineSeries *voltagelineSeries = static_cast<QLineSeries*>(voltage);
                QLineSeries *currentLineSeries = static_cast<QLineSeries*>(current);

                QDateTimeAxis *xAxis = static_cast<QDateTimeAxis *>(axis);

                pressurelineSeries->clear();
                voltagelineSeries->clear();
                currentLineSeries->clear();

                if(tmpQuery.first())
                {
                    xAxis->setMin(tmpQuery.value("Time").toDateTime());
                }
                QDateTime maxTime;
                anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Enter loop to extract data"));
                while(tmpQuery.next())
                {
                    pressurelineSeries->append(tmpQuery.value("Time").toDateTime().toMSecsSinceEpoch(), tmpQuery.value("Pressure").toDouble());
                    voltagelineSeries->append(tmpQuery.value("Time").toDateTime().toMSecsSinceEpoch(), tmpQuery.value("Voltage").toInt());
                    currentLineSeries->append(tmpQuery.value("Time").toDateTime().toMSecsSinceEpoch(), tmpQuery.value("Current").toDouble());
                    maxTime = tmpQuery.value("Time").toDateTime();
                }
                anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Finished extracting data"));
                xAxis->setMax(maxTime);
            }

        }
        return;
    }

    anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Query failed: SELECT * FROM (SELECT * FROM "+ mRFID +" ORDER BY Time DESC LIMIT 500) T1 ORDER BY Time ASC"));

    return;
}

void LocalDatabaseInterface::updateDataToGraph(QAbstractSeries *pressure, QAbstractSeries *voltage, QAbstractSeries *current, const QDateTime &firstTimePoint, const QDateTime &lastTimePoint, const QByteArray &RFID)
{
    if(pressure && voltage && current)
    {
        QLineSeries *pressurelineSeries = static_cast<QLineSeries *>(pressure);
        QLineSeries *voltagelineSeries = static_cast<QLineSeries*>(voltage);
        QLineSeries *currentLineSeries = static_cast<QLineSeries*>(current);
        QSqlQuery tmpQuery;
        QString tmpQueryString;

        tmpQueryString +="SELECT * FROM " + RFID + " WHERE Time BETWEEN '" + firstTimePoint.toString("yyyy-MM-ddThh:mm:ss") + "' and '" + lastTimePoint.toString("yyyy-MM-ddThh:mm:ss") +"'";

        pressurelineSeries->clear();
        voltagelineSeries->clear();
        currentLineSeries->clear();

        if(tmpQuery.exec(tmpQueryString))
        {

            anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query succeed: " << tmpQuery.executedQuery()));
            while(tmpQuery.next())
            {
                pressurelineSeries->append(tmpQuery.value("Time").toDateTime().toMSecsSinceEpoch(), tmpQuery.value("Pressure").toDouble());
                voltagelineSeries->append(tmpQuery.value("Time").toDateTime().toMSecsSinceEpoch(), tmpQuery.value("Voltage").toInt());
                currentLineSeries->append(tmpQuery.value("Time").toDateTime().toMSecsSinceEpoch(), tmpQuery.value("Current").toDouble());

            }
        }
        else
        {
            anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Query failed: " << tmpQueryString));
        }
    }
}

void LocalDatabaseInterface::setHVON(const int &globalId, const bool &command)
{
    m_stationModel.updateStationHVON(globalId,command);
}

void LocalDatabaseInterface::setValveON(const int &globalId, const bool &command)
{
    m_stationModel.updateStationValveON(globalId, command);
}

void LocalDatabaseInterface::setProtectON(const int &globalId, const bool &command)
{
    m_stationModel.updateStationProtectON(globalId, command);
}

void LocalDatabaseInterface::shipStation(const int &globalId)
{

}

void LocalDatabaseInterface::updateStationFruInfo(const int &id,const QByteArray &KTPN, const QByteArray &KTSERIALPN, const QByteArray &LPN, const QByteArray &GUNOFFPRESSURE, const QByteArray &PO, const QString &SUPPLIERTESTDATE, const QString &ReceivedDate, const QString &ShippedDate)
{
    m_stationModel.updateStationFruInfo(id, KTPN, KTSERIALPN,LPN,GUNOFFPRESSURE,PO,SUPPLIERTESTDATE,ReceivedDate,ShippedDate);

}

void LocalDatabaseInterface::updateStationSettings(const int &index,const int &id, const QString &name, const QByteArray &eguntype, const double &thresholdDownP, const double &thresholdUpP, const double &thresholdDownI, const double &thresholdUpI, const int &pumpType, const int &pumpAddr, const int &pumpCh, const int &SDCSAddr, const int &SDCSCh)
{

    m_stationModel.updateStationSettings(index, id, name, eguntype, thresholdDownP, thresholdUpP, thresholdDownI, thresholdUpI, pumpType, pumpAddr, pumpCh, SDCSAddr, SDCSCh);
    updateStationSettingToDatabaseSlot(id);
}

void LocalDatabaseInterface::updateStationSettingToDatabaseSlot(const int &id)
{
    anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Gate"));
    StationObject tmpStation(m_stationModel.getStation(id));

    QString tmpQueryString;
    QSqlQuery tmpQuery;

    tmpQueryString+= "UPDATE stations SET "
                     "stationName = ?"
                     ",pumpType = " + QString::number(tmpStation.pumpType())
            + ",pumpAddr = " + QString::number(tmpStation.pumpAddr())
            + ",pumpCH = " + QString::number(tmpStation.pumpCh())
            + ",sdcsAddr =" + QString::number(tmpStation.SDCSAddr())
            + ",sdcsCH = " + QString::number(tmpStation.SDCSCh())
            + ",thresholdDownP = " + QString::number(tmpStation.thresholdDownP())
            + ",thresholdUpP = " +QString::number(tmpStation.thresholdUpP())
            + ",thresholdDownI = " + QString::number(tmpStation.thresholdDownI())
            + ",thresholdUpI = "  + QString::number(tmpStation.thresholdUpI())
            + " WHERE id = " + QString::number(id);

    tmpQuery.prepare(tmpQueryString);
    tmpQuery.addBindValue(tmpStation.stationName());
    if(tmpQuery.exec())
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query Succeed:" + tmpQueryString ));
    }
    else
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Query Failed:" + tmpQueryString ));
    }

}


void LocalDatabaseInterface::updateStationPositions(const int &id, const double &left, const double &top)
{
    StationObject tmpStation(m_stationModel.getStation(id));

    QSqlQuery tmpQuery;

    tmpStation.setTop(top);
    tmpStation.setLeft(left);

    tmpQuery.prepare("UPDATE stations SET top = ?, left_style = ? WHERE id = ?");
    tmpQuery.addBindValue(tmpStation.top());
    tmpQuery.addBindValue(tmpStation.left());
    tmpQuery.addBindValue(id);


    if(tmpQuery.exec())
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query succeed: " << "UPDATE stations SET top = ?, left_style = ? WHERE id = ?"));
        emit messageToUser(PopUpTypes::Confirmation, "Station "+ tmpStation.stationName() + " 's position updated");
    }
    else
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Querry failed: " << "UPDATE stations SET top = ?, left_style = ? WHERE id = ?"));
    }


}

void LocalDatabaseInterface::updateGaugePositions(const int &gid,  const double &left, const double &top)
{
    GaugeObject tmpGauge(m_gaugeModel.getGauge(gid));

    QSqlQuery tmpQuery;

    tmpGauge.setTop(top);
    tmpGauge.setLeft(left);

    tmpQuery.prepare("UPDATE gauges SET top = ?, left_style = ? WHERE id = ?");
    tmpQuery.addBindValue(tmpGauge.top());
    tmpQuery.addBindValue(tmpGauge.left());
    tmpQuery.addBindValue(gid);


    if(tmpQuery.exec())
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anAck("Query succeed: " << tmpQuery.executedQuery()));
        emit messageToUser(PopUpTypes::Confirmation, "Gauge, ID: "+ QString::number(tmpGauge.id()) + ", position updated");
    }
    else
    {
        anIf(LocalDatabaseInterfaceDebuggerEnabled, anError("Querry failed: " << "UPDATE gauges SET top = ?, left_style = ? WHERE id = ?"));
    }


}


QByteArray LocalDatabaseInterface::checkStationState(const StationObject &station)
{
    if(station.RFID() == "r0000")
    {
        return "EgunNotFound";
    }

    return "EgunGood";

}
