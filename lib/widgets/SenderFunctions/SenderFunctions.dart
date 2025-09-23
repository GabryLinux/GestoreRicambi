import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiNotificaSpedizione.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/main.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SenderFunctions {
  static Future<void> EmailInviaRicambiMagazzinoRC(BuildContext context) async {
    List<String> fotos = [];
    List<String> parole = [];
    String noteVettore = await ParserText.getText("24");
    String utente =
        (await SharedPreferences.getInstance()).getString("User") ?? "";
    var dati = context.read<DatiInviaRicambiAMagazzinoRCProvider>();
    String puntoVendita = context.read<DatiLuogoProvider>().luogo;
    String nome = dati.vettoreCollega.toString();

    final List<String> FotoPath = dati.FotoItem;

    parole
      ..add(utente)
      ..add(nome)
      ..add(dati.vettoreCollega!.telefono ?? "")
      ..add(dati.vettoreCollega!.email ?? "");

    // CASO 1
    if (Collega.isNull(dati.vettoreCollega) && puntoVendita.isEmpty) {
      String consegnaDirettaA = await ParserText.getText("25");
      parole..add(consegnaDirettaA);
    }
    // CASO 2
    else if (!Collega.isNull(dati.vettoreCollega) && puntoVendita.isNotEmpty) {
      String text1 = await ParserText.getText("27");
      text1 = ParserText.parserText([puntoVendita], text1, "???");

      String text2 = await ParserText.getText("26");
      text2 = ParserText.parserText([nome], text2, "???");
      parole..add(text1 + "\n" + text2);
    }
    // CASO 3
    else if (Collega.isNull(dati.vettoreCollega) && puntoVendita.isNotEmpty) {
      String text1 = await ParserText.getText("27");
      text1 = ParserText.parserText([puntoVendita], text1, "???");

      String text2 = await ParserText.getText("28");
      parole.add(text1 + "\n" + text2);
      parole.add("");
    }
    parole.add(noteVettore);
    fotos..addAll(dati.FotoItem);
    String rawBody = await ParserText.getText("Body3");
    String TOAddr = await ParserText.getText("TOAddr3");
    String CCAddr = await ParserText.getText("CCAddr3");
    String subject = await ParserText.getText("22");
    String destinazione = await ParserText.getText("23");

    String text = await ParserText.parserText(parole, rawBody, "???");
    CCAddr += ",${dati.vettoreCollega!.email ?? ""}";

    await ParserText().send(context, TOAddr, CCAddr, text,
        subject + " " + utente + " " + destinazione, FotoPath);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  static Future<void> EmailSendRicezioneRicambi(BuildContext context) async {
    List<String> fotos = [];
    List<String> parole = [];
    String utente =
        (await SharedPreferences.getInstance()).getString("User") ?? "";
    var dati = context.read<DatiInviaRicambiAMagazzinoRCProvider>();

    final List<String> FotoPath = dati.FotoItem;

    parole.add(utente);

    fotos..addAll(dati.FotoItem);
    String rawBody = await ParserText.getText("Body4");
    String TOAddr = await ParserText.getText("TOAddr4");
    String CCAddr = await ParserText.getText("CCAddr4");
    String subject = await ParserText.getText("41");
    subject = ParserText.parserText([utente], subject, "???");
    String text = await ParserText.parserText(parole, rawBody, "???");

    await ParserText().send(context, TOAddr, CCAddr, text, subject, FotoPath);

    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  static Future<void> EmailNotificaSpedizione(BuildContext context) async {
    List<String> fotos = [];
    List<String> parole = [];

    String utente =
        (await SharedPreferences.getInstance()).getString("User") ?? "";
    var dati = context.read<DatiNotificaSpedizione>();
    String puntoVendita = context.read<DatiLuogoProvider>().luogo;

    final List<String> FotoPath = dati.FotoItem;

    parole
      ..add(utente)
      ..add(dati.destinatarioCollega.toString());

    if (Collega.isNull(dati.vettoreCollega)) {
      String text1 = await ParserText.getText("51");
      parole
        ..add(text1)
        ..add("")
        ..add("");
    } else {
      parole
        ..add(dati.vettoreCollega.toString())
        ..add(dati.vettoreCollega!.telefono ?? "")
        ..add(dati.vettoreCollega!.email ?? "");
    }
    if (dati.dataSpedizioneSelezionata == true) {
      parole.add(
          "${dati.dataSpedizione!.day}/${dati.dataSpedizione!.month}/${dati.dataSpedizione!.year}");
    } else {
      var text = await ParserText.getText("52");
      parole.add(text);
    }

    // CASO 1
    if (!Collega.isNull(dati.vettoreCollega) && puntoVendita.isNotEmpty) {
      String text1 = await ParserText.getText("54");
      text1 = ParserText.parserText([puntoVendita], text1, "???");
      String text2 = await ParserText.getText("55");
      parole.add(text1 + "\n" + text2);
    }
    // CASO 2
    else if (!Collega.isNull(dati.vettoreCollega) && puntoVendita.isEmpty) {
      String text1 = await ParserText.getText("56");
      parole.add(text1);
    }
    // CASO 3
    else if (Collega.isNull(dati.vettoreCollega) && puntoVendita.isNotEmpty) {
      debugPrint("CASO 3");
      String text1 = await ParserText.getText("54");
      text1 = ParserText.parserText([puntoVendita], text1, "???");
      String text2 = await ParserText.getText("57");
      parole.add(text1 + "\n" + text2);
    } else {
      String text1 = await ParserText.getText("58");
      parole.add(text1);
    }
    String text2 = await ParserText.getText("53");
    parole.add(!Collega.isNull(dati.vettoreCollega) ? text2 : "");

    fotos..addAll(dati.FotoItem);
    String rawBody = await ParserText.getText("Body5");
    String TOAddr = await ParserText.getText("TOAddr5");
    String CCAddr = await ParserText.getText("CCAddr5");
    String subject = await ParserText.getText("50");
    subject = ParserText.parserText([
      utente,
      dati.destinatarioCollega!.nome! + " " + dati.destinatarioCollega!.cognome!
    ], subject, "???");
    String text = await ParserText.parserText(parole, rawBody, "???");
    CCAddr += ",${dati.vettoreCollega!.email ?? ""}";
    TOAddr += ",${dati.destinatarioCollega!.email ?? ""}";

    await ParserText().send(context, TOAddr, CCAddr, text, subject, FotoPath);

    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  static Future<void> EmailRicambioDaSpostare(BuildContext context) async {
    String subject = "NOTIFICA SPOSTAMENTO RICAMBIO";
    var dati = context.read<DatiSpostaRicambioProvider>();
    var direzioneSpostamento = (String collega) =>
        "INVIA A \n--------------------------------------------------------------\n$collega";
    List<String> parole = [];
    final pref = await SharedPreferences.getInstance();
    var utente = pref.getString("User");
    parole
      ..add(utente!)
      ..add(dati.codiceSpostare)
      ..add(dati.serialeSpostare);
    if (!Collega.isNull(dati.consegnaCollega)) {
      parole.add(direzioneSpostamento(dati.consegnaCollega.toString()));
    } else {
      parole.add(direzioneSpostamento("Magazzino Principale SME"));
    }
    final List<String> FotoPath = dati.FotoRicambi;
    String rawBody = await ParserText.getText("Body2");
    String TOAddr = await ParserText.getText("TOAddr2");
    String CCAddr = await ParserText.getText("CCAddr2");
    rawBody = ParserText.parserText(parole, rawBody, "???");
    await ParserText()
        .send(context, TOAddr, CCAddr, rawBody, subject, FotoPath);

    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  static Future<void> EmailInstallazioneRicambi(BuildContext context) async {
    List<String> fotos = [];
    List<String> parole = [];
    var dati = context.read<DatiInstallazioneRicambiProvider>();
    final pref = await SharedPreferences.getInstance();
    var utente = pref.getString("User");
    parole
      ..add(utente!)
      ..add(context.read<DatiLuogoProvider>().luogo)
      ..add(dati.codiceInstall)
      ..add(dati.serialeInstall);
    if (dati.codiceRimosso.isEmpty && dati.serialeRimosso.isEmpty) {
      parole.add("");
    } else {
      if (dati.guasto) {
        parole.add("GUASTO");
      } else {
        parole.add("NON GUASTO");
      }
    }
    parole
      ..add(dati.codiceRimosso)
      ..add(dati.serialeRimosso);

    fotos
      ..addAll(dati.FotoInstallati)
      ..addAll(dati.FotoRimossi);
    String rawBody = await ParserText.getText("Body1");
    rawBody = ParserText.parserText(parole, rawBody, "???");
    String TOAddr = await ParserText.getText("TOAddr1");
    String CCAddr = await ParserText.getText("CCAddr1");
    String subject = "Notifica Installazione Ricambio";
    await ParserText().send(context, TOAddr, CCAddr, rawBody, subject, fotos);

    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }
}
