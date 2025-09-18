import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiNotificaSpedizione.dart';
import 'package:appsme/widgets/InserisciCollega/InserisciCollega.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaPage.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVendita.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/NotificaSpedizione/DatePicking.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificaSpedizione extends StatefulWidget {
  NotificaSpedizione({super.key});
  late TextEditingController codice, Seriale;
  bool vettoreCheck = false;

  int counter = 0;

  List<String> FotoPath = <String>[];
  PuntoVendita? selectedPuntoVendita;
  @override
  State<NotificaSpedizione> createState() => NotificaSpedizioneState();
}

class NotificaSpedizioneState extends State<NotificaSpedizione> {
  InserisciCollega destinatarioWidget = InserisciCollega(text: "Consegna a");
  InserisciCollega vettoreWidget = InserisciCollega(
    text: "Vettore",
    defaultValueSet: true,
  );
  DatePickingWidget date = DatePickingWidget();
  bool luogoCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("SME APP")),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "NOTIFICA SPEDIZIONE",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 7, top: 10),
                    child: Text(
                      "Seleziona Destinatario",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ),
                  destinatarioWidget,
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 7, top: 10),
                    child: Text(
                      "Seleziona Vettore",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ),
                  vettoreWidget,
                ],
              ),
              date,
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                title: Text("Aggiungi Luogo/PV Fermo Deposito"),
                value: luogoCheck,
                onChanged: (bool? value) {
                  setState(() {
                    luogoCheck = value!;
                  });
                },
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  PhotoWidget(
                      title: "Scatta foto della spedizione",
                      text: "Foto Spedizione",
                      FotoPath: widget.FotoPath),
                  Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                      "Se la spedizione riguarda più ricambi o scatole fare una foto per ogni scatola o ricambio che compone la spedizione")
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50,
          width: luogoCheck ? 150 : 100,
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Text(luogoCheck ? "Inserisci Luogo" : "Invia Mail"),
            onPressed: () async {
              var dati = context.read<DatiNotificaSpedizione>();
              dati.reset();
              dati.addFoto(widget.FotoPath);
              dati.updateCollegaVettore(vettoreWidget.getCollega!);
              dati.updateCollegaDestinatario(destinatarioWidget.getCollega!);
              if (date.getDate != null) {
                debugPrint("Data selezionata: ${date.getDate}");
                dati.updateDataConsegna(date.getDate!);
              }
              if (luogoCheck) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaPage(
                        nextRoute: MaterialPageRoute(
                            builder: (context) => EmailSendPage(
                                sendFunction: SenderFunctions
                                    .EmailNotificaSpedizione)))));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmailSendPage(
                        sendFunction:
                            SenderFunctions.EmailNotificaSpedizione)));
              }
            },
          ),
        ));
  }
}
