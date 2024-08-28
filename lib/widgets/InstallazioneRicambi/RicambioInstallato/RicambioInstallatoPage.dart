import 'dart:io';

import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
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
                            onChanged: ((value) {
                              context
                                        .read<
                                            DatiInstallazioneRicambiProvider>()
                                        .updateCodiceInstall(value);
                            }),
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
                                        .read<
                                            DatiInstallazioneRicambiProvider>()
                                        .updateCodiceInstall(res);
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
                            onChanged: ((value) {
                              context
                                        .read<
                                            DatiInstallazioneRicambiProvider>()
                                        .updateSerialeInstall(value);
                            }),
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
                                        .read<
                                            DatiInstallazioneRicambiProvider>()
                                        .updateSerialeInstall(res);
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
                    Container(
                      
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              widget.counter++;
                              final XFile? photo = await widget._picker
                                  .pickImage(source: ImageSource.camera);
                                  String path = photo!.path.replaceFirst(photo.name, "Ricambio Installato ${widget.counter}.png");
                              await photo.saveTo(path);
                              setState(() {
                                if(photo.path != null){
                                  widget.FotoPath.add(path);
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
                            height: MediaQuery.of(context).size.height*0.20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey.shade300
                              )
                            ),
                            child: ListView.builder(
                            itemCount: widget.FotoPath.length,
                            shrinkWrap: true,
                            itemBuilder: (context,i){
                              debugPrint(i.toString());
                              return ImageRicambioItem(
                                key: Key(i.toString()),
                                Nome: i.toString(), 
                                DeleteFunc: () {
                                  setState(() {
                                    widget.FotoPath.removeAt(i);
                                  });
                                }
                              );
                              //return Container();
                            }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //FINE AVANTI-INDIETRO
            ],
          ),
        ),
      floatingActionButton: 
      Container(
        height: 50,
        width: 100,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
          onPressed: () async {
            if(widget.Seriale.text.isEmpty && widget.codice.text.isEmpty){
              showDialog(
                context: context, 
                builder:  (context) {
                  return AlertDialog(
                    content: Text("Devi inserire il ricambio da installare"),
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
                }
              );
            }else{
              var dati =  context.read<DatiInstallazioneRicambiProvider>();
              dati.addFotoInstallati(widget.FotoPath);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RicambioRimossoPage(),
                )
              );
            }
          },
          child: Text(
            "Avanti",
            style: TextStyle(
              fontSize: 14
            )
          ),
        ),
    )
      );
  }
}
