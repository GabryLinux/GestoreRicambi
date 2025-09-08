import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/main.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class EmailSendRicezioneRicambi extends StatelessWidget {
  EmailSendRicezioneRicambi({super.key});

  Future<void> send(BuildContext context) async {
    List<String> fotos = [];
    List<String> parole = [];
    List<String> parsedXML = [];
    String utente =
        (await SharedPreferences.getInstance()).getString("User") ?? "";
    var dati = context.read<DatiInviaRicambiAMagazzinoRCProvider>();
    String puntoVendita = context.read<DatiLuogoProvider>().luogo;
    String nome = dati.vettoreCollega != null
        ? (dati.vettoreCollega!.nome! + " " + dati.vettoreCollega!.cognome!)
        : "";

    final List<String> FotoPath = dati.FotoItem;

    parole
      ..add(utente)
      ..add(nome)
      ..add(nome)
      ..add(nome);

    
    fotos..addAll(dati.FotoItem);
    String rawBody = await ParserText.getText("Body4");
    String addresses =
        "favazzicarmelo@gmail.com,smerc.areatecnica@gmail.com,smesncrc@gmail.com";
    String subject = await ParserText.getText("41");
    subject = ParserText.parserText([utente], subject, "???");
    String text = await ParserText.parserText(parole, rawBody, "???");

    await ParserText().send(context, addresses, text,
        subject, FotoPath);

    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    send(context).then((value) {
      return const Scaffold();
    });

    return const Scaffold();
  }

  
}
