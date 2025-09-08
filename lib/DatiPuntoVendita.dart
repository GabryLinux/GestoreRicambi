import 'package:appsme/ResettableDati.dart';

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