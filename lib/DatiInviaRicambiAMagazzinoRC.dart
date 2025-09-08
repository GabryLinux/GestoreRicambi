import 'package:appsme/ResettableDati.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';

class DatiInviaRicambiAMagazzinoRCProvider extends ResettableDati{
    String _luogoRitiro = "";
    String _codiceSpostare = "";
    Collega? _vettoreCollega;
    List<String> FotoItem = [];

    String get luogoRitiro => _luogoRitiro;
    String get codiceSpostare => _codiceSpostare;
    Collega? get vettoreCollega => _vettoreCollega;

    void addFotoRicambi(List<String> foto){
      for (var element in foto) {
        FotoItem.add(element);
      }
    }

    void removeFotoInstallati(int index){
      FotoItem.removeAt(index);
    }

    void updateCodiceSpostare(String codice){
      _codiceSpostare = codice;
      notifyListeners();
    }

    void updateConsegnaCollega(Collega collega){
      _vettoreCollega = collega;
      notifyListeners();
    }

    @override
    void reset() {
      _luogoRitiro = "";
      _codiceSpostare = "";
      _vettoreCollega = null;
      FotoItem = [];
      notifyListeners();
    }
}