import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import models 1.0

ApplicationWindow {
    width: 1100
    height: 650
    visible: true
    title: "Shop Manager (TModeler Demo)"
    color: "#f5f5f5"

    ClientViewModel { id: clientModel }
    ProductViewModel { id: productModel }
    CommandViewModel { id: commandModel }
    PaymentViewModel { id: paymentModel }

    property var selectedClient: null
    property var selectedProduct: null

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Rectangle {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            radius: 12
            color: "white"
            border.color: "#dddddd"

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "👥 Clients (" + clientModel.count() + ")"
                    font.bold: true
                    font.pixelSize: 16
                }

                ListView {
                    id: clientListView
                    width: parent.width - 20
                    height: 450
                    model: clientModel
                    clip: true

                    delegate: Rectangle {
                        width: parent.width
                        height: 50
                        radius: 8
                        property var item: clientModel.get(index)
                        color: selectedClient === item ? "#e0f7fa" : (index % 2 === 0 ? "#fafafa" : "#ffffff")

                        MouseArea {
                            anchors.fill: parent
                            onClicked: selectedClient = item
                        }

                        Text {
                            anchors.centerIn: parent
                            text: item.data.name + " (" + item.data.email + ")"
                            font.pixelSize: 13
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            radius: 12
            color: "white"
            border.color: "#dddddd"

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "🛒 Products (" + productModel.count() + ")"
                    font.bold: true
                    font.pixelSize: 16
                }

                ListView {
                    id: productListView
                    width: parent.width - 20
                    height: 450
                    model: productModel
                    clip: true

                    delegate: Rectangle {
                        width: parent.width
                        height: 50
                        radius: 8
                        property var item: productModel.get(index)
                        color: selectedProduct === item ? "#ffe0e0" : (index % 2 === 0 ? "#fafafa" : "#ffffff")

                        MouseArea {
                            anchors.fill: parent
                            onClicked: selectedProduct = item
                        }

                        Text {
                            anchors.centerIn: parent
                            text: item.data.name + " - $" + item.data.price
                            font.pixelSize: 13
                        }
                    }
                }

                Column {
                    spacing: 10
                    width: parent.width - 20

                    Text {
                        text: "💬 Commentaires"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Repeater {
                        model: commentModel.filterByProduct(selectedProduct ? selectedProduct.data._id : null)
                        delegate: Text {
                            text: "- " + modelData.author + ": " + modelData.text
                            font.pixelSize: 12
                            wrapMode: Text.Wrap
                        }
                    }

                    TextArea {
                        id: newCommentText
                        placeholderText: "Ajouter un commentaire..."
                        width: parent.width
                        height: 60
                    }

                    Button {
                        text: "💬 Publier"
                        onClicked: {
                            if (selectedProduct)
                                commentModel.add(selectedProduct.data._id, newCommentText.text)
                            newCommentText.text = ""
                        }
                    }
                }

            }
        }

        Rectangle {
            Layout.preferredWidth: 400
            Layout.fillHeight: true
            radius: 12
            color: "white"
            border.color: "#dddddd"

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "📦 Commands (" + commandModel.count() + ")"
                    font.bold: true
                    font.pixelSize: 16
                }

                ListView {
                    id: commandListView
                    width: parent.width - 20
                    height: 400
                    model: commandModel
                    clip: true

                    delegate: Rectangle {
                        width: parent.width
                        height: 55
                        radius: 8
                        property var item: commandModel.get(index)
                        property var client: clientModel.get(clientModel.indexOf(item.data.client))
                        property var product: productModel.get(productModel.indexOf(item.data.product))
                        color: index % 2 === 0 ? "#fafafa" : "#ffffff"

                        Column {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 4

                            Text {
                                text: client.data.name + " ➔ " + product.data.name + " ($" + product.data.price + ")"
                                font.pixelSize: 13
                            }

                            Row {
                                spacing: 10
                                Text {
                                    text: item.data.isPaid ? "✅ Payé" : "❗Impaye"
                                    color: item.data.isPaid ? "green" : "red"
                                    font.pixelSize: 12
                                }

                                Button {
                                    text: "💰 Payer"
                                    onClicked: {
                                        paymentPage.command = item.data
                                        paymentPage.client = clientModel.get(clientModel.indexOf(item.data.client)).data
                                        paymentPage.product = productModel.get(productModel.indexOf(item.data.product)).data
                                        paymentPage.visible = true
                                    }
                                }
                            }
                        }

                    }
                }

                Row {
                    spacing: 10
                    Button {
                        text: "🔍 Client's Commands"
                        onClicked: if (selectedClient) commandModel.filter("client", selectedClient.data._id)
                    }
                    Button {
                        text: "🔍 Product's Commands"
                        onClicked: if (selectedProduct) commandModel.filter("product", selectedProduct.data._id)
                    }
                }

                Button {
                    text: "🔄 Clear Filter"
                    width: parent.width - 20
                    onClicked: commandModel.refresh()
                }
            }
        }
    }

    Payment {
        id: paymentPage
        visible: false
    }
}
