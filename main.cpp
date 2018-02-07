#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "ws_server.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    WSServer server(1234);

    Q_UNUSED(server);

    // qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/qml/CustomerModel.qml")), "io.qt.example", 1, 0, "CustomerModel");
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/qml/CustomerModel.qml")), "pnlug.guibkp", 1, 0, "CustomerModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
