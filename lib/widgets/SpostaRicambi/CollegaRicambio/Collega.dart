class Collega{
  String? nome = "";
  String? cognome = "";

  Collega({this.nome,this.cognome});

  Collega.fromJson(Map<String, dynamic> json){
    nome = json['NOME'];
    cognome = json['COGNOME'];
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