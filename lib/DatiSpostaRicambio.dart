import 'package:appsme/ResettableDati.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';

class DatiSpostaRicambioProvider extends ResettableDati{
    String _serialeSpostare = "";
    String _codiceSpostare = "";
    Collega? _consegnaCollega = null;
    List<String> FotoRicambi = [];

    String get serialeSpostare => _serialeSpostare;
    String get codiceSpostare => _codiceSpostare;
    Collega? get consegnaCollega => _consegnaCollega;

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

    void updateConsegnaCollega(Collega collega){
      _consegnaCollega = collega;
      notifyListeners();
    }

    @override
    void reset() {
      _serialeSpostare = "";
      _codiceSpostare = "";
      _consegnaCollega = null;
      FotoRicambi.clear();
      notifyListeners();
    }

    
}