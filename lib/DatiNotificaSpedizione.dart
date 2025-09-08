import 'package:appsme/ResettableDati.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';

class DatiNotificaSpedizione extends ResettableDati {
  String _codiceSpostare = "";
  Collega? _vettoreCollega;
  Collega? _destinatarioCollega;
  bool _dataSpedizioneSelezionata = false;
  DateTime? _dataSpedizione;
  DateTime? _dataConsegna;
  List<String> FotoItem = [];

  String get codiceSpostare => _codiceSpostare;
  Collega? get vettoreCollega => _vettoreCollega;
  Collega? get destinatarioCollega => _destinatarioCollega;
  List<String> get fotoItem => FotoItem;
  DateTime? get dataConsegna => _dataConsegna;
  bool get dataSpedizioneSelezionata => _dataSpedizioneSelezionata;
  DateTime? get dataSpedizione => _dataSpedizione;

  void addFoto(List<String> foto) {
    for (var element in foto) {
      FotoItem.add(element);
    }
  }

  void removeFoto(int index) {
    FotoItem.removeAt(index);
  }

  void updateCodiceSpostare(String codice) {
    _codiceSpostare = codice;
    notifyListeners();
  }

  void updateCollegaVettore(Collega collega) {
    _vettoreCollega = collega;
    notifyListeners();
  }

  void updateCollegaDestinatario(Collega collega) {
    _destinatarioCollega = collega;
    notifyListeners();
  }

  void updateDataConsegna(DateTime data) {
    _dataConsegna = data;
    notifyListeners();
  }

  void updateDataSpedizioneSelezionata(bool selezionata) {
    _dataSpedizioneSelezionata = selezionata;
    notifyListeners();
  }
  void updateDataSpedizione(DateTime data) {
    _dataSpedizione = data;
    notifyListeners();
  }
  
  @override
  void reset() {
    _codiceSpostare = "";
    _vettoreCollega = null;
    _destinatarioCollega = null;
    _dataSpedizione = null;
    _dataConsegna = null;
    _dataSpedizioneSelezionata = false;
    FotoItem = [];
    notifyListeners();
  }
}
