#include <QtWidgets/QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QList>
#include "components/localdatabaseinterface.h"
#include "components/radialbar.h"


int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    QQmlApplicationEngine engine;

#ifdef Q_OS_WIN
    QString extraImportPath(QStringLiteral("%1/../../../../%2"));
#else
    QString extraImportPath(QStringLiteral("%1/../../../%2"));
#endif




    LocalDatabaseInterface localDBInterface("root","159753","userspice");

    StationObjectModel aModel;
    aModel.addStation(StationObject(5,"S1",0,0,"FA1239"));
    aModel.addStation(StationObject(6,"S2",100,0,"FA1212321"));
    aModel.addStation(StationObject(7,"S3",100,100,"FA1212321"));
    aModel.addStation(StationObject(8,"S4",0,100,"FA1212321"));
    aModel.addStation(StationObject(9,"S5",300,100,"FA1212321"));
    aModel.addStation(StationObject(10,"S6",200,100,"FA1212321"));
    QQmlContext *thisContext = engine.rootContext();
    thisContext->setContextProperty("myStationModel", &localDBInterface.m_stationModel);
    thisContext->setContextProperty("myGaugeModel", &localDBInterface.m_gaugeModel);
   // thisContext->setContextProperty("myStationModel", &aModel);
    thisContext->setContextProperty("LocalDb", &localDBInterface);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
