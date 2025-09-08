import 'dart:io';

import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/BarcodeWidget.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioRimosso/RicambioRimossoPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class RicambioInstallatoPage extends StatefulWidget {
  RicambioInstallatoPage({Key? key}) : super(key: key);
  late TextEditingController codice, Seriale;
  final ImagePicker _picker = ImagePicker();
  bool check = false;
  int counter = 0;
  List<String> FotoPath = <String>[];
  @override
  State<RicambioInstallatoPage> createState() => _RicambioInstallatoPageState();
}

class _RicambioInstallatoPageState extends State<RicambioInstallatoPage> {
  var BracodeCodice = BarcodeWidget(title: "Codice");
  var BracodeSeriale = BarcodeWidget(title: "Seriale");
  @override
  void initState() {
    // TODO: implement initState

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
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ricambio Installato",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    BracodeCodice, //FINE BARCODE
                    BracodeSeriale, //FINE BARCODE
                    PhotoWidget(
                            title: "Scatta foto del Ricambio",
                            text: "Ricambio Installato",
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              context
                  .read<DatiInstallazioneRicambiProvider>()
                  .updateCodiceInstall(BracodeCodice.getCodice);
              context
                  .read<DatiInstallazioneRicambiProvider>()
                  .updateSerialeInstall(BracodeSeriale.getCodice);
              if (BracodeSeriale.getCodice.isEmpty &&
                  BracodeCodice.getCodice.isEmpty) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            Text("Devi inserire il ricambio da installare"),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Chiudi'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              } else {
                var dati = context.read<DatiInstallazioneRicambiProvider>();
                dati.addFotoInstallati(widget.FotoPath);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RicambioRimossoPage(),
                ));
              }
            },
            child: Text("Avanti", style: TextStyle(fontSize: 14)),
          ),
        ));
  }
}
