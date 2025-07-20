#ifndef MODELS_H
#define MODELS_H

#include <QObject>

#include <model/TModel.hpp>






class Client : public TModel<Client> {
    TM_SCHEMA(Client, "models.shops", TF(name), TF(email), TF(dob), TF(friends))

    TextField name;
    TextField email;
    TimeField dob = TimeField().format(TF::DATE);
    ListField<Client> friends;
};

class Product : public TModel<Product> {
    TM_SCHEMA(Product, "models.shops", TF(name), TF(price))

    TextField name;
    FloatField price = FloatField().defaults(0);
};

class Command : public TModel<Command> {
    TM_SCHEMA(Command, "models.shops", TF(client), TF(product))

    ModelField<Client> client;
    ModelField<Product> product;
};




























namespace Expr {
inline Client c0{};
inline Product p0{};
inline Command d0{};
}

using Expr::c0;
using Expr::p0;
using Expr::d0;


void sleep(long dur=-1);
void testInitTM();
void testTm();

#endif // MODELS_H
