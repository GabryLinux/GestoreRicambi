import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/widgets/InserisciCollega/InserisciCollega.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaPage.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVendita.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SpostaRicambi/CollegaRicambio/Collega.dart';

class InviaRicambiMagazzinoRC extends StatefulWidget {
  InviaRicambiMagazzinoRC({super.key});
  late TextEditingController codice, Seriale;
  bool vettoreCheck = false;

  Collega? dropdownValue;

  List<String> FotoPath = <String>[];
  PuntoVendita? selectedPuntoVendita;
  InserisciCollega vettoreWidget = InserisciCollega(
    text: "Consegna a",
    defaultValueSet: false,
  );
  @override
  State<InviaRicambiMagazzinoRC> createState() =>
      _InviaRicambiMagazzinoRCState();
}

class _InviaRicambiMagazzinoRCState extends State<InviaRicambiMagazzinoRC> {
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  List<String> FotoPath = <String>[];

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
              Column(
                children: [
                  Text(
                    "INVIA RICAMBI A MAGAZZINO RC",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "Seleziona Vettore",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                  widget.vettoreWidget,
                ],
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                title: Text("Aggiungi Luogo di Consegna"),
                value: luogoCheck,
                onChanged: (bool? value) {
                  setState(() {
                    luogoCheck = value!;
                  });
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
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
        ),
        floatingActionButton: Container(
          height: 50,
          width: luogoCheck ? 150 : 100,
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Text(luogoCheck ? "Inserisci Luogo" : "Invia Mail"),
            onPressed: () async {
              var dati = context.read<DatiInviaRicambiAMagazzinoRCProvider>();
              dati.reset();
              dati.updateConsegnaCollega(widget.vettoreWidget.getCollega!);
              dati.addFotoRicambi(widget.FotoPath);
              if (luogoCheck) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaPage(
                        nextRoute: MaterialPageRoute(
                            builder: (context) => EmailSendPage(
                                sendFunction: SenderFunctions
                                    .EmailInviaRicambiMagazzinoRC)))));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmailSendPage(
                        sendFunction:
                            SenderFunctions.EmailInviaRicambiMagazzinoRC)));
              }
            },
          ),
        ));
  }
}
