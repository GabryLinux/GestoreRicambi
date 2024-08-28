class Collega{
  String? nome = "";
  String? cognome = "";

  Collega({this.nome,this.cognome});

  Collega.fromJson(Map<String, dynamic> json){
    nome = json['NOME'];
    cognome = json['COGNOME'];
  }
}