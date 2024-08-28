import 'dart:io';

import 'package:flutter/material.dart';

class DatiInstallazioneRicambiProvider extends ChangeNotifier{
    String _serialeInstall = "";
    String _codiceInstall = "";
    String _serialeRimosso = "";
    String _codiceRimosso = "";
    String _puntoVendita = "";
    List<String> FotoInstallati = [];
    List<String> FotoRimossi = [];

    String get serialeInstall => _serialeInstall;
    String get codiceInstall => _codiceInstall;
    String get serialeRimosso => _serialeRimosso;
    String get codiceRimosso => _codiceRimosso;
    String get puntoVendita => _puntoVendita;

    void addFotoInstallati(List<String> foto){
      for (var element in foto) {
        FotoInstallati.add(element);
      }
    }

    void addFotoRimossi(List<String> foto){
      for (var element in foto) {
        FotoRimossi.add(element);
      }
    }

    void removeFotoInstallati(int index){
      FotoInstallati.removeAt(index);
    }

    void removeFotoRimossi(int index){
      FotoRimossi.removeAt(index);
    }

    void updatePuntoVendita (String punto){
      _puntoVendita = punto;
      notifyListeners();
    }

    void updateSerialeInstall(String seriale){
      debugPrint("AGIORNAMENTO");
      _serialeInstall = seriale;
      notifyListeners();
    }

    void updateCodiceInstall(String codice){
      debugPrint("AGIORNAMENTO");
      _codiceInstall = codice;
      notifyListeners();
    }

    void updateSerialeRimosso(String seriale){
      _serialeRimosso = seriale;
      notifyListeners();
    }

    void updateCodiceRimosso(String seriale){
      _codiceRimosso = seriale;
      notifyListeners();
    }


}