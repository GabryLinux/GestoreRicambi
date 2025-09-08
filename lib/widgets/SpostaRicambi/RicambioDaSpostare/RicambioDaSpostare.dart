import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/widgets/InserisciCollega/InserisciCollega.dart';
import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/InviaMail/InviaMail.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/CollegaRIcambioPage.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:xml/xml.dart';

class RicambioDaSpostare extends StatefulWidget {
  RicambioDaSpostare({Key? key}) : super(key: key);
  late TextEditingController codice, Seriale;
  String text = "";
  final ImagePicker _picker = ImagePicker();
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  bool check = false;
  List<String> FotoPath = <String>[];

  @override
  State<RicambioDaSpostare> createState() => _RicambioDaSpostareState();
}

class _RicambioDaSpostareState extends State<RicambioDaSpostare> {

  
  InserisciCollega destinatarioWidget = InserisciCollega(text: "Consegna a", defaultValueSet: true,);
  @override
  void initState() {
    super.initState();
    widget.codice = TextEditingController();
    widget.Seriale = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> send() async {
      List<String> addresses = [];
      addresses.addAll(widget.parsedXML[0].split(","));
      final Email email = Email(
        recipients: addresses,
        body: widget.parsedXML[2],
        subject: widget.parsedXML[1],
        attachmentPaths: widget.FotoPath,
        isHTML: false,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        //platformResponse = 'Email Inviata';
      } catch (error) {
        debugPrint(error.toString());
        platformResponse = error.toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(platformResponse),
          ),
        );

      }

      if (!mounted) return;

      
    }

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
                    Container(
                      //BARCODE
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:
                                Text("Codice", style: TextStyle(fontSize: 14)),
                            padding: EdgeInsets.all(5),
                          ),
                          TextField(
                            //TEXTINPUT
                            controller: widget.codice,
                            onChanged: (value) {
                              context
                                  .read<DatiSpostaRicambioProvider>()
                                  .updateCodiceSpostare(value);
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(fontSize: 14),
                                hintText: 'Inserisci Codice'),
                          ), //FINE TEXTINPUT
                          OutlinedButton(
                              onPressed: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SimpleBarcodeScannerPage(),
                                    ));
                                setState(() {
                                  if (res is String) {
                                    //debugPrint(res);
                                    context
                                        .read<DatiSpostaRicambioProvider>()
                                        .updateCodiceSpostare(res);
                                    widget.codice.text = res;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  "Scannerizza BARCODE",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ))
                        ],
                      ),
                    ), //FINE BARCODE
                    Container(
                      //BARCODE
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:
                                Text("Seriale", style: TextStyle(fontSize: 14)),
                            padding: EdgeInsets.all(5),
                          ),
                          TextField(
                            //TEXTINPUT
                            controller: widget.Seriale,
                            onChanged: (value) {
                              context
                                  .read<DatiSpostaRicambioProvider>()
                                  .updateSerialeSpostare(value);
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(),
                                hintText: 'Inserisci Seriale'),
                          ), //FINE TEXTINPUT
                          OutlinedButton(
                              onPressed: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SimpleBarcodeScannerPage(),
                                    ));
                                setState(() {
                                  if (res is String) {
                                    //debugPrint(res);
                                    context
                                        .read<DatiSpostaRicambioProvider>()
                                        .updateSerialeSpostare(res);
                                    widget.Seriale.text = res;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  "Scannerizza BARCODE",
                                  style: TextStyle(fontSize: 14),
                                ),
                              )),
                        ],
                      ),
                    ),
                    //FINE BARCODE
                    Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 10),
                    child: Text(
                      "Invia a Collega",
                      style:
                          TextStyle(fontSize: 14),
                    ),
                  ),
                  destinatarioWidget,
                ],
              ),

                    PhotoWidget(title: "Scatta una foto del ricambio",
                     text: "Ricambio da Spostare", FotoPath: widget.FotoPath)
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
                var urlLauncher = '';
                var dati = context.read<DatiSpostaRicambioProvider>();
                dati.updateConsegnaCollega( destinatarioWidget.getCollega!);
                List<String> parole = [];

                dati.addFotoRicambi( widget.FotoPath);
                widget.text = await ParserText.parserRicambioSpostare(parole);
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
