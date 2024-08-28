import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/InviaMail/InviaMail.dart';
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
  String? dropdownValue = null;
  String text = "";
  List<Collega> colleghi = [];
  final ImagePicker _picker = ImagePicker();
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  bool check = false;
  List<String> FotoPath = <String>[];

  @override
  State<RicambioDaSpostare> createState() => _RicambioDaSpostareState();
}

class _RicambioDaSpostareState extends State<RicambioDaSpostare> {

  var direzioneSpostamento = (String collega) => "INVIA A \n--------------------------------------------------------------\n$collega";

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore.instance.collection('0').get().then((value) {
        var item = value.docs[0];
        List<Map<String, dynamic>> itemJson = [];

        int i = 0;
        while (item.data()[i.toString()] != null) {
          if (item.data()[i.toString()]['NOME'] != "") {
            //AGGIUNGO SOLO SE I CAMPI SONO PIENI
            widget.colleghi.add(Collega.fromJson(item.data()[i.toString()]));
          }
          i++;
        }
        setState(() {});
      });
    });

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.40,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 5),
                                title: Text("Invia a Collega", style: TextStyle(fontSize: 14),),
                                value: widget.check,
                                onChanged: ((value) {
                                  setState(() {
                                    widget.check = value!;
                                  });
                                }))),
                        Visibility(
                            visible: widget.check,
                            child: DropdownButton<String>(
                                value: widget.dropdownValue,
                                onChanged: (String? value) {
                                  context
                                      .read<DatiSpostaRicambioProvider>()
                                      .updateConsegnaCollega(value!);
                                  setState(() {
                                    widget.dropdownValue = value;
                                  });
                                },
                                hint: Text("Consegna a"),
                                items: widget.colleghi
                                    .map<DropdownMenuItem<String>>(
                                        (Collega value) {
                                  return DropdownMenuItem<String>(
                                    value: value.nome! + " " + value.cognome!,
                                    child: Text(
                                        value.nome! + " " + value.cognome!),
                                  );
                                }).toList())),
                      ],
                    ),

                    Container(
                      child: Column(
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                final XFile? photo = await widget._picker
                                    .pickImage(source: ImageSource.camera);
                                setState(() {
                                  if (photo?.path != null) {
                                    widget.FotoPath.add(photo!.path);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  "Scatta una foto del Ricambio",
                                  style: TextStyle(fontSize: 14),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: ListView.builder(
                                itemCount: widget.FotoPath.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  debugPrint(i.toString());
                                  return ImageRicambioItem(
                                      key: Key(i.toString()),
                                      Nome: i.toString(),
                                      DeleteFunc: () {
                                        setState(() {
                                          widget.FotoPath.removeAt(i);
                                        });
                                      });
                                  //return Container();
                                }),
                          )
                        ],
                      ),
                    ),
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
                List<String> parole = [];
                final pref = await SharedPreferences.getInstance();
                var utente = pref.getString("User");
                parole
                  ..add(utente!)
                  ..add(dati.codiceSpostare)
                  ..add(dati.serialeSpostare);
                if(widget.check){
                  parole.add(direzioneSpostamento(dati.consegnaCollega));
                }else{
                  parole.add(direzioneSpostamento("Magazzino Principale SME"));
                }   

                widget.FotoPath.addAll(dati.FotoRicambi);
                widget.text = await ParserText.parserRicambioSpostare(parole);
                var XML = XmlDocument.parse(widget.text)
                    .children[0]
                    .descendantElements;
                for (var node in XML) {
                  if (node.innerText != " ") {
                    widget.parsedXML.add(node.innerText.trim());
                  }
                }
                if (widget.parsedXML.isNotEmpty) {
                  /*
                  urlLauncher = 'mailto:${widget.parsedXML[0]}?subject=${widget.parsedXML[1]}&body=${widget.parsedXML[2].replaceAll(', ', '\n')}';
                  launchUrl(Uri.parse(urlLauncher))
                  .then(
                    (value) {
                      if(value){
                        ScaffoldMessenger.of(context).showSnackBar(snackBarPos);
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    }).onError(
                      (error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBarNeg(error.toString()));
                      } );
                    */
                  await send();
                }
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
