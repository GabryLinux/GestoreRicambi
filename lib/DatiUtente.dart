
import 'package:appsme/ResettableDati.dart';

class DatiUtente extends ResettableDati{
  String _nomeUtente = "";
  int _tipoUtente = 1000;
  String _pinUtente = "";
  String _codiceUtente = "";
  String _emailUtente = "";
  String _telefonoUtente = "";

  @override
  void reset() {
    _nomeUtente = "";
    _tipoUtente = 1000;
    _pinUtente = "";
    _codiceUtente = "";
    _emailUtente = "";
    _telefonoUtente = "";
  }
  
  String get nomeUtente => _nomeUtente;
  int get tipoUtente => _tipoUtente;
  String get pinUtente => _pinUtente;
  String get codiceUtente => _codiceUtente;
  String get emailUtente => _emailUtente;
  String get telefonoUtente => _telefonoUtente;
  void updateNomeUtente(String nomeUtente) {
    _nomeUtente = nomeUtente;
    notifyListeners();
  }
  void updateTipoUtente(int tipoUtente) {
    _tipoUtente = tipoUtente;
    notifyListeners();
  }
  void updatePinUtente(String pinUtente) {
    _pinUtente = pinUtente;
    notifyListeners();
  }
  void updateCodiceUtente(String codiceUtente) {
    _codiceUtente = codiceUtente;
    notifyListeners();
  }
  void updateEmailUtente(String emailUtente) {
    _emailUtente = emailUtente;
    notifyListeners();
  }
  void updateTelefonoUtente(String telefonoUtente) {
    _telefonoUtente = telefonoUtente;
    notifyListeners();
  }
  
}