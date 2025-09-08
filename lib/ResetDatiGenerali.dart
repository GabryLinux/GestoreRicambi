
import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/ResettableDati.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetDatiGenerali extends ChangeNotifier {
  List<ResettableDati> datiList = [];

  ResetDatiGenerali(){}


  void resetAll(BuildContext context) {
    context.read<DatiLuogoProvider>().reset();
    context.read<DatiSpostaRicambioProvider>().reset();
    context.read<DatiInstallazioneRicambiProvider>().reset();
    context.read<DatiInviaRicambiAMagazzinoRCProvider>().reset();
    notifyListeners();
  }


}