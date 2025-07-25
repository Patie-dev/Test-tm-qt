#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "viewmodels.hpp"






int main(int argc, char *argv[])
{
    // Initialisation des données de test
    testInitTM();

    QGuiApplication app(argc, argv);

    // Enregistrement des ViewModels pour QML
    qmlRegisterType<ClientViewModel>("models", 1, 0, "ClientViewModel");
    qmlRegisterType<ProductViewModel>("models", 1, 0, "ProductViewModel");
    qmlRegisterType<CommandViewModel>("models", 1, 0, "CommandViewModel");
    qmlRegisterType<PaymentViewModel>("models", 1, 0, "PaymentViewModel");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
        );

    // Charger le fichier QML principal
    engine.loadFromModule("TestMingw", "Main");

    return app.exec();
}

























