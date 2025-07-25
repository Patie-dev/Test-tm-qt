import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import models 1.0

Popup {
    id: paymentPage
    width: 500
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var command: null

    property var client: null
    property var product: null


    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "📲 Paiement Mobile Money - Commande #" + (command ? command._id : "")
            font.bold: true
            font.pixelSize: 18
        }

        Rectangle {
            width: parent.width
            height: 100
            color: "#f9f9f9"
            radius: 8
            border.color: "#cccccc"
            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text {
                    text: "👤 Client: " + (command && client ? client.name : "")
                    font.pixelSize: 14
                }

                Text {
                    text: "📦 Produit: " + (command && product ? product.name : "")
                    font.pixelSize: 14
                }

                Text {
                    text: "💲 Total à payer: $" + (product ? product.price : "0")
                    font.pixelSize: 14
                    color: "green"
                }
            }
        }

        TextField {
            id: phoneField
            Layout.fillWidth: true
            placeholderText: "📱 Numéro de téléphone (ex: 699123456)"
            inputMethodHints: Qt.ImhDialableCharactersOnly
        }

        TextField {
            id: fullNameField
            Layout.fillWidth: true
            placeholderText: "🧍 Nom complet du titulaire"
        }

        TextField {
            id: amountField
            Layout.fillWidth: true
            placeholderText: "💵 Montant à prélever"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            text: product ? product.price : ""
        }

        TextField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: "🔒 Code secret"
            echoMode: TextInput.Password
        }

        TextArea {
            id: noteField
            Layout.fillWidth: true
            height: 60
            placeholderText: "📝 Note (facultative)"
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Button {
                text: "❌ Annuler"
                onClicked: paymentPage.visible = false
            }

            Button {
                text: "✅ Confirmer Paiement"
                onClicked: {
                    if (command && phoneField.text && passwordField.text) {
                        const data = {
                            phone: phoneField.text,
                            name: fullNameField.text,
                            mode: "Mobile_Money",
                            amount: parseFloat(amountField.text),
                            code: passwordField.text,
                            ref: noteField.text !== "" ? noteField.text : "Payment_commande",
                            command: command._id
                        }

                        const success = paymentModel.create(data)
                        if (success) {
                            console.log("✅ Paiement créé avec succès :", JSON.stringify(data))
                            paymentPage.visible = false
                        } else {
                            console.warn("Échec de la création du paiement.")
                        }
                    } else {
                        console.warn("Champs requis manquants.")
                    }
                }
            }
        }
    }
}
