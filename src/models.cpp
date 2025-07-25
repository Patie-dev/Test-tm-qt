#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <thread>

#include <QTimer>
#include <QDebug>


#include "Models.h"

#include <model/TModel.hpp>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QTimer>
#include <QDebug>

#include "clientgenerator.h"

TM_MANAGER(Client)
TM_MANAGER(Product)
TM_MANAGER(Command)


void sleep(long dur){
    while (true)
    {
        std::this_thread::sleep_for(std::chrono::microseconds(5));
    }
}

void testInitTM()
{
    TModeler::start()
        .init(Tdb::Builder()
                  .type(Tdb::Type::SQLITE)
                  .dbDir("/tmp/sql")
                  .dbName("test.db")
                  .accept("models.shops")
                  .accept("models.users")
                  .get());

    testTm();
}


void comm()
{
    Tms<Client> tms;

    tms.onSave([](auto keys)
               {
                   Log::d("onSave...\n" +
                          Client::tms.get(keys).data());
               });
    tms.onCreate([](auto keys)
                 {
                     Log::d("onCreate...\n" +
                            Client::tms.get(keys).data());
                 });
    tms.onUpdate([](auto keys)
                 {
                     Log::d("onUpdate...\n" +
                            Client::tms.get(keys).data());
                 });
    tms.onDelete([](auto keys)
                 {
                     Log::d("onDelete...\n" +
                            vectorToString(keys));
                 });
    tms.onModelChange([](auto keys)
                      {
                          Log::d("onModelChange...\n" +
                                 vectorToString(keys));
                      });
}

void bg(){
    QMetaObject::invokeMethod(
        qApp,                    // QObject cible (doit vivre dans le thread principal)
        []() {
            // Dans ton code principal, par exemple dans main() ou ton contrôleur :
            QThread* thread = new QThread;
            ClientGenerator* generator = new ClientGenerator;

            // Déplacer l'objet dans un thread séparé
            generator->moveToThread(thread);

            // Connexion pour démarrer et arrêter proprement
            QObject::connect(thread, &QThread::started, generator, &ClientGenerator::start);
            QObject::connect(qApp, &QCoreApplication::aboutToQuit, generator, &ClientGenerator::stop);
            QObject::connect(qApp, &QCoreApplication::aboutToQuit, thread, &QThread::quit);
            QObject::connect(thread, &QThread::finished, generator, &QObject::deleteLater);
            QObject::connect(thread, &QThread::finished, thread, &QObject::deleteLater);

            // Lancer le thread
            thread->start();
        },      // Callable (lambda)
        Qt::QueuedConnection     // Force l'exécution asynchrone dans le thread de qApp
        );
}










































void testTm() {
    // Step 1: Clear existing data
    Client::tms.clear();
    Product::tms.clear();
    Command::tms.clear();

    Client c1;
    c1.name = "Patricia";
    c1.email = "patitambo006@gmail.com";
    c1.dob = "2004-10-16";
    c1.save();

    Client c2;
    c2.name = "Ide";
    c2.email = "simoide@gmail.com";
    c2.dob = "2006-04-12";
    c2.save();

    Product p1;
    p1.name = "arachides";
    p1.price = 150;
    p1.save();

    Product p2;
    p2.name = "haricot";
    p2.price = 800;
    p2.save();

    Command cd1;
    cd1.client = c1;
    cd1.product = p2;
    cd1.save();


    // Step 2: Clients
    for (int i = 1; i <= 10; ++i) {
        Client client;
        std::string m = (i < 10 ? "0" : "");
        client.name = "User " + std::to_string(i);
        client.email = "user" + std::to_string(i) + "@example.com";
        client.dob = "1990-" + m + std::to_string(i) + "-15";
        client.save();
    }

    // Step 3: Products
    for (int i = 1; i <= 20; ++i) {
        Product product;
        product.name = "Product " + std::to_string(i);
        product.price = i * 3.5 + 1.99;
        product.save();
    }

    // Step 4: Commands
    if (true || Command::tms.all().empty()) {
        const auto& clients = Client::tms.all();
        const auto& products = Product::tms.all();

        if (clients.size() < 10 || products.size() < 20) return;

        // Chaque client fait 2 commandes
        for (size_t i = 0; i < clients.size(); ++i) {
            auto client = clients[i];

            for (int j = 0; j < 2; ++j) {
                auto product = products[(i * 2 + j) % products.size()];

                Command cmd;
                cmd.client = client;
                cmd.product = product;
                cmd.save();
            }
        }

        // Commandes supplémentaires (aléatoires pour enrichir)
        for (int k = 0; k < 10; ++k) {
            auto client = clients[k % clients.size()];
            auto product = products[(k * 3) % products.size()];

            Command cmd;
            cmd.client = client;
            cmd.product = product;
            cmd.save();
        }
    }

    auto c = Client::tms.all().first();
    c.email = "ball@gmail.com";
    c.save();

    Client p;
    auto i = Client::tms.with(p).filter(p.name == "Ide");

}
























