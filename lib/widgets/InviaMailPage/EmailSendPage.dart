import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/ResetDatiGenerali.dart';
import 'package:appsme/main.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class EmailSendPage extends StatelessWidget {
  final List<Collega> colleghi = [];
  final Future<void> Function(BuildContext) sendFunction;
  EmailSendPage({super.key, required this.sendFunction});

  @override
  Widget build(BuildContext context) {
    sendFunction(context).then((value) {
      context.read<ResetDatiGenerali>().resetAll(context);
      return const Scaffold();
    });
    return const Scaffold();
  }

  
}

