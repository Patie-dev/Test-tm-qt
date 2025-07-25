#ifndef VIEWMODEL_H
#define VIEWMODEL_H

#include <QAbstractListModel>
#include "Models.h"

#include "TVM.hpp"







class ClientItem : public TItem<Client> {
    Q_OBJECT
    TM_QML_ITEM
};

class ClientViewModel : public TViewModel<Client> {
    Q_OBJECT
    TM_QML_VM(Client, ClientItem)
};

class ProductItem : public TItem<Product> {
    Q_OBJECT
    TM_QML_ITEM
};

class ProductViewModel : public TViewModel<Product> {
    Q_OBJECT
    TM_QML_VM(Product, ProductItem)
};

class CommandItem : public TItem<Command> {
    Q_OBJECT
    TM_QML_ITEM
};

class CommandViewModel : public TViewModel<Command> {
    Q_OBJECT
    TM_QML_VM(Command, CommandItem)
};

class PaymentItem : public TItem<Payment> {
    Q_OBJECT
    TM_QML_ITEM
};

class PaymentViewModel : public TViewModel<Payment> {
    Q_OBJECT
    TM_QML_VM(Payment, PaymentItem)
};






























#endif // VIEWMODEL_H
