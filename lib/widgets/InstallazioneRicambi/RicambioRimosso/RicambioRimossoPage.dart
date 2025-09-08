import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/BarcodeWidget.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RicambioRimossoPage extends StatefulWidget {
  RicambioRimossoPage({Key? key}) : super(key: key);
  late TextEditingController codice, Seriale;
  String text = "";
  int counter = 0;
  bool check = true;
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  List<String> FotoPath = <String>[];
  @override
  State<RicambioRimossoPage> createState() => _RicambioRimossoPageState();
}

class _RicambioRimossoPageState extends State<RicambioRimossoPage> {
  var BracodeCodice = BarcodeWidget(title: "Codice");
  var BracodeSeriale = BarcodeWidget(title: "Seriale");
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
                      "Ricambio Rimosso",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    BracodeCodice, //FINE BARCODE
                    BracodeSeriale, //FINE BARCODE
                    
                    //FINE BARCODE
                    CheckboxListTile(
                        title: Text("Ricambio Guasto"),
                        value: widget.check,
                        onChanged: (value) {
                          setState(() {
                            widget.check = value!;
                          });
                        }),
                    PhotoWidget(title: "Foto del Ricambio", text: "Ricambio Rimosso", FotoPath: widget.FotoPath)
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
                var dati = context.read<DatiInstallazioneRicambiProvider>();
                dati.addFotoRimossi( widget.FotoPath);
                dati.updateCodiceRimosso(BracodeCodice.getCodice);
                dati.updateSerialeRimosso(BracodeSeriale.getCodice);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EmailSendPage(sendFunction: SenderFunctions.EmailInstallazioneRicambi),
                  ),
                );
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
