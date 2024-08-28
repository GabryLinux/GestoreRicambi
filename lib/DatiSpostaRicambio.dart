import 'package:flutter/material.dart';

class DatiSpostaRicambioProvider extends ChangeNotifier{
    String _serialeSpostare = "";
    String _codiceSpostare = "";
    String _consegnaCollega = "";
    List<String> FotoRicambi = [];

    String get serialeSpostare => _serialeSpostare;
    String get codiceSpostare => _codiceSpostare;
    String get consegnaCollega => _consegnaCollega;

    void addFotoRicambi(List<String> foto){
      for (var element in foto) {
        FotoRicambi.add(element);
      }
    }

    void removeFotoInstallati(int index){
      FotoRicambi.removeAt(index);
    }

    void updateSerialeSpostare(String seriale){
      _serialeSpostare = seriale;
      notifyListeners();
    }

    void updateCodiceSpostare(String codice){
      _codiceSpostare = codice;
      notifyListeners();
    }

    void updateConsegnaCollega(String collega){
      _consegnaCollega = collega;
      notifyListeners();
    }
}