class Collega{
  String? nome = "";
  String? cognome = "";
  String? email = "";
  String? telefono = "";
  String? PIN = "";
  int? TipoUtente = -1;

  Collega({this.nome,this.cognome});

  Collega.fromJson(Map<dynamic, dynamic> json){
    nome = json['NOME'];
    cognome = json['COGNOME'];
    email = json['MAIL'];
    telefono = json['CELL'];
    PIN = json['PIN'];
    TipoUtente = json['TipoUtente'];
  }

  static Collega NULL = Collega(nome: "NESSUN COLLEGA", cognome: "");

  static isNull(Collega? collega){
    if(collega == null){
      return true;
    }else{
      if(collega.nome == "NESSUN COLLEGA" && collega.cognome == ""){
        return true;
      }else{
        return false;
      }
    }
  }

  @override
  String toString() {
    return nome! + " " + cognome!;
  }
}