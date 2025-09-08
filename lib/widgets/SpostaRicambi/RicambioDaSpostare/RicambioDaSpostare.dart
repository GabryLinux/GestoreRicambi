import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/widgets/InserisciCollega/InserisciCollega.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/BarcodeWidget.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RicambioDaSpostare extends StatefulWidget {
  RicambioDaSpostare({Key? key}) : super(key: key);
  late TextEditingController codice, Seriale;
  String text = "";
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  bool check = false;
  List<String> FotoPath = <String>[];

  @override
  State<RicambioDaSpostare> createState() => _RicambioDaSpostareState();
}

class _RicambioDaSpostareState extends State<RicambioDaSpostare> {
  var BarcodeCodice = BarcodeWidget(title: "Codice");
  var BarcodeSeriale = BarcodeWidget(title: "Seriale");
  InserisciCollega destinatarioWidget = InserisciCollega(
    text: "Consegna a",
    defaultValueSet: true,
  );
  @override
  void initState() {
    super.initState();
    widget.codice = TextEditingController();
    widget.Seriale = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Gestore Ricambi SME")),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ricambio Da Spostare",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    BarcodeCodice,
                    BarcodeSeriale,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5, top: 10),
                          child: Text(
                            "Invia a Collega",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        destinatarioWidget,
                      ],
                    ),
                    PhotoWidget(
                        title: "Scatta una foto del ricambio",
                        text: "Ricambio da Spostare",
                        FotoPath: widget.FotoPath)
                  ],
                ),
              ),
              //FINE AVANTI-INDIETRO
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50,
          width: 100,
          child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () async {
                var dati = context.read<DatiSpostaRicambioProvider>();
                dati.updateConsegnaCollega(destinatarioWidget.getCollega!);
                dati.updateCodiceSpostare(BarcodeCodice.getCodice);
                dati.updateSerialeSpostare(BarcodeSeriale.getCodice);

                dati.addFotoRicambi(widget.FotoPath);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmailSendPage(
                        sendFunction:
                            SenderFunctions.EmailRicambioDaSpostare)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "Invia MAIL",
                  style: TextStyle(),
                ),
              )),
        ));
  }
}
