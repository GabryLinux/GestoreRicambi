import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/main.dart';
import 'package:appsme/widgets/InserisciCollega/InserisciCollega.dart';
import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/InviaMail/InviaMail.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaPage.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaRisultati.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVendita.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

import '../SpostaRicambi/CollegaRicambio/Collega.dart';

class InviaRicambiMagazzinoRC extends StatefulWidget {
  InviaRicambiMagazzinoRC({super.key});
  late TextEditingController codice, Seriale;
  final ImagePicker _picker = ImagePicker();
  bool vettoreCheck = false;

  int counter = 0;
  Collega? dropdownValue;

  List<String> FotoPath = <String>[];
  PuntoVendita? selectedPuntoVendita;
  @override
  State<InviaRicambiMagazzinoRC> createState() =>
      _InviaRicambiMagazzinoRCState();
}

class _InviaRicambiMagazzinoRCState extends State<InviaRicambiMagazzinoRC> {
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  List<String> FotoPath = <String>[];
  InserisciCollega vettoreWidget = InserisciCollega(text: "Consegna a");
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
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              ),
              CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  title: Text(
                    "Invia a Collega",
                  ),
                  value: widget.vettoreCheck,
                  onChanged: ((value) {
                    setState(() {
                      widget.vettoreCheck = value!;
                    });
                  })),
              Visibility(visible: widget.vettoreCheck, child: vettoreWidget),
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
              context
                  .read<DatiInviaRicambiAMagazzinoRCProvider>()
                  .updateConsegnaCollega(vettoreWidget.getCollega!);
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
