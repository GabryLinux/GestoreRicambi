import 'package:appsme/ResettableDati.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:flutter/material.dart';

class DatiLuogoProvider extends ResettableDati{
    String _luogo = "";

    String get luogo => _luogo;

    void updateLuogo(String luogo) {
        _luogo = luogo;
        notifyListeners();
    }

    @override
    void reset() {
      _luogo = "";
      notifyListeners();
    }
}