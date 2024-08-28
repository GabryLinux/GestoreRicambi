// ignore_for_file: prefer_const_literals_to_create_immutables


import 'dart:io';

import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

class InviaMail extends StatefulWidget {
  InviaMail({Key? key}) : super(key: key);
  String text = "";
  TextEditingController mailController = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController address = TextEditingController();
  List<String> FotoPath = <String>[];
  List<String> parsedXML = []; //0: mailto, 1: subject, 2: body
  @override
  State<InviaMail> createState() => _InviaMailState();
}

SnackBar snackBarPos = SnackBar(
  content: Text('Mail Inviata'),
  duration: Duration(milliseconds: 2000),
  action: SnackBarAction(label: "Chiudi", onPressed: (){})
);

SnackBar snackBarNeg (String err){
  return SnackBar(
    content: Text('Errore! : $err'),
    duration: Duration(milliseconds: 5000),
  );
} 



class _InviaMailState extends State<InviaMail> {

  @override
  void initState() {
    var dati = context.read<DatiInstallazioneRicambiProvider>();
    List<String> parole = [];
    parole
    ..add(dati.codiceInstall)
    ..add(dati.serialeInstall)
    ..add(dati.codiceRimosso)
    ..add(dati.serialeRimosso);

    widget.FotoPath
    ..addAll(dati.FotoInstallati)
    ..addAll(dati.FotoRimossi);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      //widget.parsedXML = await rootBundle.loadString(ParserText.txtPath);
      widget.text = await ParserText.parserRicambio(parole);
      var XML = XmlDocument.parse(widget.text).children[0].descendantElements;
      for(var node in XML){
        if(node.innerText != " "){
          widget.parsedXML.add(node.innerText.trim());
        }  
      }
      widget.address.text = widget.parsedXML[0];
      widget.subject.text = widget.parsedXML[1];
      widget.mailController.text = widget.parsedXML[2];


    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> send() async {
    List<String> addresses = [];
    addresses.add(widget.address.text);
    final Email email = Email(
      recipients: addresses,
      body: widget.mailController.text,
      subject: widget.subject.text,
      attachmentPaths: widget.FotoPath,
      isHTML: true,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      debugPrint(error.toString());
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

    //debugPrint(context.read<DatiInstallazioneRicambiProvider>().codiceInstall);
    return Scaffold(
      appBar: AppBar(title: const Text("App SME")),
      body: Container(
        //alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "Anteprima MAIL",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                Container(
                  padding: EdgeInsets.all(7),
                ),
                TextField(
                  controller: widget.address,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Indirizzo dell'email",
                    labelStyle: TextStyle(fontSize: 18)
                  ),
                ),
                Container(padding: EdgeInsets.all(10)),
                TextField(
                  controller: widget.subject,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Oggetto dell'email",
                    labelStyle: TextStyle(fontSize: 18)
                  ),
                ),
                Container(padding: EdgeInsets.all(10),),
                TextField(
                  controller: widget.mailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Corpo dell'email",
                    labelStyle: TextStyle(fontSize: 18)
                  ),
                  maxLines: 15,
                ),
                Container(
                  child: Text("Allegati",style: TextStyle(fontSize: 18),),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                
              ],
            ),
            OutlinedButton(
              onPressed: () async {
                var urlLauncher = '';
                if(widget.parsedXML.isNotEmpty){
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
                  style: TextStyle(
                     
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
